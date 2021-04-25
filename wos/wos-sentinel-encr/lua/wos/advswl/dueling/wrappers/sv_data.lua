--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2020
	
	Contact: www.wiltostech.com
		----------------------------------------]]--


wOS = wOS or {}
wOS.ALCS = wOS.ALCS or {}
wOS.ALCS.Dueling = wOS.ALCS.Dueling or {}
wOS.ALCS.Dueling.DataStore = wOS.ALCS.Dueling.DataStore or {}

function wOS.ALCS.Dueling.DataStore:Initialize()

	if not file.Exists( "wos", "DATA" ) then file.CreateDir( "wos" ) end
	if not file.Exists( "wos/advswl", "DATA" ) then file.CreateDir( "wos/advswl" ) end
	if not file.Exists( "wos/advswl/dueling", "DATA" ) then file.CreateDir( "wos/advswl/dueling" ) end
	if not file.Exists( "wos/advswl/dueling/playerdata", "DATA" ) then file.CreateDir( "wos/advswl/dueling/playerdata" ) end
	
	print( "[wOS] Successfully initialized Dueling data!" )
	
end

function wOS.ALCS.Dueling.DataStore:LoadPlayerData( ply )

	ply.WOS_DuelData = {}
	ply.WOS_SpiritData = {}
	ply.WOS_ArtifactData = {}
	local charid = wOS.ALCS:GetCharacterID( ply ) or 1
	if charid < 1 then return end

	local dFile = "wos/advswl/dueling/playerdata/" .. ply:SteamID64() .. "_" .. charid .. ".txt"
	if !file.Exists( dFile, "DATA" ) then
		if file.Exists( "wos/advswl/dueling/playerdata/" .. ply:SteamID64() .. ".txt", "DATA" ) then
			file.Rename( "wos/advswl/dueling/playerdata/" .. ply:SteamID64() .. ".txt", dFile )
		end
	end
	
	if file.Exists( dFile, "DATA" ) then
		local dat = util.JSONToTable( file.Read( dFile, "DATA" ) )
		ply.WOS_DuelData = table.Copy( dat[1] )
		ply.WOS_SpiritData = table.Copy( dat[2] )
		ply.WOS_ArtifactData = table.Copy( dat[3] )
	else
		ply.WOS_DuelData = {
			DuelSpirit = wOS.ALCS.Config.Dueling.DefaultSpirit,
			Wins = 0,
			Losses = 0,
			Sacrifices = 0,
			Artifact = "",
		}
		ply.WOS_SpiritData[ ply.WOS_DuelData.DuelSpirit ] =	{
			level = 0,
			lastlevel = 0,
			experience = 0,
		}
		file.Write( dFile, util.TableToJSON( { ply.WOS_DuelData, ply.WOS_SpiritData, ply.WOS_ArtifactData } ) )
	end

	wOS.ALCS.Dueling:SendPlayerDuelData( ply )
	wOS.ALCS.Dueling.Artifact:SendPlayerData( ply )

end

function wOS.ALCS.Dueling.DataStore:SavePlayerData( ply )

	if not ply then return false end
	if not ply.WOS_DuelData then return false end
	if not ply.WOS_SpiritData then return false end
	if not ply.WOS_ArtifactData then return false end
	
	local charid = wOS.ALCS:GetCharacterID( ply ) or 1
	if charid < 1 then return end

	local sFile = "wos/advswl/dueling/playerdata/" .. ply:SteamID64() .. "_" .. charid .. ".txt"
	
	local savetbl = util.TableToJSON( { ply.WOS_DuelData, ply.WOS_SpiritData, ply.WOS_ArtifactData } )
	
	file.Write( sFile, savetbl )

	return true
	
end

function wOS.ALCS.Dueling.DataStore:RemoveSpiritData( ply, spirit )

end

function wOS.ALCS.Dueling.DataStore:DeleteData( ply, charid )

	if ply:IsBot() then return end
	local steam64 = ply:SteamID64()
	if charid < 1 then return end

	file.Delete( "wos/advswl/dueling/playerdata/" .. ply:SteamID64() .. "_" .. charid .. ".txt" )

end

hook.Add("wOS.ALCS.PlayerSaveData", "wOS.ALCS.Dueling.SaveDataForChar", function( ply )
	wOS.ALCS.Dueling.DataStore:SavePlayerData( ply )
end )  

hook.Add("wOS.ALCS.PlayerLoadData", "wOS.ALCS.Dueling.LoadDataForChar", function( ply )
	wOS.ALCS.Dueling.DataStore:LoadPlayerData( ply )
end )  

hook.Add("wOS.ALCS.PlayerDeleteData", "wOS.ALCS.Dueling.DeleteDataForChar", function( ply, charid )
	wOS.ALCS.Dueling.DataStore:DeleteData( ply, charid )
end )