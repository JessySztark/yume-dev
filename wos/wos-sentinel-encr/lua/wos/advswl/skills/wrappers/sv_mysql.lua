--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2020
	
	Contact: www.wiltostech.com
		----------------------------------------]]--
local MYSQL_DATABASE_PROVISION = 2

wOS = wOS or {}
wOS.ALCS.Config.Skills.SkillDatabase = wOS.ALCS.Config.Skills.SkillDatabase or {}
local TableToSkill = {}
local SkillToTable = {}

local DATA

require('mysqloo')
DATA = mysqloo.CreateDatabase( wOS.ALCS.Config.Skills.SkillDatabase.Host, wOS.ALCS.Config.Skills.SkillDatabase.Username, wOS.ALCS.Config.Skills.SkillDatabase.Password, wOS.ALCS.Config.Skills.SkillDatabase.Database, wOS.ALCS.Config.Skills.SkillDatabase.Port, wOS.ALCS.Config.Skills.SkillDatabase.Socket )
if not DATA then
	print( "[wOS] MySQL Database connection failed. Falling back to PlayerData" )
	wOS.ALCS.Config.Skills.ShouldSkillUseMySQL = false
else
	print( "[wOS] Skill Tree MySQL connection was successful!" )	
end


local MYSQL_COLUMNS_GENERAL = "( SteamID bigint(64) UNSIGNED, Level int, Experience bigint, CharID BIGINT(64) DEFAULT 1, SkillPoints int )"
local MYSQL_COLUMNS_SKILLTREE = "( SteamID bigint(64) UNSIGNED, CurrentSkills varchar(255), CharID BIGINT(64) DEFAULT 1 )"
local MYSQL_COLUMNS_WL = "( SteamID bigint(64) UNSIGNED, SkillTree VARCHAR(255), CharID BIGINT(64) DEFAULT 1 )"

function wOS.ALCS.Config.Skills.SkillDatabase:UpdateTables( vdat )

	vdat = vdat or {}
	local version = vdat.DBVersion or 0
	
	if version >= MYSQL_DATABASE_PROVISION then return end
	
	--This is about to be the most cancerous thing ever, but it will be moved to a different file eventually.
	
	if version < 1 then
		DATA:RunQuery( "CREATE TABLE IF NOT EXISTS leveldata " .. MYSQL_COLUMNS_GENERAL )
		DATA:RunQuery( "CREATE TABLE IF NOT EXISTS skill_whitelists " .. MYSQL_COLUMNS_WL )	
		DATA:RunQuery( "ALTER TABLE leveldata ADD COLUMN CharID BIGINT(64) DEFAULT 1" )
		DATA:RunQuery( "ALTER TABLE skill_whitelists ADD UNIQUE INDEX wos_skillwl_UX1 (SteamID,SkillTree,CharID)" )
		for name, _ in pairs( wOS.SkillTrees ) do
			local tablename = string.Replace( name, " ", "-" )
			DATA:RunQuery( "ALTER TABLE `" .. DATA:escape( tablename ) .. "` ADD COLUMN CharID BIGINT(64) DEFAULT 1" )
		end
		version = version + 1
	end

	if version < 2 then
		DATA:RunQuery( "ALTER TABLE leveldata ADD UNIQUE INDEX wos_skilllevel_UX1 (SteamID,CharID)" )
		version = version + 1		
	end
	
	DATA:RunQuery( "INSERT INTO wos_alcsskill_schema ( ID, DBVersion ) VALUES ( '1', '" .. version .. "' ) ON DUPLICATE KEY UPDATE DBVersion='" .. version .. "'" )
	
end 

