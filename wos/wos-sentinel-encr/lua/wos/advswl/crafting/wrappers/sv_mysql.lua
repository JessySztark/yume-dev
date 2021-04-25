--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2020
	
	Contact: www.wiltostech.com
		----------------------------------------]]--
local MYSQL_DATABASE_PROVISION = 3
		
		
		
wOS = wOS or {}
wOS.ALCS.Config.Crafting.CraftingDatabase = wOS.ALCS.Config.Crafting.CraftingDatabase or {}

require('mysqloo')
local DATA = mysqloo.CreateDatabase( wOS.ALCS.Config.Crafting.CraftingDatabase.Host, wOS.ALCS.Config.Crafting.CraftingDatabase.Username, wOS.ALCS.Config.Crafting.CraftingDatabase.Password, wOS.ALCS.Config.Crafting.CraftingDatabase.Database, wOS.ALCS.Config.Crafting.CraftingDatabase.Port, wOS.ALCS.Config.Crafting.CraftingDatabase.Socket )
if not DATA then
	print( "[wOS-ALCS-Crafting] MySQL Database connection failed." )
else
	print( "[wOS-ALCS-Crafting] Crafting Database MySQL connection was successful!" )	
end


local MYSQL_COLUMNS_GENERAL = "( SteamID BIGINT(64), Level int, Experience bigint, CharID BIGINT(64) DEFAULT 1 )"
local MYSQL_COLUMNS_CRAFTED = "( SteamID BIGINT(64), PrimaryItems varchar(255), SecondaryItems varchar(255), MiscItems varchar(255), CharID BIGINT(64) DEFAULT 1 )"
local MYSQL_COLUMNS_INVENTORY = "( SteamID BIGINT(64), Items varchar(255), CharID BIGINT(64) DEFAULT 1 )"
local MYSQL_COLUMNS_ITEMROSTER = "( `ID` bigint unsigned NOT NULL AUTO_INCREMENT, Item varchar(255), TransID bigint unsigned, PRIMARY KEY (`ID`) )"
local MYSQL_COLUMNS_RAWINVENTORY = "( SteamID BIGINT(64), Item varchar(255), CharID BIGINT(64) DEFAULT 1, Amount bigint )"

wOS.ALCS.Config.Crafting.CraftingDatabase.ItemToID = {}
wOS.ALCS.Config.Crafting.CraftingDatabase.IDToItem = {}
 
function wOS.ALCS.Config.Crafting.CraftingDatabase:UpdateTables( vdat )

	vdat = vdat or {}
	local version = vdat.DBVersion or 0
	
	if version >= MYSQL_DATABASE_PROVISION then return end
	
	--This is about to be the most cancerous thing ever, but it will be moved to a different file eventually.
	
	if version < 1 then
		DATA:RunQuery( "CREATE TABLE IF NOT EXISTS crafting_leveldata " .. MYSQL_COLUMNS_GENERAL )
		DATA:RunQuery( "CREATE TABLE IF NOT EXISTS saberdata " .. MYSQL_COLUMNS_CRAFTED )
		DATA:RunQuery( "CREATE TABLE IF NOT EXISTS inventory " .. MYSQL_COLUMNS_INVENTORY )
		DATA:RunQuery( "CREATE TABLE IF NOT EXISTS rawmaterials " .. MYSQL_COLUMNS_RAWINVENTORY )
		DATA:RunQuery( "ALTER TABLE crafting_leveldata ADD COLUMN CharID BIGINT(64) DEFAULT 1" )
		DATA:RunQuery( "ALTER TABLE saberdata ADD COLUMN CharID BIGINT(64) DEFAULT 1" )
		DATA:RunQuery( "ALTER TABLE inventory ADD COLUMN CharID BIGINT(64) DEFAULT 1" )
		DATA:RunQuery( "ALTER TABLE rawmaterials ADD COLUMN CharID BIGINT(64) DEFAULT 1" )
		DATA:RunQuery( "ALTER TABLE itemroster ADD COLUMN TransID bigint unsigned" )
		DATA:RunQuery( "ALTER TABLE rawmaterials DROP INDEX wos_rawmaterials_UX1" )
		DATA:RunQuery( "ALTER TABLE rawmaterials ADD UNIQUE INDEX wos_rawmaterials_UX2 (SteamID,Item,CharID)" )
		version = version + 1
	end

	if version < 2 then
		DATA:RunQuery( "ALTER TABLE inventory ADD UNIQUE INDEX wos_inventory_UX1 (SteamID,CharID)" )
		DATA:RunQuery( "ALTER TABLE saberdata ADD UNIQUE INDEX wos_saberdata_UX1 (SteamID,CharID)" )
		DATA:RunQuery( "ALTER TABLE crafting_leveldata ADD UNIQUE INDEX wos_cleveldata_UX1 (SteamID,CharID)" )
		version = version + 1
	end

	if version < 3 then
		DATA:RunQuery( "ALTER TABLE inventory MODIFY Items VARCHAR(5000)" )
		version = version + 1
	end

	if version < 4 then
		DATA:RunQuery( "ALTER TABLE crafting_leveldata DROP PRIMARY KEY" )
		DATA:RunQuery( "ALTER TABLE saberdata DROP PRIMARY KEY" )
		DATA:RunQuery( "ALTER TABLE inventory DROP PRIMARY KEY" )
		version = version + 1
	end
	
	DATA:RunQuery( "INSERT INTO wos_alcscraft_schema ( ID, DBVersion ) VALUES ( '1', '" .. version .. "' ) ON DUPLICATE KEY UPDATE DBVersion='" .. version .. "'" )
	
