--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2020
	
	Contact: www.wiltostech.com
		----------------------------------------]]--


wOS = wOS or {}
wOS.ALCS = wOS.ALCS or {}
wOS.ALCS.Character = wOS.ALCS.Character or {}
wOS.ALCS.Character.DataStore = wOS.ALCS.Character.DataStore or {}

function wOS.ALCS.Character.DataStore:Initialize()

	if not file.Exists( "wos", "DATA" ) then file.CreateDir( "wos" ) end
	if not file.Exists( "wos/advswl", "DATA" ) then file.CreateDir( "wos/advswl" ) end
	if not file.Exists( "wos/advswl/character", "DATA" ) then file.CreateDir( "wos/advswl/character" ) end
	if not file.Exists( "wos/advswl/character/playerdata", "DATA" ) then file.CreateDir( "wos/advswl/character/playerdata" ) end
	if not file.Exists( "wos/advswl/character/execwhitelist", "DATA" ) then file.CreateDir( "wos/advswl/character/execwhitelist" ) end

	print( "[wOS] Successfully initialized Character Preference data!" )
	
end

function wOS.ALCS.Character.DataStore:LoadPlayerData( ply )

	ply.WOS_Preferences = {}
	ply.WOS_AvailableGrips = {}
	ply.WOS_ExecutionWhitelists = {}
	
	local charid = wOS.ALCS:GetCharacterID( ply ) or 1
	if charid < 1 then return end

	local dFile = "wos/advswl/character/playerdata/" .. ply:SteamID64() .. "_" .. charid .. ".txt"
	if !file.Exists( dFile, "DATA" ) then
		if file.Exists( "wos/advswl/character/playerdata/" .. ply:SteamID64() .. ".txt", "DATA" ) then
			file.Rename( "wos/advswl/character/playerdata/" .. ply:SteamID64() .. ".txt", dFile )
		end
	end
	
	if file.Exists( dFile, "DATA" ) then
		local dat = util.JSONToTable( file.Read( dFile, "DATA" ) )
		ply.WOS_Preferences = table.Copy( dat )
	else
		ply.WOS_Preferences = {
			Grip = "Standard",
			Wield = false,
			Execution = false,
		}
		file.Write( dFile, util.TableToJSON( ply.WOS_Preferences ) )
	end

	dFile = "wos/advswl/character/execwhitelist/" .. ply:SteamID64() .. "_" .. charid .. ".txt"
	if file.Exists( dFile, "DATA" ) then
		local dat = util.JSONToTable( file.Read( dFile, "DATA" ) )
		ply.WOS_ExecutionWhitelists = table.Copy( dat )
	else
		file.Write( dFile, util.TableToJSON( {} ) )
	end

	wOS.ALCS.Character:SendPlayerData( ply )
	wOS.ALCS.ExecSys:SendWhitelists( ply )

end

function wOS.ALCS.Character.DataStore:SavePlayerData( ply )

	if not ply then return false end
	if not ply.WOS_Preferences then return false end
	if not ply.WOS_ExecutionWhitelists then return false end

	local charid = wOS.ALCS:GetCharacterID( ply ) or 1
	if charid < 1 then return end

	local sFile = "wos/advswl/character/playerdata/" .. ply:SteamID64() .. "_" .. charid .. ".txt"
	
	local savetbl = util.TableToJSON( ply.WOS_Preferences )
	
	file.Write( sFile, savetbl )

	sFile = "wos/advswl/character/execwhitelist/" .. ply:SteamID64() .. "_" .. charid .. ".txt"
	savetbl = util.TableToJSON( ply.WOS_ExecutionWhitelists )
	file.Write( sFile, savetbl )


	return true
	
end

function wOS.ALCS.Character.DataStore:DeleteData( ply, charid )

	if ply:IsBot() then return end
	local steam64 = ply:SteamID64()
	if charid < 1 then return end

	file.Delete( "wos/advswl/character/playerdata/" .. ply:SteamID64() .. "_" .. charid .. ".txt" )
	file.Delete( "wos/advswl/character/execwhitelist/" .. ply:SteamID64() .. "_" .. charid .. ".txt" )

end

function wOS.ALCS.Character.DataStore:AddExecWhitelist( ply, exec )
	if not ply then return end
	self:SavePlayerData( ply )	
end

function wOS.ALCS.Character.DataStore:RemoveExecWhitelist( ply, exec )
	if not ply then return end
	self:SavePlayerData( ply )	
end

hook.Add("wOS.ALCS.PlayerLoadData", "wOS.ALCS.Character.LoadDataForChar", function( ply )
	wOS.ALCS.Character.DataStore:LoadPlayerData( ply )
end )

hook.Add("wOS.ALCS.PlayerDeleteData", "wOS.ALCS.Char.DeleteDataForChar", function( ply, charid )
	wOS.ALCS.Character.DataStore:DeleteData( ply, charid )
end )