function wOS.ALCS.Config.Skills.SkillDatabase:Initialize()
	
	local CTRANS = DATA:CreateTransaction()
	for name, _ in pairs( wOS.SkillTrees ) do
		local tablename = string.Replace( name, " ", "-" )
		TableToSkill[ tablename ] = name
		SkillToTable[ name ] = tablename
		CTRANS:Query( "CREATE TABLE IF NOT EXISTS `" .. DATA:escape( tablename ) .. "` " .. MYSQL_COLUMNS_SKILLTREE )
	end
	CTRANS:Start( function(transaction, status, err)
	if (!status) then print("[MYSQL ERROR] " .. err) end 
		for _, tablename in pairs( SkillToTable ) do	
			DATA:RunQuery( "ALTER TABLE `" .. DATA:escape( tablename ) .. "` ADD UNIQUE INDEX wos_skilldata_UX1 (SteamID,CharID)", function( queries, statuss, errr )
				if not statuss then
					if !errr:find( "Duplicate key name" ) then
						error( errr ) //Suppress the ALREADY EXISTS error because that's going to be happening alot unless we dump a second query here. For now this will do
					end
				end 
			end )
		end
	end )

	local VERSION_CHECK = DATA:CreateTransaction()
	VERSION_CHECK:Query( "SHOW TABLES LIKE 'wos_alcsskill_schema'" )
	VERSION_CHECK:Start( function( transaction, status, err )
		if (!status) then print("[MYSQL ERROR] " .. err) end
		local queries = transaction:getQueries()
		local rows = queries[1]:getData()
		local UCHECK = DATA:CreateTransaction()
		if table.Count( rows ) < 1 then
			UCHECK:Query( "CREATE TABLE IF NOT EXISTS wos_alcsskill_schema ( `ID` bigint unsigned NOT NULL AUTO_INCREMENT, DBVersion bigint unsigned, PRIMARY KEY (`ID`) )" )
			UCHECK:Start( function(transaction, status, err) if (!status) then print("[MYSQL ERROR] " .. err) end end )
			wOS.ALCS.Config.Skills.SkillDatabase:UpdateTables()
		else
			UCHECK:Query( "SELECT * FROM wos_alcsskill_schema" )
			UCHECK:Start( function( transaction, status, err )
				if (!status) then print("[MYSQL ERROR] " .. err) end
				local queries = transaction:getQueries()
				local dat = queries[1]:getData()
				wOS.ALCS.Config.Skills.SkillDatabase:UpdateTables( dat[1] )
			end )
		end
	end )

	
end

