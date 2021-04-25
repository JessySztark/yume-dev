--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2020
	
	Contact: www.wiltostech.com
		----------------------------------------]]--


wOS = wOS or {}
wOS.ALCS = wOS.ALCS or {}
wOS.ALCS.Storage = wOS.ALCS.Storage or {}
wOS.ALCS.Storage.DataStore = wOS.ALCS.Storage.DataStore or {}

function wOS.ALCS.Storage.DataStore:UpdateTables()

end

function wOS.ALCS.Storage.DataStore:Initialize()

	if not file.Exists( "wos", "DATA" ) then file.CreateDir( "wos" ) end
	if not file.Exists( "wos/advswl", "DATA" ) then file.CreateDir( "wos/advswl" ) end
	if not file.Exists( "wos/advswl/storage", "DATA" ) then file.CreateDir( "wos/advswl/storage" ) end

end

function wOS.ALCS.Storage.DataStore:LoadData( ply )

	if ply:IsBot() then return end
	local steam64 = ply:SteamID64()

	ply.WOS_SaberStorage = {
		MaxSlots = wOS.ALCS.Config.Storage.StartingSpace,
		Backpack = {},
	}
	
	local charid = wOS.ALCS:GetCharacterID( ply ) or 1
	if charid < 1 then return end

	local read = file.Read( "wos/advswl/storage/" .. steam64 .. "_" .. charid .. ".txt", "DATA" )
	if not read then			
		local data = util.TableToJSON( ply.WOS_SaberStorage )
		file.Write( "wos/advswl/storage/" .. steam64 .. "_" .. charid .. ".txt", data )	
	else
		local readdata = util.JSONToTable( read )
		ply.WOS_SaberStorage = table.Copy( readdata )
	end

	wOS.ALCS.Storage:TransmitStorage( ply )
	
end

function wOS.ALCS.Storage.DataStore:SaveMetaData( ply )

	if ply:IsBot() then return end
	local steam64 = ply:SteamID64()
	if not ply.WOS_SaberStorage then return end
	
	local charid = wOS.ALCS:GetCharacterID( ply ) or 1
	if charid < 1 then return end

	local data = util.TableToJSON( ply.WOS_SaberStorage )
	file.Write( "wos/advswl/storage/" .. steam64 .. "_" .. charid .. ".txt", data )	
	
end

function wOS.ALCS.Storage.DataStore:SaveSlotData( ply, slot, removal )
	self:SaveMetaData( ply )
end

function wOS.ALCS.Storage.DataStore:DeleteData( ply, charid )

	if ply:IsBot() then return end
	local steam64 = ply:SteamID64()
	if charid < 1 then return end

	file.Delete( "wos/advswl/storage/" .. steam64 .. "_" .. charid .. ".txt" )

end

hook.Add("wOS.ALCS.PlayerLoadData", "wOS.ALCS.Storage.LoadDataForChar", function( ply )
	wOS.ALCS.Storage.DataStore:LoadData( ply )
end )  

hook.Add("wOS.ALCS.PlayerDeleteData", "wOS.ALCS.Storage.DeleteDataForChar", function( ply, charid )
	wOS.ALCS.Storage.DataStore:DeleteData( ply, charid )
end )
