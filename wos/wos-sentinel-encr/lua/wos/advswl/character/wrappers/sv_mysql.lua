--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2020
	
	Contact: www.wiltostech.com
		----------------------------------------]]--
local MYSQL_DATABASE_PROVISION = 2



wOS = wOS or {}
wOS.ALCS = wOS.ALCS or {}
wOS.ALCS.Character = wOS.ALCS.Character or {}
wOS.ALCS.Character.DataStore = wOS.ALCS.Character.DataStore or {}

require('mysqloo')
local DATA = mysqloo.CreateDatabase( wOS.ALCS.Config.Character.MySQL.Host, wOS.ALCS.Config.Character.MySQL.Username, wOS.ALCS.Config.Character.MySQL.Password, wOS.ALCS.Config.Character.MySQL.Database, wOS.ALCS.Config.Character.MySQL.Port, wOS.ALCS.Config.Character.MySQL.Socket )
if not DATA then
	error( "[wOS-ALCS] ALCS Character Preference MySQL Database connection failed." )
else
	print( "[wOS-ALCS] ALCS Character Preference MySQL connection was successful!" )	
end

local MYSQL_COLUMNS_GENERAL = "( SteamID BIGINT(64), Grip VARCHAR(255), Wield INT, Execution VARCHAR(255), CharID BIGINT(64) DEFAULT 1 )"
local MYSQL_COLUMNS_WL = "( SteamID bigint(64) UNSIGNED, Execution VARCHAR(255), CharID BIGINT(64) DEFAULT 1 )"

function wOS.ALCS.Character.DataStore:UpdateTables( vdat )

	vdat = vdat or {}
	local version = vdat.DBVersion or 0
	
	if version >= MYSQL_DATABASE_PROVISION then return end
	
	--This is about to be the most cancerous thing ever, but it will be moved to a different file eventually.
	
	if version < 1 then
		DATA:RunQuery( "CREATE TABLE IF NOT EXISTS wos_saberpref " .. MYSQL_COLUMNS_GENERAL )
		DATA:RunQuery( "ALTER TABLE wos_saberpref ADD COLUMN CharID BIGINT(64) DEFAULT 1" )
		DATA:RunQuery( "ALTER TABLE `wos_saberpref` ADD UNIQUE INDEX wos_charpref_UX1 (SteamID,CharID)" )
		version = version + 1
	end

	if version < 2 then
		DATA:RunQuery( "CREATE TABLE IF NOT EXISTS wos_execwl " .. MYSQL_COLUMNS_WL )	
		DATA:RunQuery( "ALTER TABLE wos_execwl ADD UNIQUE INDEX wos_execwl_UX1 (SteamID,Execution,CharID)" )
		version = version + 1
	end

	if version < 3 then
		DATA:RunQuery( "ALTER TABLE wos_saberpref DROP PRIMARY KEY" )
		version = version + 1
	end
	
	DATA:RunQuery( "INSERT INTO wos_alcschar_schema ( ID, DBVersion ) VALUES ( '1', '" .. version .. "' ) ON DUPLICATE KEY UPDATE DBVersion='" .. version .. "'" )
	
end

function wOS.ALCS.Character.DataStore:Initialize()
	
	local VERSION_CHECK = DATA:CreateTransaction()
	VERSION_CHECK:Query( "SHOW TABLES LIKE 'wos_alcschar_schema'" )
	VERSION_CHECK:Start( function( transaction, status, err )
		if (!status) then print("[MYSQL ERROR] " .. err) end
		local queries = transaction:getQueries()
		local rows = queries[1]:getData()
		local UCHECK = DATA:CreateTransaction()
		if table.Count( rows ) < 1 then
			UCHECK:Query( "CREATE TABLE IF NOT EXISTS wos_alcschar_schema ( `ID` bigint unsigned NOT NULL AUTO_INCREMENT, DBVersion bigint unsigned, PRIMARY KEY (`ID`) )" )
			UCHECK:Start( function(transaction, status, err) if (!status) then print("[MYSQL ERROR] " .. err) end end )
			wOS.ALCS.Character.DataStore:UpdateTables()
		else
			UCHECK:Query( "SELECT * FROM wos_alcschar_schema" )
			UCHECK:Start( function( transaction, status, err )
				if (!status) then print("[MYSQL ERROR] " .. err) end
				local queries = transaction:getQueries()
				local dat = queries[1]:getData()
				wOS.ALCS.Character.DataStore:UpdateTables( dat[1] )
			end )
		end
	end )

end

