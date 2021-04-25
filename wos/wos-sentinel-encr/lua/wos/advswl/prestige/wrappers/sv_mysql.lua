--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2020
	
	Contact: www.wiltostech.com
		----------------------------------------]]--
local MYSQL_DATABASE_PROVISION = 1
		
		
		
wOS = wOS or {}
wOS.ALCS = wOS.ALCS or {}
wOS.ALCS.Prestige = wOS.ALCS.Prestige or {}
wOS.ALCS.Prestige.DataStore = wOS.ALCS.Prestige.DataStore or {}

require('mysqloo')
local DATA = mysqloo.CreateDatabase( wOS.ALCS.Config.Prestige.Database.Host, wOS.ALCS.Config.Prestige.Database.Username, wOS.ALCS.Config.Prestige.Database.Password, wOS.ALCS.Config.Prestige.Database.Database, wOS.ALCS.Config.Prestige.Database.Port, wOS.ALCS.Config.Prestige.Database.Socket )

if not DATA then
	print( "[wOS-ALCS-Prestige] MySQL Database connection failed." )
else
	print( "[wOS-ALCS-Prestige] Prestige Database MySQL connection was successful!" )	
end


local MYSQL_COLUMNS_META = "( SteamID BIGINT(64), CharID BIGINT(64) DEFAULT 1, Level BIGINT(64), Tokens BIGINT(64) )"
local MYSQL_COLUMNS_STAT = "( SteamID BIGINT(64), CharID BIGINT(64) DEFAULT 1, Mastery BIGINT(64) )"

function wOS.ALCS.Prestige.DataStore:UpdateTables( vdat )

	vdat = vdat or {}
	local version = vdat.DBVersion or 0
	
	if version >= MYSQL_DATABASE_PROVISION then return end
	
	--This is about to be the most cancerous thing ever, but it will be moved to a different file eventually.
	if version < 1 then
		DATA:RunQuery( "CREATE TABLE IF NOT EXISTS wos_alcs_prestige_meta " .. MYSQL_COLUMNS_META )
		DATA:RunQuery( "CREATE TABLE IF NOT EXISTS wos_alcs_prestige_master " .. MYSQL_COLUMNS_STAT )
		DATA:RunQuery( "ALTER TABLE wos_alcs_prestige_meta ADD UNIQUE INDEX wos_prestmeta_UX1 (SteamID,CharID)" )
		DATA:RunQuery( "ALTER TABLE wos_alcs_prestige_master ADD UNIQUE INDEX wos_prestmast_UX1 (SteamID,CharID,Mastery)" )
		version = version + 1
	end

	if version < 2 then
		DATA:RunQuery( "ALTER TABLE wos_alcs_prestige_meta DROP PRIMARY KEY" )
		version = version + 1
	end
	
	DATA:RunQuery( "INSERT INTO wos_alcsprestige_schema ( ID, DBVersion ) VALUES ( '1', '" .. version .. "' ) ON DUPLICATE KEY UPDATE DBVersion='" .. version .. "'" )
	
end

function wOS.ALCS.Prestige.DataStore:Initialize()
	
	local VERSION_CHECK = DATA:CreateTransaction()
	VERSION_CHECK:Query( "SHOW TABLES LIKE 'wos_alcsprestige_schema'" )
	VERSION_CHECK:Start( function( transaction, status, err )
		if (!status) then print("[MYSQL ERROR] " .. err) end
		local queries = transaction:getQueries()
		local rows = queries[1]:getData()
		local UCHECK = DATA:CreateTransaction()
		if table.Count( rows ) < 1 then
			UCHECK:Query( "CREATE TABLE IF NOT EXISTS wos_alcsprestige_schema ( `ID` bigint unsigned NOT NULL AUTO_INCREMENT, DBVersion bigint unsigned, PRIMARY KEY (`ID`) )" )
			UCHECK:Start( function(transaction, status, err) if (!status) then print("[MYSQL ERROR] " .. err) end end )
			wOS.ALCS.Prestige.DataStore:UpdateTables()
		else
			UCHECK:Query( "SELECT * FROM wos_alcsprestige_schema" )
			UCHECK:Start( function( transaction, status, err )
				if (!status) then print("[MYSQL ERROR] " .. err) end
				local queries = transaction:getQueries()
				local dat = queries[1]:getData()
				wOS.ALCS.Prestige.DataStore:UpdateTables( dat[1] )  
			end )
		end
	end )

end

