--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2020
	
	Contact: www.wiltostech.com
		----------------------------------------]]--
local MYSQL_DATABASE_PROVISION = 1
		
		
		
wOS = wOS or {}
wOS.ALCS = wOS.ALCS or {}
wOS.ALCS.Storage = wOS.ALCS.Storage or {}
wOS.ALCS.Storage.DataStore = wOS.ALCS.Storage.DataStore or {}

require('mysqloo')
local DATA = mysqloo.CreateDatabase( wOS.ALCS.Config.Crafting.CraftingDatabase.Host, wOS.ALCS.Config.Crafting.CraftingDatabase.Username, wOS.ALCS.Config.Crafting.CraftingDatabase.Password, wOS.ALCS.Config.Crafting.CraftingDatabase.Database, wOS.ALCS.Config.Crafting.CraftingDatabase.Port, wOS.ALCS.Config.Crafting.CraftingDatabase.Socket )

if not DATA then
	print( "[wOS-ALCS-Storage] MySQL Database connection failed." )
else
	print( "[wOS-ALCS-Storage] Storage Database MySQL connection was successful!" )	
end


local MYSQL_COLUMNS_META = "( SteamID BIGINT(64), CharID BIGINT(64) DEFAULT 1, MaxSlots BIGINT(64) )"
local MYSQL_COLUMNS_BANK = "( SteamID BIGINT(64), CharID BIGINT(64) DEFAULT 1, Slot BIGINT(64), Item VARCHAR(255) )"

function wOS.ALCS.Storage.DataStore:GetItemID( ITEM )
	if not ITEM then return end
	return wOS.ALCS.Config.Crafting.CraftingDatabase.ItemToID[ ITEM ]
end

function wOS.ALCS.Storage.DataStore:GetItemName( ID )
	if not ID then return end
	ID = tonumber( ID )
	return wOS.ALCS.Config.Crafting.CraftingDatabase.IDToItem[ ID ] or "Empty"
end

function wOS.ALCS.Storage.DataStore:UpdateTables( vdat )

	vdat = vdat or {}
	local version = vdat.DBVersion or 0
	
	if version >= MYSQL_DATABASE_PROVISION then return end
	
	--This is about to be the most cancerous thing ever, but it will be moved to a different file eventually.
	if version < 1 then
		DATA:RunQuery( "CREATE TABLE IF NOT EXISTS crafting_storage_bank " .. MYSQL_COLUMNS_BANK )
		DATA:RunQuery( "CREATE TABLE IF NOT EXISTS crafting_storage_meta " .. MYSQL_COLUMNS_META )
		DATA:RunQuery( "ALTER TABLE crafting_storage_meta ADD UNIQUE INDEX wos_bankmeta_UX1 (SteamID,CharID)" )
		DATA:RunQuery( "ALTER TABLE crafting_storage_bank ADD UNIQUE INDEX wos_craftbank_UX1 (SteamID,CharID,Slot)" )
		version = version + 1
	end
	
	DATA:RunQuery( "INSERT INTO wos_alcsstorage_schema ( ID, DBVersion ) VALUES ( '1', '" .. version .. "' ) ON DUPLICATE KEY UPDATE DBVersion='" .. version .. "'" )
	
end

function wOS.ALCS.Storage.DataStore:Initialize()
	
	local VERSION_CHECK = DATA:CreateTransaction()
	VERSION_CHECK:Query( "SHOW TABLES LIKE 'wos_alcsstorage_schema'" )
	VERSION_CHECK:Start( function( transaction, status, err )
		if (!status) then print("[MYSQL ERROR] " .. err) end
		local queries = transaction:getQueries()
		local rows = queries[1]:getData()
		local UCHECK = DATA:CreateTransaction()
		if table.Count( rows ) < 1 then
			UCHECK:Query( "CREATE TABLE IF NOT EXISTS wos_alcsstorage_schema ( `ID` bigint unsigned NOT NULL AUTO_INCREMENT, DBVersion bigint unsigned, PRIMARY KEY (`ID`) )" )
			UCHECK:Start( function(transaction, status, err) if (!status) then print("[MYSQL ERROR] " .. err) end end )
			wOS.ALCS.Storage.DataStore:UpdateTables()
		else
			UCHECK:Query( "SELECT * FROM wos_alcsstorage_schema" )
			UCHECK:Start( function( transaction, status, err )
				if (!status) then print("[MYSQL ERROR] " .. err) end
				local queries = transaction:getQueries()
				local dat = queries[1]:getData()
				wOS.ALCS.Storage.DataStore:UpdateTables( dat[1] )  
			end )
		end
	end )

end

