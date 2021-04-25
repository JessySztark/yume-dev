--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2020
	
	Contact: www.wiltostech.com
		----------------------------------------]]--


wOS = wOS or {}
wOS.ALCS.Config.Skills.SkillDatabase = wOS.ALCS.Config.Skills.SkillDatabase or {}
local TableToSkill = {}
local SkillToTable = {}

function wOS.ALCS.Config.Skills.SkillDatabase:UpdateTables()

end

function wOS.ALCS.Config.Skills.SkillDatabase:Initialize()
	
	if not file.Exists( "wos", "DATA" ) then file.CreateDir( "wos" ) end
	if not file.Exists( "wos/advswl", "DATA" ) then file.CreateDir( "wos/advswl" ) end
	if not file.Exists( "wos/advswl/skills", "DATA" ) then file.CreateDir( "wos/advswl/skills" ) end
	if not file.Exists( "wos/advswl/skills/_wos_sk_whitelists_", "DATA" ) then file.CreateDir( "wos/advswl/skills/_wos_sk_whitelists_" ) end
	if not file.Exists( "wos/advswl/leveling", "DATA" ) then file.CreateDir( "wos/advswl/leveling" ) end
	for name, _ in pairs( wOS.SkillTrees ) do
		if not file.Exists( "wos/advswl/skills/" .. name, "DATA" ) then file.CreateDir( "wos/advswl/skills/" .. name ) end
	end
	
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
	
	local read = file.Read( "wos/advswl/leveling/" .. steam64 .. "_" .. charid .. ".txt", "DATA" )	
	if not read then
		read = file.Read( "wos/advswl/leveling/" .. steam64 .. ".txt", "DATA" )
		if read then
			file.Rename( "wos/advswl/leveling/" .. steam64 .. ".txt", "wos/advswl/leveling/" .. steam64 .. "_" .. charid .. ".txt" )
		end
	end
	
	if not read then			
		local data = { Level = 0, Experience = 0, SkillPoints = 0 }
		data = util.TableToJSON( data )
		file.Write( "wos/advswl/leveling/" .. steam64 .. "_" .. charid .. ".txt", data )	
	else
		local readdata = util.JSONToTable( read )
		ply:SetSkillLevel( readdata.Level )
		ply:SetSkillXP( readdata.Experience )
		ply:SetSkillPoints( readdata.SkillPoints )	
	end
	for name, _ in pairs( wOS.SkillTrees ) do
		ply.SkillTree[ name ] = {}
		ply.EquippedSkills[ name ] = {}
		local read = file.Read( "wos/advswl/skills/" .. string.lower( name ) .. "/" .. steam64 .. "_" .. charid .. ".txt", "DATA" )
		if not read then
			read = file.Read( "wos/advswl/skills/" .. string.lower( name ) .. "/" .. steam64 .. ".txt", "DATA" )
			if read then
				file.Rename( "wos/advswl/skills/" .. string.lower( name ) .. "/" .. steam64 .. ".txt", "wos/advswl/skills/" .. string.lower( name ) .. "/" .. steam64 .. "_" .. charid .. ".txt" )
			end
		end
		if not read then 
			local data = {}
			data = util.TableToJSON( data )
			file.Write( "wos/advswl/skills/" .. string.lower( name ) .. "/" .. steam64 .. "_" .. charid .. ".txt", data )
		else
			local treedata = wOS:GetSkillTreeData( name )
			if not treedata then continue end
			treedata = treedata.Tier
			if not treedata then continue end
			local flag = false
			local total = 0
			if treedata.UserGroups then
				if not table.HasValue( treedata.UserGroups, ply:GetUserGroup() ) then 
					flag = true
				end
			end
			local readdata = util.JSONToTable( read )
			for tier, skills in pairs( readdata ) do
				if not treedata[ tier ] then continue end
				if flag then
					local skilldata = treedata[ tier ][ skill ]
					if skilldata.PointsRequired then 
						total = total + skilldata.PointsRequired
					end
					continue
				end
				if not ply.EquippedSkills[ name ] then ply.EquippedSkills[ name ] = {} end
				if not ply.EquippedSkills[ name ][ tier ] then ply.EquippedSkills[ name ][ tier ] = {} end
				for skill, _ in pairs( skills ) do
					local skilldata = treedata[ tier ][ skill ]
					if not skilldata then continue end
					ply.EquippedSkills[ name ][ tier ][ skill ] = true
					ply.SkillTree[ name ][ skilldata.Name ] = skilldata
				end
			end
			if flag then
				ply:AddSkillPoints( total )
			end
		end
	end
	
	local read = file.Read( "wos/advswl/skills/_wos_sk_whitelists_/" .. steam64 .. "_" .. charid .. ".txt", "DATA" )		
	if not read then			
		local data = util.TableToJSON( {} )
		file.Write( "wos/advswl/skills/_wos_sk_whitelists_/" .. steam64 .. "_" .. charid .. ".txt", data )	
	else
		local readdata = util.JSONToTable( read )
		ply.WOS_SkillTreeWhitelists = table.Copy( readdata )
	end
	
	ply:SetCurrentSkillHooks()
	wOS:TransmitSkillData( ply )
	wOS:TransmitWhitelistData( ply )
	
end

function wOS.ALCS.Config.Skills.SkillDatabase:SaveData( ply )

	if ply:IsBot() then return end
	local steam64 = ply:SteamID64()
	if not ply.EquippedSkills then return end
	if not ply.SkillTree then return end
	local charid = wOS.ALCS:GetCharacterID( ply ) or 1
	if charid < 1 then return end

	local data = {}
	data.Level = ply:GetSkillLevel()
	data.Experience = ply:GetSkillXP()
	data.SkillPoints = ply:GetSkillPoints()
	
	data = util.TableToJSON( data )
	file.Write( "wos/advswl/leveling/" .. steam64 .. "_" .. charid .. ".txt", data )			
	for name, _ in pairs( wOS.SkillTrees ) do
		local savedata = table.Copy( ply.EquippedSkills[ name ] ) or {}
		savedata = util.TableToJSON( savedata )
		file.Write( "wos/advswl/skills/" .. string.lower( name ) .. "/" .. steam64 .. "_" .. charid .. ".txt", savedata )
	end			

	data = util.TableToJSON( ply.WOS_SkillTreeWhitelists )
	file.Write( "wos/advswl/skills/_wos_sk_whitelists_/" .. steam64 .. "_" .. charid .. ".txt", data )	

end

function wOS.ALCS.Config.Skills.SkillDatabase:DeleteData( ply, charid )

	if ply:IsBot() then return end
	local steam64 = ply:SteamID64()
	if charid < 1 then return end

	file.Delete( "wos/advswl/leveling/" .. steam64 .. "_" .. charid .. ".txt" )
	file.Delete( "wos/advswl/skills/_wos_sk_whitelists_/" .. steam64 .. "_" .. charid .. ".txt" )

	for name, _ in pairs( wOS.SkillTrees ) do
		file.Delete( "wos/advswl/skills/" .. string.lower( name ) .. "/" .. steam64 .. "_" .. charid .. ".txt" )
	end

end

function wOS.ALCS.Config.Skills.SkillDatabase:AddWhitelist( ply )
	self:SaveData( ply )
	wOS:TransmitWhitelistData( ply )
end

function wOS.ALCS.Config.Skills.SkillDatabase:RemoveWhitelist( ply )
	self:SaveData( ply )
	wOS:TransmitWhitelistData( ply )
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