function wOS.ALCS.Character.DataStore:LoadPlayerData( ply )

	if not ply then return end	
	if ply:IsBot() then return end
	
	local charid = wOS.ALCS:GetCharacterID( ply ) or 1
	if charid < 1 then return end
	
	ply.WOS_Preferences = {
		Grip = "Standard",
		Wield = false,
		Execution = false,
	}

	ply.WOS_ExecutionWhitelists = {}
	ply.WOS_AvailableGrips = {}

	local TRANS = DATA:CreateTransaction()
	TRANS:Prepare( "SELECT * FROM wos_saberpref WHERE SteamID = ? AND CharID = ?", { ply:SteamID64(), charid } )
	TRANS:Prepare( "SELECT * FROM wos_execwl WHERE SteamID = ? AND CharID = ?", { ply:SteamID64(), charid } )
	TRANS:Start(function(transaction, status, err)
		if (!status) then print("[MYSQL ERROR] " .. err) return end
		local queries = transaction:getQueries()
		
		local pref_data = queries[1]:getData()
		if table.Count( pref_data ) > 0 then
			pref_data = pref_data[1]
			
			local exec = pref_data.Execution
			if wOS.ALCS.ExecSys and wOS.ALCS.ExecSys.Executions then
				if wOS.ALCS.ExecSys.Executions[ exec ] then
					ply.WOS_Preferences.Execution = exec
				end
			end
			
			local grip = pref_data.Grip
			if wOS.ALCS.LightsaberBase.Grips[ grip ] then
				ply.WOS_Preferences.Grip = grip
			end
			
			ply.WOS_Preferences.Wield = ( pref_data.Wield == 1 )
		end

		pref_data = queries[2]:getData()
		if table.Count( pref_data ) > 0 then
			for slot, dat in ipairs( pref_data ) do
				local exec = dat.Execution
				if not wOS.ALCS.ExecSys.Executions[ exec ] then continue end
				ply.WOS_ExecutionWhitelists[ exec ] = true
			end
		end
		
		wOS.ALCS.Character:SendPlayerData( ply )
		wOS.ALCS.ExecSys:SendWhitelists( ply )

	end )
	
	return true

end

function wOS.ALCS.Character.DataStore:SavePlayerData( ply )

	if not ply then return false end
	if not ply.WOS_Preferences then return false end
	
	local steam64 = ply:SteamID64()
	local charid = wOS.ALCS:GetCharacterID( ply ) or 1
	if charid < 1 then return end

	local TRANS = DATA:CreateTransaction()

	local exec = DATA:escape( ply.WOS_Preferences.Execution or "" )
	local grip = DATA:escape( ply.WOS_Preferences.Grip or "Standard" )
	local wield = ( ply.WOS_Preferences.Wield and 1 ) or 0
	TRANS:Query( [[ INSERT INTO wos_saberpref (SteamID, Grip, Wield, Execution, CharID ) VALUES( ]] .. steam64 .. [[, ']] .. grip .. [[', ]] .. wield .. [[, ']] .. exec .. [[',']] .. charid .. [[' ) ON DUPLICATE KEY UPDATE Grip = ']] .. grip .. [[', Wield = ]] .. wield .. [[, Execution = ']] .. exec .. [[']] )	
	TRANS:Start( function(transaction, status, err)
		if (!status) then print("[MYSQL ERROR] " .. err) return end
	end )
	
	return true
	
end

function wOS.ALCS.Character.DataStore:AddExecWhitelist( ply, exec )
	if not ply then return end
	if not ply.WOS_ExecutionWhitelists then return end
	if not wOS.ALCS.ExecSys.Executions[ exec ] then return end

	local steam64 = ply:SteamID64()	
	local charid = wOS.ALCS:GetCharacterID( ply ) or 1
	if charid < 1 then return end

	DATA:RunQuery( [[ INSERT INTO wos_execwl (SteamID, Execution, CharID) VALUES( ']] .. steam64 .. [[',']] .. DATA:escape( exec ) .. [[', ']] .. charid .. [[') ON DUPLICATE KEY UPDATE CharID = ]] .. charid )	
	
end

function wOS.ALCS.Character.DataStore:RemoveExecWhitelist( ply, exec )

	if not ply then return end
	if not ply.WOS_ExecutionWhitelists then return end
	if not wOS.ALCS.ExecSys.Executions[ exec ] then return end

	local steam64 = ply:SteamID64()	
	local charid = wOS.ALCS:GetCharacterID( ply ) or 1
	if charid < 1 then return end

	DATA:RunQuery( [[ DELETE FROM wos_execwl WHERE SteamID = ']] .. steam64 .. [[' AND CharID = ']] .. charid .. [[' AND Execution = ']] .. DATA:escape( exec ) .. [[']] )

end


function wOS.ALCS.Character.DataStore:DeleteData( ply, charid )

	if ply:IsBot() then return end
	local steam64 = ply:SteamID64()
	if charid < 1 then return end

	DATA:RunQuery( "DELETE FROM wos_saberpref WHERE SteamID = '" .. steam64 .. "' AND CharID = " .. charid )
	DATA:RunQuery( "DELETE FROM wos_execwl WHERE SteamID = '" .. steam64 .. "' AND CharID = " .. charid )
	
end

hook.Add("wOS.ALCS.PlayerLoadData", "wOS.ALCS.Character.LoadDataForChar", function( ply )
	wOS.ALCS.Character.DataStore:LoadPlayerData( ply )
end )

hook.Add("wOS.ALCS.PlayerDeleteData", "wOS.ALCS.Char.DeleteDataForChar", function( ply, charid )
	wOS.ALCS.Character.DataStore:DeleteData( ply, charid )
end )