function wOS.ALCS.Storage.DataStore:LoadData( ply )

	if ply:IsBot() then return end
	local steam64 = ply:SteamID64()
	
	local charid = wOS.ALCS:GetCharacterID( ply ) or 1
	if charid < 1 then return end

	ply.WOS_SaberStorage = {
		MaxSlots = wOS.ALCS.Config.Storage.StartingSpace,
		Backpack = {},
	}

	local TRANS = DATA:CreateTransaction()		
	TRANS:Query( "SELECT * FROM crafting_storage_meta WHERE SteamID = '" .. steam64 .. "' AND CharID = '" .. charid .. "'" )
	TRANS:Query( "SELECT * FROM crafting_storage_bank WHERE SteamID = '" .. steam64 .. "' AND CharID = '" .. charid .. "'" )
	TRANS:Start(function(transaction, status, err)
		if (!status) then print("[MYSQL ERROR] " .. err) end
		local creation_needed = false		
		local queries = transaction:getQueries()
		local mdata = queries[1]:getData()
		if table.Count( mdata ) < 1 then
			DATA:RunQuery( "INSERT INTO crafting_storage_meta ( SteamID, CharID, MaxSlots ) VALUES ( '" .. steam64 .. "','"  .. charid .. "','" .. wOS.ALCS.Config.Storage.StartingSpace .. "')" )
		else
			mdata = mdata[1]
			ply.WOS_SaberStorage.MaxSlots = tonumber( mdata.MaxSlots )
		end
		
		local bdata = queries[2]:getData()		
		if table.Count( bdata ) > 0 then
			for _, dat in ipairs( bdata ) do
				local detail = string.Explode( ",", dat.Item )
				local item = detail[1] or "0"
				local amount = detail[2] or "1"
				local name = self:GetItemName( item )
				if not name then name = "Empty" end
				if name == "Empty" then continue end
				ply.WOS_SaberStorage.Backpack[ dat.Slot ] = { Name = name, Amount = tonumber( amount ) }
			end
		end		
		wOS.ALCS.Storage:TransmitStorage( ply )
	end )
	
end

function wOS.ALCS.Storage.DataStore:SaveMetaData( ply )

	if ply:IsBot() then return end
	local steam64 = ply:SteamID64()
	if not ply.WOS_SaberStorage then return end
	
	local charid = wOS.ALCS:GetCharacterID( ply ) or 1
	if charid < 1 then return end

	DATA:RunQuery( [[UPDATE crafting_storage_meta SET MaxSlots = ']] .. ply.WOS_SaberStorage.MaxSlots .. [[' WHERE SteamID = ]] .. steam64 .. [[ AND CharID = ']] .. charid .. [[']] )
	
end

function wOS.ALCS.Storage.DataStore:SaveSlotData( ply, slot )

	if ply:IsBot() then return end
	local steam64 = ply:SteamID64()
	if not ply.WOS_SaberStorage then return end
	if not slot or slot < 1 then return end
	
	local charid = wOS.ALCS:GetCharacterID( ply ) or 1
	if charid < 1 then return end

	local TRANS = DATA:CreateTransaction()
	
	local removal = false
	local dat = ply.WOS_SaberStorage.Backpack[ slot ]
	if not dat or dat.Name == "Empty" then removal = true end

	if not removal then
		local item = dat.Name
		local id = wOS.ALCS.Storage.DataStore:GetItemID( item )
		if id then
			local iteme = DATA:escape( id .. "," .. dat.Amount )
			DATA:RunQuery( [[ INSERT INTO crafting_storage_bank (SteamID, Slot, CharID, Item) VALUES( ']] .. steam64 .. [[', ']] .. slot .. [[', ]] .. charid .. [[, ']] .. iteme .. [[' ) ON DUPLICATE KEY UPDATE Item=']] .. iteme .. [[']] )
			return
		end
		removal = true
	end
	
	if removal then
		DATA:RunQuery( [[ DELETE FROM crafting_storage_bank WHERE Slot = ']] .. slot .. [[' AND SteamID = ']] .. steam64 .. [[' AND CharID = ]] .. charid )
	end
	
end

function wOS.ALCS.Storage.DataStore:DeleteData( ply, charid )

	if ply:IsBot() then return end
	local steam64 = ply:SteamID64()
	if charid < 1 then return end

	DATA:RunQuery( "DELETE FROM crafting_storage_bank WHERE SteamID = '" .. steam64 .. "' AND CharID = " .. charid )
	DATA:RunQuery( "DELETE FROM crafting_storage_meta WHERE SteamID = '" .. steam64 .. "' AND CharID = " .. charid )

end

hook.Add("wOS.ALCS.PlayerLoadData", "wOS.ALCS.Storage.LoadDataForChar", function( ply )
	wOS.ALCS.Storage.DataStore:LoadData( ply )
end )  

hook.Add("wOS.ALCS.PlayerDeleteData", "wOS.ALCS.Storage.DeleteDataForChar", function( ply, charid )
	wOS.ALCS.Storage.DataStore:DeleteData( ply, charid )
end )