function wOS.ALCS.Prestige.DataStore:LoadData( ply )

	if ply:IsBot() then return end
	local steam64 = ply:SteamID64()
	
	local charid = wOS.ALCS:GetCharacterID( ply ) or 1
	if charid < 1 then return end

	ply.WOS_SkillPrestige = {
		Tokens = 0,
		Level = 0,
		Mastery = {},
	}

	local TRANS = DATA:CreateTransaction()		
	TRANS:Query( "SELECT * FROM wos_alcs_prestige_meta WHERE SteamID = '" .. steam64 .. "' AND CharID = '" .. charid .. "'" )
	TRANS:Query( "SELECT * FROM wos_alcs_prestige_master WHERE SteamID = '" .. steam64 .. "' AND CharID = '" .. charid .. "'" )
	TRANS:Start(function(transaction, status, err)
		if (!status) then print("[MYSQL ERROR] " .. err) end
		local creation_needed = false		
		local queries = transaction:getQueries()
		local mdata = queries[1]:getData()
		if table.Count( mdata ) < 1 then
			DATA:RunQuery( "INSERT INTO wos_alcs_prestige_meta ( SteamID, CharID, Level, Tokens ) VALUES ( '" .. steam64 .. "','"  .. charid .. "',0,0)" )
		else
			mdata = mdata[1]
			ply.WOS_SkillPrestige.Level = tonumber( mdata.Level )
			ply.WOS_SkillPrestige.Tokens = tonumber( mdata.Tokens )
		end
		
		local bdata = queries[2]:getData()		
		if table.Count( bdata ) > 0 then
			for _, dat in ipairs( bdata ) do
				ply.WOS_SkillPrestige.Mastery[ dat.Mastery ] = true
			end
		end		
		wOS.ALCS.Prestige:TransmitPrestige( ply )
		wOS.ALCS.Prestige:ApplyMastery( ply )
	end )
end

function wOS.ALCS.Prestige.DataStore:SaveMetaData( ply )

	if ply:IsBot() then return end
	local steam64 = ply:SteamID64()
	if not ply.WOS_SkillPrestige then return end
	
	local charid = wOS.ALCS:GetCharacterID( ply ) or 1
	if charid < 1 then return end

	DATA:RunQuery( [[UPDATE wos_alcs_prestige_meta SET Level = ]] .. ply.WOS_SkillPrestige.Level .. [[, Tokens = ]] .. ply.WOS_SkillPrestige.Tokens .. [[ WHERE SteamID = ]] .. steam64 .. [[ AND CharID = ']] .. charid .. [[']] )
	
end

function wOS.ALCS.Prestige.DataStore:SaveMasteryData( ply, mastery, removal )

	if ply:IsBot() then return end
	local steam64 = ply:SteamID64()
	if not ply.WOS_SkillPrestige then return end
	if not mastery then return end
	if mastery < 1 then return end
	
	local charid = wOS.ALCS:GetCharacterID( ply ) or 1
	if charid < 1 then return end

	local TRANS = DATA:CreateTransaction()
	
	if removal then
		DATA:RunQuery( [[ DELETE FROM wos_alcs_prestige_master WHERE Mastery = ]] .. mastery .. [[ AND SteamID = ']] .. steam64 .. [[' AND CharID = ]] .. charid )
	else
		DATA:RunQuery( [[ INSERT INTO wos_alcs_prestige_master (SteamID, CharID, Mastery) VALUES( ']] .. steam64 .. [[', ']] .. charid .. [[', ]] .. mastery .. [[ ) ON DUPLICATE KEY UPDATE Mastery=]] .. mastery )
	end
	
end


function wOS.ALCS.Prestige.DataStore:DeleteData( ply, charid )

	if ply:IsBot() then return end
	local steam64 = ply:SteamID64()
	if charid < 1 then return end

	DATA:RunQuery( "DELETE FROM wos_alcs_prestige_master WHERE SteamID = '" .. steam64 .. "' AND CharID = " .. charid )
	DATA:RunQuery( "DELETE FROM wos_alcs_prestige_meta WHERE SteamID = '" .. steam64 .. "' AND CharID = " .. charid )

end

hook.Add("wOS.ALCS.PlayerLoadData", "wOS.ALCS.Prestige.LoadDataForChar", function( ply )
	wOS.ALCS.Prestige.DataStore:LoadData( ply )
end )  

hook.Add("wOS.ALCS.PlayerDeleteData", "wOS.ALCS.Prestige.DeleteDataForChar", function( ply, charid )
	wOS.ALCS.Prestige.DataStore:DeleteData( ply, charid )
end )