function wOS.ALCS.Config.Skills.SkillDatabase:LoadData( ply )

	if ply:IsBot() then return end
	local steam64 = ply:SteamID64()
	local charid = wOS.ALCS:GetCharacterID( ply ) or 1
	if charid < 1 then return end

	ply.EquippedSkills = {}	
	ply.SkillTree = {}	
	ply.WOS_SkillTreeWhitelists = {}	

	ply:SetSkillLevel( 0 )
	ply:SetSkillXP( 0 )
	ply:SetSkillPoints( 0 )		

	local TRANS = DATA:CreateTransaction()		
	TRANS:Query( "SELECT * FROM leveldata WHERE SteamID = '" .. steam64 .. "' AND CharID = '" .. charid .. "'" )
	TRANS:Query( "SELECT * FROM skill_whitelists WHERE SteamID = '" .. steam64 .. "' AND CharID = '" .. charid .. "'" )
	local skill_trans = {}
	local index = 1
	for name, _ in pairs( wOS.SkillTrees ) do
		index = index + 1
		TRANS:Query( "SELECT CurrentSkills FROM `" .. DATA:escape( SkillToTable[ name ] ) .. "` WHERE SteamID = '" .. steam64 .. "' AND CharID = '" .. charid .. "'" )
		skill_trans[ index ] = name
	end
	TRANS:Start(function(transaction, status, err)
		if (!status) then print("[MYSQL ERROR] " .. err) end
		
		local queries = transaction:getQueries()
		local C_TRANS = DATA:CreateTransaction()	
		local leveldata = queries[1]:getData()
		if table.Count( leveldata ) < 1 then
			creation_needed = true
			C_TRANS:Query( "INSERT INTO leveldata ( SteamID, Level, Experience, SkillPoints, CharID ) VALUES ( '" .. steam64 .. "','"  .. 0 .. "','" .. 0 .. "','" .. 0 .. "', '" .. charid .. "')" )
		else
			leveldata = leveldata[1]
			ply:SetSkillLevel( leveldata.Level )
			ply:SetSkillXP( leveldata.Experience )
			ply:SetSkillPoints( leveldata.SkillPoints )
		end
		
		local whitelists = queries[2]:getData()
		if table.Count( whitelists ) > 0 then
			for _, dat in pairs( whitelists ) do
				ply.WOS_SkillTreeWhitelists[ dat.SkillTree ] = true
			end
		end		
		
		local creation_needed = false
		for i = 2, index do
			local skilldata = queries[ i + 1 ]:getData()
			local name = skill_trans[ i ]
			if table.Count( skilldata ) < 1 then
				creation_needed = true
				C_TRANS:Query( "INSERT INTO `" .. DATA:escape( SkillToTable[ name ] ) .. "` ( SteamID, CurrentSkills, CharID ) VALUES ( '" .. steam64 .. "','', '" .. charid .. "')" )	
			else
				skilldata = skilldata[1]
				local treedata = wOS:GetSkillTreeData( name )
				local skills = string.Explode( ";", skilldata.CurrentSkills )
				local flag = false
				local total = 0
				if treedata.UserGroups then
					if not table.HasValue( treedata.UserGroups, ply:GetUserGroup() ) then 
						flag = true
					end
				end
				for _, readdata in pairs( skills ) do
					local data = string.Explode( ",", readdata )
					local tier = tonumber( data[1] )
					local skill = tonumber( data[2] )
					if not treedata.Tier[ tier ] then continue end
					local skilldata = treedata.Tier[ tier ][ skill ]
					if not skilldata then continue end
					if flag then
						if skilldata.PointsRequired then 
							total = total + skilldata.PointsRequired
						end
						continue
					end
					if not ply.EquippedSkills[ name ] then ply.EquippedSkills[ name ] = {} end
					if not ply.EquippedSkills[ name ][ tier ] then ply.EquippedSkills[ name ][ tier ] = {} end
					ply.EquippedSkills[ name ][ tier ][ skill ] = true
					if not ply.SkillTree[ name ] then ply.SkillTree[ name ] = {} end
					ply.SkillTree[ name ][ skilldata.Name ] = skilldata
				end
				if flag then
					ply:AddSkillPoints( total )
				end
			end
		end
		if creation_needed then
			C_TRANS:Start(function(transaction, status, err) end)
		end
		wOS:TransmitSkillData( ply )
		wOS:TransmitWhitelistData( ply )
		ply:SetCurrentSkillHooks()
	end)
	
end

function wOS.ALCS.Config.Skills.SkillDatabase:AddWhitelist( ply, tree )
	if not ply then return end
	if not ply.WOS_SkillTreeWhitelists then return end
	if not wOS.SkillTrees[ tree ] then return end
	
	local steam64 = ply:SteamID64()	
	local charid = wOS.ALCS:GetCharacterID( ply ) or 1
	if charid < 1 then return end

	DATA:RunQuery( [[ INSERT INTO skill_whitelists (SteamID, SkillTree, CharID) VALUES( ']] .. steam64 .. [[',']] .. DATA:escape( tree ) .. [[', ']] .. charid .. [[') ON DUPLICATE KEY UPDATE CharID = ]] .. charid )	
	wOS:TransmitWhitelistData( ply )
	
end

