--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2020
	
	Contact: www.wiltostech.com
		----------------------------------------]]--
local MYSQL_DATABASE_PROVISION = 1

wOS = wOS or {}
wOS.ALCS = wOS.ALCS or {}
wOS.ALCS.Dueling = wOS.ALCS.Dueling or {}
wOS.ALCS.Dueling.DataStore = wOS.ALCS.Dueling.DataStore or {}

require('mysqloo')
local DATA = mysqloo.CreateDatabase( wOS.ALCS.Config.Dueling.MySQL.Host, wOS.ALCS.Config.Dueling.MySQL.Username, wOS.ALCS.Config.Dueling.MySQL.Password, wOS.ALCS.Config.Dueling.MySQL.Database, wOS.ALCS.Config.Dueling.MySQL.Port, wOS.ALCS.Config.Dueling.MySQL.Socket )
if not DATA then
	error( "[wOS-ALCS] ALCS Dueling MySQL Database connection failed." )
	wOS.ALCS.Dueling.DataStore = {}
	include( "wos/medalsys/wrappers/medal_data.lua" )
	return
else
	print( "[wOS-ALCS] ALCS Dueling MySQL connection was successful!" )	
end

local MYSQL_COLUMNS_GENERAL = "( SteamID BIGINT(64), Wins BIGINT(11), Losses BIGINT(11), Sacrifices BIGINT(11), Artifact VARCHAR(255), Spirit VARCHAR(255), CharID BIGINT(64) DEFAULT 1 )"
local MYSQL_COLUMNS_SPIRIT = "( SteamID BIGINT(64), Spirit VARCHAR(255), Level BIGINT(11), Experience BIGINT(11), LastLevel BIGINT(11), CharID BIGINT(64) DEFAULT 1 )"
local MYSQL_COLUMNS_ARTIFACT = "( SteamID BIGINT(64), Artifact VARCHAR(255), Amount BIGINT(11), CharID BIGINT(64) DEFAULT 1  )"

function wOS.ALCS.Dueling.DataStore:UpdateTables( vdat )

	vdat = vdat or {}
	local version = vdat.DBVersion or 0
	
	if version >= MYSQL_DATABASE_PROVISION then return end
	
	--This is about to be the most cancerous thing ever, but it will be moved to a different file eventually.
	
	if version < 1 then
		DATA:RunQuery( "CREATE TABLE IF NOT EXISTS wos_dueldata " .. MYSQL_COLUMNS_GENERAL )
		DATA:RunQuery( "CREATE TABLE IF NOT EXISTS wos_spiritdata " .. MYSQL_COLUMNS_SPIRIT )
		DATA:RunQuery( "CREATE TABLE IF NOT EXISTS wos_artifactdata " .. MYSQL_COLUMNS_ARTIFACT )
		DATA:RunQuery( "ALTER TABLE wos_dueldata ADD COLUMN CharID BIGINT(64) DEFAULT 1" )
		DATA:RunQuery( "ALTER TABLE wos_spiritdata ADD COLUMN CharID BIGINT(64) DEFAULT 1" )
		DATA:RunQuery( "ALTER TABLE wos_artifactdata ADD COLUMN CharID BIGINT(64) DEFAULT 1" )
		DATA:RunQuery( "ALTER TABLE wos_spiritdata DROP INDEX wos_spiritdata_UX1" )
		DATA:RunQuery( "ALTER TABLE `wos_dueldata` ADD UNIQUE INDEX wos_dueldata_UX1 (SteamID,CharID)" ) 
		DATA:RunQuery( "ALTER TABLE `wos_spiritdata` ADD UNIQUE INDEX wos_spiritdata_UX2 (SteamID,CharID)" )
		DATA:RunQuery( "ALTER TABLE `wos_artifactdata` ADD UNIQUE INDEX wos_artifactd_UX1 (SteamID,Artifact,CharID)" )
		version = version + 1
	end

	if version < 2 then
		DATA:RunQuery( "ALTER TABLE wos_dueldata DROP PRIMARY KEY" )
		version = version + 1
	end
	
	DATA:RunQuery( "INSERT INTO wos_alcsduel_schema ( ID, DBVersion ) VALUES ( '1', '" .. version .. "' ) ON DUPLICATE KEY UPDATE DBVersion='" .. version .. "'" )

end

