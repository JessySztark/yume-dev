--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2020
	
	Contact: www.wiltostech.com
		----------------------------------------]]--


wOS = wOS or {}
wOS.ALCS = wOS.ALCS or {}
wOS.ALCS.Prestige = wOS.ALCS.Prestige or {}
wOS.ALCS.Prestige.DataStore = wOS.ALCS.Prestige.DataStore or {}

function wOS.ALCS.Prestige.DataStore:UpdateTables()

end

function wOS.ALCS.Prestige.DataStore:Initialize()

	if not file.Exists( "wos", "DATA" ) then file.CreateDir( "wos" ) end
	if not file.Exists( "wos/advswl", "DATA" ) then file.CreateDir( "wos/advswl" ) end
	if not file.Exists( "wos/advswl/prestige", "DATA" ) then file.CreateDir( "wos/advswl/prestige" ) end

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

	local read = file.Read( "wos/advswl/prestige/" .. steam64 .. "_" .. charid .. ".txt", "DATA" )
	if not read then			
		local data = util.TableToJSON( ply.WOS_SkillPrestige )
		file.Write( "wos/advswl/prestige/" .. steam64 .. "_" .. charid .. ".txt", data )	
	else
		local readdata = util.JSONToTable( read )
		ply.WOS_SkillPrestige = table.Copy( readdata )
	end
	

	wOS.ALCS.Prestige:TransmitPrestige( ply )
	wOS.ALCS.Prestige:ApplyMastery( ply )

end

function wOS.ALCS.Prestige.DataStore:SaveMetaData( ply )

	if ply:IsBot() then return end
	local steam64 = ply:SteamID64()
	if not ply.WOS_SkillPrestige then return end
	
	local charid = wOS.ALCS:GetCharacterID( ply ) or 1
	if charid < 1 then return end

	local data = util.TableToJSON( ply.WOS_SkillPrestige )
	file.Write( "wos/advswl/prestige/" .. steam64 .. "_" .. charid .. ".txt", data )	
	
end

function wOS.ALCS.Prestige.DataStore:SaveMasteryData( ply, mastery, removal )
	self:SaveMetaData( ply )
end

function wOS.ALCS.Prestige.DataStore:DeleteData( ply, charid )

	if ply:IsBot() then return end
	local steam64 = ply:SteamID64()
	if charid < 1 then return end

	file.Delete( "wos/advswl/prestige/" .. steam64 .. "_" .. charid .. ".txt" )

end

hook.Add("wOS.ALCS.PlayerLoadData", "wOS.ALCS.Prestige.LoadDataForChar", function( ply )
	wOS.ALCS.Prestige.DataStore:LoadData( ply )
end )  

hook.Add("wOS.ALCS.PlayerDeleteData", "wOS.ALCS.Prestige.DeleteDataForChar", function( ply, charid )
	wOS.ALCS.Prestige.DataStore:DeleteData( ply, charid )
end )