end

function wOS.ALCS.Config.Crafting.CraftingDatabase:Initialize()

	local TRANS = DATA:CreateTransaction()

	TRANS:Query( "CREATE TABLE IF NOT EXISTS itemroster " .. MYSQL_COLUMNS_ITEMROSTER )
	TRANS:Start( function(transaction, status, err)
		if (!status) then print("[MYSQL ERROR] " .. err) end
		local CTRANS = DATA:CreateTransaction()
		for item, data in pairs( wOS.ItemList ) do
			local iteme = DATA:escape( item )
			CTRANS:Query( [[ INSERT INTO itemroster ( Item ) SELECT * FROM (SELECT ']] .. iteme .. [[' ) AS tmp WHERE NOT EXISTS ( SELECT Item FROM itemroster WHERE Item = ']] .. iteme .. [[' ) LIMIT 1 ]] )
		end
		CTRANS:Query( "SELECT * FROM itemroster" )
		CTRANS:Start( function(transaction, status, err)
			if (!status) then print("[MYSQL ERROR] " .. err) end 
			local queries = transaction:getQueries()
			local itemdata = queries[#queries]:getData()
			if itemdata then
				local trans = {}
				for _, data in pairs( itemdata ) do
					if not wOS:GetItemData( data.Item ) then continue end
					if data.TransID and data.TransID != 0 then
						table.insert( trans, { Item = data.Item, TransID = data.TransID, ID = data.ID } )
					end
					wOS.ALCS.Config.Crafting.CraftingDatabase.IDToItem[ data.ID ] = data.Item
					wOS.ALCS.Config.Crafting.CraftingDatabase.ItemToID[ data.Item ] = data.ID
				end
				for _, data in ipairs( trans ) do
					local nam = wOS.ALCS.Config.Crafting.CraftingDatabase.IDToItem[ data.TransID ] 
					if nam then
						wOS.ALCS.Config.Crafting.CraftingDatabase.ItemToID[ data.Item ] = data.TransID
						wOS.ALCS.Config.Crafting.CraftingDatabase.IDToItem[ data.ID ] = nam
					end
				end
			end
		end )
	end )
	
	local VERSION_CHECK = DATA:CreateTransaction()
	VERSION_CHECK:Query( "SHOW TABLES LIKE 'wos_alcscraft_schema'" )
	VERSION_CHECK:Start( function( transaction, status, err )
		if (!status) then print("[MYSQL ERROR] " .. err) end
		local queries = transaction:getQueries()
		local rows = queries[1]:getData()
		local UCHECK = DATA:CreateTransaction()
		if table.Count( rows ) < 1 then
			UCHECK:Query( "CREATE TABLE IF NOT EXISTS wos_alcscraft_schema ( `ID` bigint unsigned NOT NULL AUTO_INCREMENT, DBVersion bigint unsigned, PRIMARY KEY (`ID`) )" )
			UCHECK:Start( function(transaction, status, err) if (!status) then print("[MYSQL ERROR] " .. err) end end )
			wOS.ALCS.Config.Crafting.CraftingDatabase:UpdateTables()
		else
			UCHECK:Query( "SELECT * FROM wos_alcscraft_schema" )
			UCHECK:Start( function( transaction, status, err )
				if (!status) then print("[MYSQL ERROR] " .. err) end
				local queries = transaction:getQueries()
				local dat = queries[1]:getData()
				wOS.ALCS.Config.Crafting.CraftingDatabase:UpdateTables( dat[1] )  
			end )
		end
	end )

end

function wOS.ALCS.Config.Crafting.CraftingDatabase:LoadData( ply )

	if ply:IsBot() then return end
	local steam64 = ply:SteamID64()
	
	local charid = wOS.ALCS:GetCharacterID( ply ) or 1
	if charid < 1 then return end

	ply.PersonalSaberItems = {}
	ply.PersonalSaber = {}
	ply.SecPersonalSaberItems = {}
	ply.SecPersonalSaber = {}
	ply.SaberInventory = {}	
	ply.RawMaterials = {}
	ply.SaberMiscItems = {}
	ply.SaberMiscFunctions = {}

	ply:SetSaberLevel( 0 )
	ply:SetSaberXP( 0 )

	for i=1, 5 do
		ply.PersonalSaberItems[ i ] = "Standard"
		ply.SecPersonalSaberItems[ i ] = "Standard"
	end
	
	local TRANS = DATA:CreateTransaction()		
	TRANS:Query( "SELECT * FROM crafting_leveldata WHERE SteamID = '" .. steam64 .. "' AND CharID = '" .. charid .. "'" )
	TRANS:Query( "SELECT * FROM saberdata WHERE SteamID = '" .. steam64 .. "' AND CharID = '" .. charid .. "'" )
	TRANS:Query( "SELECT * FROM inventory WHERE SteamID = '" .. steam64 .. "' AND CharID = '" .. charid .. "'" )
	TRANS:Query( "SELECT * FROM rawmaterials WHERE SteamID = '" .. steam64 .. "' AND CharID = '" .. charid .. "'" )
	TRANS:Start(function(transaction, status, err)
		if (!status) then print("[MYSQL ERROR] " .. err) end
		local creation_needed = false		
		local queries = transaction:getQueries()
		local C_TRANS = DATA:CreateTransaction()	
		local leveldata = queries[1]:getData()
		if table.Count( leveldata ) < 1 then
			creation_needed = true
			C_TRANS:Query( "INSERT INTO crafting_leveldata ( SteamID, Level, Experience, CharID ) VALUES ( '" .. steam64 .. "','"  .. 0 .. "','" .. 0 .. "', '" .. charid .. "')" )
		else
			leveldata = leveldata[1]
			ply:SetSaberLevel( leveldata.Level )
			ply:SetSaberXP( leveldata.Experience )
		end
		local itemdata = queries[2]:getData()
		if table.Count( itemdata ) < 1 then
			creation_needed = true
			local str = ""
			for i=1, 5 do
				str = str .. "0;"
			end
			C_TRANS:Query( "INSERT INTO saberdata ( SteamID, PrimaryItems, SecondaryItems, MiscItems, CharID ) VALUES ( '" .. steam64 .. "','" .. str .. "','" .. str .. "', '', '" .. charid .. "')" )
		else
			itemdata = itemdata[1]
			local items = string.Explode( ";", itemdata.PrimaryItems )
			for typ, id in pairs( items ) do
				local item = wOS.ALCS.Config.Crafting.CraftingDatabase.IDToItem[ tonumber( id ) ]
				if not item then item = "Standard" end
				local idata = wOS:GetItemData( item )
				if not idata then item = "Standard" end
				ply.PersonalSaberItems[ typ ] = item
				ply.PersonalSaber[ item ] = idata
			end
			items = string.Explode( ";", itemdata.SecondaryItems )
			for typ, id in pairs( items ) do
				local item = wOS.ALCS.Config.Crafting.CraftingDatabase.IDToItem[ tonumber( id ) ]
				if not item then item = "Standard" end
				local idata = wOS:GetItemData( item )
				if not idata then item = "Standard" end
				ply.SecPersonalSaberItems[ typ ] = item
				ply.SecPersonalSaber[ item ] = idata
			end
			items = string.Explode( ";", itemdata.MiscItems )
			for typ, id in pairs( items ) do
				local item = wOS.ALCS.Config.Crafting.CraftingDatabase.IDToItem[ tonumber( id ) ]
				if not item then continue end
				local idata = wOS:GetItemData( item )
				if not idata then continue end
				ply.SaberMiscItems[ item ] = item
				ply.SaberMiscFunctions[ item ] = idata
			end
		end
		local invdata = queries[3]:getData()
		if table.Count( invdata ) < 1 then
			creation_needed = true
			local fill = ""
			for i=1, wOS.ALCS.Config.Crafting.MaxInventorySlots do
				ply.SaberInventory[ i ] = "Empty"
				fill = fill .. "0,0;"
			end
			C_TRANS:Query( "INSERT INTO inventory ( SteamID, Items, CharID ) VALUES ( '" .. steam64 .. "','" .. fill .. "', '" .. charid .. "')" )	
		else
			invdata = invdata[1]
			local items = string.Explode( ";", invdata.Items )
			for slot, dat in pairs( items ) do
				local detail = string.Explode( ",", dat )
				local item = detail[1] or "0"
				local amount = detail[2] or "1"
				local name = wOS.ALCS.Config.Crafting.CraftingDatabase.IDToItem[ tonumber( item ) ]
				if not name then name = "Empty" end
				ply.SaberInventory[ slot ] = { Name = name, Amount = tonumber( amount ) }
			end
		end
		for material, _ in pairs( wOS.RawMaterialList ) do
			ply.RawMaterials[ material ] = 0
		end
		
		local rawdata = queries[4]:getData()
		if table.Count( rawdata ) > 0 then
			for slot, data in pairs( rawdata ) do
				if not wOS.RawMaterialList[ data.Item ] then continue end
				ply.RawMaterials[ data.Item ] = data.Amount
			end
		end
		
		if creation_needed then
			C_TRANS:Start(function(transaction, status, err) end)
		end
	
		wOS:TransmitPersonalSaber( ply )
	end )
	
end

function wOS.ALCS.Config.Crafting.CraftingDatabase:SaveData( ply )

	if ply:IsBot() then return end
	local steam64 = ply:SteamID64()

	if not ply.PersonalSaber then return end
	if not ply.PersonalSaberItems then return end
	if not ply.SaberInventory then return end
	if not ply.RawMaterials then return end
	if not ply.SaberMiscItems then return end
	
	local charid = wOS.ALCS:GetCharacterID( ply ) or 1
	if charid < 1 then return end

	local builddata = ""
	local builddata2 = ""
	local builddata3 = ""
	for i=1, 5 do
		local item = ply.PersonalSaberItems[i]
		local id = wOS.ALCS.Config.Crafting.CraftingDatabase.ItemToID[ item ]
		if not id then id = "0" end
		builddata = builddata .. id .. ";"
	end
	
	for i=1, 5 do
		local item = ply.SecPersonalSaberItems[i]
		local id = wOS.ALCS.Config.Crafting.CraftingDatabase.ItemToID[ item ]
		if not id then id = "0" end
		builddata2 = builddata2 .. id .. ";"
	end
	
	for typ, item in pairs( ply.SaberMiscItems ) do
		local id = wOS.ALCS.Config.Crafting.CraftingDatabase.ItemToID[ item ]
		if not id then continue end
		builddata3 = builddata3 .. id .. ";"
	end
	
	local invdata = ""
	for slot = 1, wOS.ALCS.Config.Crafting.MaxInventorySlots do
		local name, amt = wOS:GetInventorySlotInfo( ply, slot )
		if not name then 
			name = "Empty"
		end
		local id = wOS.ALCS.Config.Crafting.CraftingDatabase.ItemToID[ name ]
		if not id then
			id = 0
			ply.SaberInventory[ slot ] = { Name = "Empty", Amount = 1 }
		end
		invdata = invdata .. id .. "," .. amt .. ";"
	end

	local TRANS = DATA:CreateTransaction()		
	TRANS:Query( "UPDATE crafting_leveldata SET Level = " .. ply:GetSaberLevel() .. ", Experience = " .. ply:GetSaberXP() .. " WHERE SteamID = " .. steam64 .. " AND CharID = " .. charid )
	TRANS:Query( "UPDATE saberdata SET PrimaryItems = '" .. DATA:escape( builddata ) .. "', SecondaryItems = '" .. DATA:escape( builddata2 ) .. "', MiscItems = '" .. DATA:escape( builddata3 ) .. "' WHERE SteamID = " .. steam64 .. " AND CharID = " .. charid )
	TRANS:Query( "UPDATE inventory SET Items = '" .. invdata .. "' WHERE SteamID = " .. steam64 .. " AND CharID = " .. charid )
	for material, amount in pairs( ply.RawMaterials ) do
		local iteme = DATA:escape( material )
		if amount > 0 then
			TRANS:Query( [[ INSERT INTO rawmaterials (SteamID, Item, Amount, CharID) VALUES( ']] .. steam64 .. [[', ']] .. iteme .. [[', ]] .. amount .. [[, ]] .. charid .. [[ ) ON DUPLICATE KEY UPDATE Amount=]] .. amount )
		else
			TRANS:Query( [[ DELETE FROM rawmaterials WHERE Item = ']] .. iteme .. [[' AND SteamID = ']] .. steam64 .. [[' AND CharID = ]] .. charid .. [[ AND (Amount IS NULL OR Amount = 0)]] )
		end
	end			
	TRANS:Start(function(transaction, status, err)
		if (!status) then print("[MYSQL ERROR] " .. err) end
	end)
	
end

function wOS.ALCS.Config.Crafting.CraftingDatabase:DeleteData( ply, charid )

	if ply:IsBot() then return end
	local steam64 = ply:SteamID64()
	if charid < 1 then return end

	DATA:RunQuery( "DELETE FROM crafting_leveldata WHERE SteamID = '" .. steam64 .. "' AND CharID = " .. charid )
	DATA:RunQuery( "DELETE FROM saberdata WHERE SteamID = '" .. steam64 .. "' AND CharID = " .. charid )
	DATA:RunQuery( "DELETE FROM inventory WHERE SteamID = '" .. steam64 .. "' AND CharID = " .. charid )
	DATA:RunQuery( "DELETE FROM rawmaterials WHERE SteamID = '" .. steam64 .. "' AND CharID = " .. charid )

end


timer.Create( "wOS.Crafting.AutoSave", wOS.ALCS.Config.Crafting.CraftingDatabase.SaveFrequency, 0, function() 
	for _, ply in pairs ( player.GetAll() ) do
		wOS.ALCS.Config.Crafting.CraftingDatabase:SaveData( ply )
	end
end )

hook.Add( "PlayerDisconnected", "wOS.Crafting.ItemSaving", function( ply )
	wOS.ALCS.Config.Crafting.CraftingDatabase:SaveData( ply )
end )

hook.Add("wOS.ALCS.PlayerSaveData", "wOS.ALCS.Crafting.SaveDataForChar", function( ply )
	wOS.ALCS.Config.Crafting.CraftingDatabase:SaveData( ply )
end )  

hook.Add("wOS.ALCS.PlayerLoadData", "wOS.ALCS.Crafting.LoadDataForChar", function( ply )
	wOS.ALCS.Config.Crafting.CraftingDatabase:LoadData( ply )
end )  

hook.Add("wOS.ALCS.PlayerDeleteData", "wOS.ALCS.Crafting.DeleteDataForChar", function( ply, charid )
	wOS.ALCS.Config.Crafting.CraftingDatabase:DeleteData( ply, charid )
end ) 