function wOS.ALCS.Dueling.DataStore:Initialize()
	
	local VERSION_CHECK = DATA:CreateTransaction()
	VERSION_CHECK:Query( "SHOW TABLES LIKE 'wos_alcsduel_schema'" )
	VERSION_CHECK:Start( function( transaction, status, err )
		if (!status) then print("[MYSQL ERROR] " .. err) end
		local queries = transaction:getQueries()
		local rows = queries[1]:getData()
		local UCHECK = DATA:CreateTransaction()
		if table.Count( rows ) < 1 then
			UCHECK:Query( "CREATE TABLE IF NOT EXISTS wos_alcsduel_schema ( `ID` bigint unsigned NOT NULL AUTO_INCREMENT, DBVersion bigint unsigned, PRIMARY KEY (`ID`) )" )
			UCHECK:Start( function(transaction, status, err) if (!status) then print("[MYSQL ERROR] " .. err) end end )
			wOS.ALCS.Dueling.DataStore:UpdateTables() 
		else
			UCHECK:Query( "SELECT * FROM wos_alcsduel_schema" )
			UCHECK:Start( function( transaction, status, err )
				if (!status) then print("[MYSQL ERROR] " .. err) end
				local queries = transaction:getQueries()
				local dat = queries[1]:getData()
				wOS.ALCS.Dueling.DataStore:UpdateTables( dat[1] ) 
			end )
		end
	end )

end

function wOS.ALCS.Dueling.DataStore:LoadPlayerData( ply )

	if not ply then return end	
	if ply:IsBot() then return end
	
	local charid = wOS.ALCS:GetCharacterID( ply ) or 1
	if charid < 1 then return end

	ply.WOS_DuelData = {}
	ply.WOS_SpiritData = {}
	ply.WOS_ArtifactData = {}
	
	ply.WOS_DuelData = {
		DuelSpirit = wOS.ALCS.Config.Dueling.DefaultSpirit,
		Wins = 0,
		Losses = 0,
		Artifact = "",
		Sacrifices = 0,
	}
	ply.WOS_SpiritData[ ply.WOS_DuelData.DuelSpirit ] =	{
		level = 0,
		lastlevel = 0,
		experience = 0,
	}

	local TRANS = DATA:CreateTransaction()
	TRANS:Prepare( "SELECT * FROM wos_dueldata WHERE SteamID = ? AND CharID = ?", { ply:SteamID64(), charid } )
	TRANS:Prepare( "SELECT * FROM wos_spiritdata WHERE SteamID = ? AND CharID = ?", { ply:SteamID64(), charid } )
	TRANS:Prepare( "SELECT * FROM wos_artifactdata WHERE SteamID = ? AND CharID = ?", { ply:SteamID64(), charid } )
	TRANS:Start(function(transaction, status, err)
		if (!status) then print("[MYSQL ERROR] " .. err) return end
		local queries = transaction:getQueries()
		
		local duel_data = queries[1]:getData()
		if table.Count( duel_data ) > 0 then
			duel_data = duel_data[1]
			local duelspirit = duel_data.Spirit
			if wOS.ALCS.Dueling.Spirits[ duelspirit ] then
				ply.WOS_DuelData.DuelSpirit = duelspirit
			end
			if wOS.ALCS.Dueling.Artifact.List[ duel_data.Artifact ] then
				ply.WOS_DuelData.Artifact = duel_data.Artifact
			end
			ply.WOS_DuelData.Wins = duel_data.Wins
			ply.WOS_DuelData.Losses = duel_data.Losses
			ply.WOS_DuelData.Sacrifices = duel_data.Sacrifices
		end
		
		local spirit_data = queries[2]:getData()
		if table.Count( spirit_data ) > 0 then
			for _, data in ipairs( spirit_data ) do
				if not wOS.ALCS.Dueling.Spirits[ data.Spirit ] then continue end
				ply.WOS_SpiritData[ data.Spirit ] =	{
					level = data.Level,
					lastlevel = data.LastLevel,
					experience = data.Experience,
				}				
			end
		end
		
		local artifact_data = queries[3]:getData()
		if table.Count( artifact_data ) > 0 then
			for _, data in ipairs( artifact_data ) do
				if not wOS.ALCS.Dueling.Artifact.List[ artifact_data.Artifact ] then continue end
				ply.WOS_ArtifactData[ artifact_data.Artifact ] = artifact_data.Amount
			end
		end
		
		wOS.ALCS.Dueling:SendPlayerDuelData( ply )
		wOS.ALCS.Dueling.Artifact:SendPlayerData( ply )
		
	end )
	
	return true

end