function wOS.ALCS.Config.Skills.SkillDatabase:RemoveWhitelist( ply, tree )
	if not ply then return end
	if not ply.WOS_SkillTreeWhitelists then return end
	if not wOS.SkillTrees[ tree ] then return end

	local steam64 = ply:SteamID64()
	local charid = wOS.ALCS:GetCharacterID( ply ) or 1
	if charid < 1 then return end

	DATA:RunQuery( [[ DELETE FROM skill_whitelists WHERE SteamID = ']] .. steam64 .. [[' AND CharID = ']] .. charid .. [[' AND SkillTree = ']] .. DATA:escape( tree ) .. [[']] )
	wOS:TransmitWhitelistData( ply )	
	
end


function wOS.ALCS.Config.Skills.SkillDatabase:SaveData( ply )

	if ply:IsBot() then return end
	local steam64 = ply:SteamID64()
	if not ply.EquippedSkills then return end
	if not ply.SkillTree then return end
	local charid = wOS.ALCS:GetCharacterID( ply ) or 1
	if charid < 1 then return end

	local builddata = {}
	for name, tierdata in pairs( ply.EquippedSkills ) do
		builddata[ name ] = ""
		for tier, skilldata in pairs( tierdata ) do
			for skill, _ in pairs( skilldata ) do
				builddata[ name ] = builddata[ name ] .. tier .. "," .. skill .. ";"
			end
		end
	end
	local TRANS = DATA:CreateTransaction()		
	TRANS:Query( "UPDATE leveldata SET Level = " .. ply:GetSkillLevel() .. ", Experience = " .. ply:GetSkillXP() .. ", SkillPoints = " .. ply:GetSkillPoints() .. " WHERE SteamID = " .. steam64 .. "  AND CharID = '" .. charid .. "'" )
	for name, _ in pairs( wOS.SkillTrees ) do
		if builddata[ name ] then
			TRANS:Query( "UPDATE `" .. DATA:escape( SkillToTable[ name ] ) .. "` SET CurrentSkills = '" .. builddata[ name ] .. "' WHERE SteamID = " .. steam64 .. "  AND CharID = '" .. charid .. "'" )
		end
	end
	TRANS:Start(function(transaction, status, err)
		if (!status) then print("[MYSQL ERROR] " .. err) end
	end)

end

function wOS.ALCS.Config.Skills.SkillDatabase:DeleteData( ply, charid )

	if ply:IsBot() then return end
	local steam64 = ply:SteamID64()
	if charid < 1 then return end

	DATA:RunQuery( "DELETE FROM leveldata WHERE SteamID = '" .. steam64 .. "' AND CharID = " .. charid )
	DATA:RunQuery( "DELETE FROM skill_whitelists WHERE SteamID = '" .. steam64 .. "' AND CharID = " .. charid )
	for _, tablename in pairs( SkillToTable ) do	
		DATA:RunQuery( "DELETE FROM " .. DATA:escape( tablename ) .. " WHERE SteamID = '" .. steam64 .. "' AND CharID = " .. charid )
	end

end

timer.Create( "wOS.SkillTree.AutoSave", wOS.ALCS.Config.Skills.SkillDatabase.SaveFrequency, 0, function() 
	for _, ply in pairs ( player.GetAll() ) do
		wOS.ALCS.Config.Skills.SkillDatabase:SaveData( ply )
	end
end )

hook.Add("wOS.ALCS.PlayerSaveData", "wOS.ALCS.Skills.SaveDataForChar", function( ply )
	wOS.ALCS.Config.Skills.SkillDatabase:SaveData( ply )
end )  

hook.Add("wOS.ALCS.PlayerLoadData", "wOS.ALCS.Skills.LoadDataForChar", function( ply )
	wOS.ALCS.Config.Skills.SkillDatabase:LoadData( ply )
end )  

hook.Add("wOS.ALCS.PlayerDeleteData", "wOS.ALCS.Skills.DeleteDataForChar", function( ply, charid )
	wOS.ALCS.Config.Skills.SkillDatabase:DeleteData( ply, charid )
end ) 