function wOS.ALCS.Dueling.DataStore:RemoveSpiritData( ply, spirit )

	if not ply then return false end
	if not ply.WOS_DuelData then return false end
	if not ply.WOS_SpiritData then return false end
	if not ply.WOS_ArtifactData then return false end

	if not spirit then return false end

	local sdat = wOS.ALCS.Dueling.Spirits[ spirit ]
	if not sdat then return false end	
	
	local steam64 = ply:SteamID64()
	local charid = wOS.ALCS:GetCharacterID( ply ) or 1
	if charid < 1 then return end

	TRANS:RunQuery( [[ DELETE FROM wos_spiritdata WHERE SteamID = ']] .. steam64 .. [[' AND Spirit = ']] .. DATA:escape( spirit ) .. [[' AND CharID = ']] .. charid .. [[']] )

	return true
	
end

function wOS.ALCS.Dueling.DataStore:SavePlayerData( ply )

	if not ply then return false end
	if not ply.WOS_DuelData then return false end
	if not ply.WOS_SpiritData then return false end
	if not ply.WOS_ArtifactData then return false end
	
	local steam64 = ply:SteamID64()
	local charid = wOS.ALCS:GetCharacterID( ply ) or 1
	if charid < 1 then return end

	local TRANS = DATA:CreateTransaction()
	
	local sprite = DATA:escape( ply.WOS_DuelData.DuelSpirit or "" )
	local arty = DATA:escape( ply.WOS_DuelData.Artifact or "" )
	TRANS:Query( [[ INSERT INTO wos_dueldata (SteamID, Wins, Losses, Spirit, Sacrifices, Artifact, CharID) VALUES( ']] .. steam64 .. [[', ]] .. ply.WOS_DuelData.Wins .. [[, ]] .. ply.WOS_DuelData.Losses .. [[, ']] .. sprite .. [[', ]] .. ply.WOS_DuelData.Sacrifices .. [[, ']] .. arty .. [[', ']] .. charid .. [[' ) ON DUPLICATE KEY UPDATE Wins = ]] .. ply.WOS_DuelData.Wins .. [[, Losses = ]] .. ply.WOS_DuelData.Losses .. [[, Sacrifices = ]] .. ply.WOS_DuelData.Sacrifices .. [[, Spirit = ']] .. sprite .. [[', Artifact = ']] .. arty .. [[']] )	
	
	for spir, data in pairs( ply.WOS_SpiritData ) do
		local spirit = DATA:escape( spir )
		TRANS:Query( [[ INSERT INTO wos_spiritdata (SteamID, Spirit, Level, Experience, LastLevel, CharID) VALUES( ']] .. steam64 .. [[', ']] .. spirit .. [[', ]] .. data.level .. [[, ]] .. data.experience .. [[, ]] .. data.lastlevel .. [[, ']] .. charid .. [[' ) ON DUPLICATE KEY UPDATE Level = ]] .. data.level .. [[, Experience = ]] .. data.experience .. [[, LastLevel = ]] .. data.lastlevel )
	end

	for art, amount in pairs( ply.WOS_ArtifactData ) do
		local artifact = DATA:escape( art )
		if amount > 0 then
			TRANS:Query( [[ INSERT INTO wos_artifactdata (SteamID, Artifact, Amount, CharID) VALUES( ']] .. steam64 .. [[', ']] .. artifact .. [[', ]] .. amount .. [[, ']] .. charid .. [[' ) ON DUPLICATE KEY UPDATE Amount=]] .. amount )
		else
			TRANS:Query( [[ DELETE FROM wos_artifactdata WHERE Artifact = ']] .. artifact .. [[' AND SteamID = ']] .. steam64 .. [[' AND CharID = ']] .. charid .. [[' AND (Amount IS NULL OR Amount = 0)]] )
		end
	end
	
	TRANS:Start( function(transaction, status, err)
		if (!status) then print("[MYSQL ERROR] " .. err) return end
	end )
	
	return true
	
end

function wOS.ALCS.Dueling.DataStore:DeleteData( ply, charid )

	if ply:IsBot() then return end
	local steam64 = ply:SteamID64()
	if charid < 1 then return end

	DATA:RunQuery( "DELETE FROM wos_artifactdata WHERE SteamID = '" .. steam64 .. "' AND CharID = " .. charid )
	DATA:RunQuery( "DELETE FROM wos_spiritdata WHERE SteamID = '" .. steam64 .. "' AND CharID = " .. charid )
	DATA:RunQuery( "DELETE FROM wos_dueldata WHERE SteamID = '" .. steam64 .. "' AND CharID = " .. charid )

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