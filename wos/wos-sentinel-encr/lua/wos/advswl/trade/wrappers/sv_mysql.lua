--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2020
	
	Contact: www.wiltostech.com
		----------------------------------------]]--
local MYSQL_DATABASE_PROVISION = 1
		
		
		
wOS = wOS or {}
wOS.ALCS = wOS.ALCS or {}
wOS.ALCS.GTN = wOS.ALCS.GTN or {}
wOS.ALCS.GTN.DataStore = wOS.ALCS.GTN.DataStore or {}

wOS.ALCS.GTN.AuctionCache = {
	LastUpdate = 0,
	Listings = {},
}

wOS.ALCS.GTN.TradeCache = {
	LastUpdate = 0,
	Listings = {},
}

require('mysqloo')

--Have to do this a little extra for MULTI LINE CAPABILITIES
local DATA = mysqloo.connect( wOS.ALCS.Config.GTN.Database.Host, wOS.ALCS.Config.GTN.Database.Username, wOS.ALCS.Config.GTN.Database.Password, wOS.ALCS.Config.GTN.Database.Database, wOS.ALCS.Config.GTN.Database.Port, wOS.ALCS.Config.GTN.Database.Socket )
DATA:setMultiStatements(true)
DATA:connect()
DATA = mysqloo.ConvertDatabase(DATA)

if not DATA then
	print( "[wOS-ALCS-GTN] MySQL Database connection failed." )
else
	print( "[wOS-ALCS-GTN] Trade Network Database MySQL connection was successful!" )	
end

local MYSQL_COLUMNS_AUCTIONS = "( ID BIGINT UNSIGNED NOT NULL AUTO_INCREMENT, SteamID VARCHAR(255), CharID BIGINT(64) DEFAULT 1, Item VARCHAR(255), CurrentBid BIGINT DEFAULT 0, BidderSteamID VARCHAR(255), BidderCharID BIGINT(64) DEFAULT 1, BuyNowPrice BIGINT, Creation DATETIME DEFAULT CURRENT_TIMESTAMP, Expiration DATETIME, Updated DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, PRIMARY KEY (`ID`) )"
local MYSQL_COLUMNS_TRADES = "( ID BIGINT UNSIGNED NOT NULL AUTO_INCREMENT, SteamID VARCHAR(255), CharID BIGINT(64) DEFAULT 1, Item VARCHAR(255), RequestedItem VARCHAR(255), Creation DATETIME DEFAULT CURRENT_TIMESTAMP, Expiration DATETIME, PRIMARY KEY (`ID`) )"
local MYSQL_COLUMNS_STOCK = "( ID BIGINT UNSIGNED NOT NULL AUTO_INCREMENT, SteamID VARCHAR(255), CharID BIGINT(64) DEFAULT 1, ItemAward VARCHAR(255), CashAward BIGINT, Creation DATETIME DEFAULT CURRENT_TIMESTAMP, PRIMARY KEY (`ID`) )"

function wOS.ALCS.GTN.DataStore:UpdateTables( vdat )

	vdat = vdat or {}
	local version = vdat.DBVersion or 0
	
	if version >= MYSQL_DATABASE_PROVISION then return end
	
	--This is about to be the most cancerous thing ever, but it will be moved to a different file eventually.
	if version < 1 then
		DATA:RunQuery( "CREATE TABLE IF NOT EXISTS wos_alcs_gtn_auctions " .. MYSQL_COLUMNS_AUCTIONS  .. ";" )
		DATA:RunQuery( "CREATE TABLE IF NOT EXISTS wos_alcs_gtn_trades " .. MYSQL_COLUMNS_TRADES .. ";" )
		DATA:RunQuery( "CREATE TABLE IF NOT EXISTS wos_alcs_gtn_stock " .. MYSQL_COLUMNS_STOCK .. ";" )
		DATA:RunQuery( [[CREATE EVENT IF NOT EXISTS wos_alcs_gtn_auctionhandler
		ON SCHEDULE EVERY 10 MINUTE 
		DO
			BEGIN
			
			INSERT INTO wos_alcs_gtn_stock( SteamID, CharID, ItemAward, CashAward )
			SELECT t.BidderSteamID,t.BidderCharID,t.Item,t.CurrentBid*-1
			FROM wos_alcs_gtn_auctions t
			WHERE t.Expiration <= NOW();
			
			INSERT INTO wos_alcs_gtn_stock( SteamID, CharID, ItemAward, CashAward )
			SELECT t.SteamID,t.CharID,'',t.CurrentBid
			FROM wos_alcs_gtn_auctions t
			WHERE t.Expiration <= NOW();
			
			DELETE FROM wos_alcs_gtn_auctions
			WHERE Expiration <= NOW();
			
			DELETE FROM wos_alcs_gtn_trades
			WHERE Expiration <= NOW();
			 
			END]] )
		version = version + 1
	end
	
	DATA:RunQuery( "INSERT INTO wos_alcsgtn_schema ( ID, DBVersion ) VALUES ( '1', '" .. version .. "' ) ON DUPLICATE KEY UPDATE DBVersion='" .. version .. "';" )
	
end

function wOS.ALCS.GTN.DataStore:Initialize()
	
	DATA:RunQuery( "SET GLOBAL event_scheduler = ON;" )
	
	local VERSION_CHECK = DATA:CreateTransaction()
	VERSION_CHECK:Query( "SHOW TABLES LIKE 'wos_alcsgtn_schema';" )
	VERSION_CHECK:Start( function( transaction, status, err )
		if (!status) then print("[MYSQL ERROR] " .. err) end
		local queries = transaction:getQueries()
		local rows = queries[1]:getData()
		local UCHECK = DATA:CreateTransaction()
		if table.Count( rows ) < 1 then
			UCHECK:Query( "CREATE TABLE IF NOT EXISTS wos_alcsgtn_schema ( `ID` bigint unsigned NOT NULL AUTO_INCREMENT, DBVersion bigint unsigned, PRIMARY KEY (`ID`) );" )
			UCHECK:Start( function(transaction, status, err) if (!status) then print("[MYSQL ERROR] " .. err) end end )
			wOS.ALCS.GTN.DataStore:UpdateTables()
		else
			UCHECK:Query( "SELECT * FROM wos_alcsgtn_schema;" )
			UCHECK:Start( function( transaction, status, err )
				if (!status) then print("[MYSQL ERROR] " .. err) end
				local queries = transaction:getQueries()
				local dat = queries[1]:getData()
				wOS.ALCS.GTN.DataStore:UpdateTables( dat[1] )  
			end )
		end
	end )

end

function wOS.ALCS.GTN.DataStore:CheckStock( ply )
	
	if ply:IsBot() then return end
	local steam64 = ply:SteamID64()
	
	local charid = wOS.ALCS:GetCharacterID( ply ) or 1
	if charid < 1 then return end

	DATA:RunQuery( "SELECT COUNT(*) FROM wos_alcs_gtn_stock WHERE SteamID = '" .. steam64 .. "' AND CharID = " .. charid .. ";", function( queries, status, err )
		if not status then
			error( err )
		end
		local qdat = queries:getData()[1]
		qdat = qdat[ "COUNT(*)" ] or 0
		qdat = tonumber( qdat )
		if qdat > 0 then
			local tname = "ALCS_GTN_STOCKREMINDER_" .. steam64
			timer.Create( tname, 120, 0, function() 
				if not IsValid( ply ) then
					timer.Destroy( tname )
					return
				end
				ply:SendLua( [[ surface.PlaySound( "buttons/lightswitch2.wav" ) ]] )
				ply:SendLua( [[ notification.AddLegacy( "[wOS] You have UNCLAIMED items from the TRADE NETWORK!", NOTIFY_HINT, 5 ) ]] )						
			end )
		end
	end )
	
end

function wOS.ALCS.GTN.DataStore:MakeAuctionPosting( ply, data )
	
	if ply:IsBot() then return end
	local steam64 = tostring( ply:SteamID64() )
	
	local charid = wOS.ALCS:GetCharacterID( ply ) or 1
	if charid < 1 then return end

	DATA:RunQuery( "INSERT INTO wos_alcs_gtn_auctions ( SteamID, CharID, Item, BuyNowPrice, CurrentBid, BidderSteamID, BidderCharID, Expiration ) VALUES( '" .. steam64 .. "'," .. charid .. ",'" .. DATA:escape( data.Item ) .. "'," .. data.BuyNowPrice .. "," .. data.StartingBid .. ",'" .. steam64 .. "'," .. charid .. ", NOW() + INTERVAL " .. wOS.ALCS.Config.GTN.PostingDays .. " DAY);" )
	
end

function wOS.ALCS.GTN.DataStore:MakeBarterPosting( ply, data )
	
	if ply:IsBot() then return end
	local steam64 = ply:SteamID64()
	
	local charid = wOS.ALCS:GetCharacterID( ply ) or 1
	if charid < 1 then return end

	DATA:RunQuery( "INSERT INTO wos_alcs_gtn_trades ( SteamID, CharID, Item, RequestedItem, Expiration ) VALUES( '" .. steam64 .. "'," .. charid .. ",'" .. DATA:escape( data.Item ) .. "','" .. DATA:escape( data.RequestedItem ) .. "', NOW() + INTERVAL " .. wOS.ALCS.Config.GTN.PostingDays .. " DAY);" )
	
end

function wOS.ALCS.GTN.DataStore:RemoveListing( ply, id, trade )
	
	if ply:IsBot() then return end
	local steam64 = ply:SteamID64()
	
	local charid = wOS.ALCS:GetCharacterID( ply ) or 1
	if charid < 1 then return end

	local tbl = ( trade and "wos_alcs_gtn_trades" ) or "wos_alcs_gtn_auctions"

	DATA:RunQuery( "SELECT * FROM " .. tbl .. " WHERE SteamID = '" .. steam64 .. "' AND CharID = " .. charid .. " AND ID = " .. id .. ";", function( queries, status, err )
		if not status then
			error( err )
		end
		local lst = queries:getData()
		lst = lst[1]
		if !lst then
			ply:SendLua( [[ surface.PlaySound( "buttons/lightswitch2.wav" ) ]] )
			ply:SendLua( [[ notification.AddLegacy( "[wOS] No listings found with that ID!", NOTIFY_ERROR, 3 ) ]] )				
		else
			local delete = false
			if trade then
				local nam = lst.Item
				if wOS.ALCS.Config.Crafting.ShouldCraftingUseMySQL then
					local tid = wOS.ALCS.Config.Crafting.CraftingDatabase.ItemToID[ nam ]
					if !tid then return end
					local nam = wOS.ALCS.Config.Crafting.CraftingDatabase.IDToItem[ tid ]
					if !nam then return end	
				end
				if !wOS:HandleItemPickup( ply, nam ) then
					ply:SendLua( [[ surface.PlaySound( "buttons/lightswitch2.wav" ) ]] )
					ply:SendLua( [[ notification.AddLegacy( "[wOS] Failed retrieve ]] .. nam .. [[ from TRADE NETWORK, not enough inventory space!", NOTIFY_ERROR, 3 ) ]] )										
					return
				end
				delete = true
			else
				
				DATA:RunQuery( [[ INSERT INTO wos_alcs_gtn_stock( SteamID, CharID, ItemAward, CashAward )
				SELECT t.BidderSteamID,t.BidderCharID,'',t.CurrentBid
				FROM wos_alcs_gtn_auctions t
				WHERE t.ID = ]] .. id .. [[;
				
				INSERT INTO wos_alcs_gtn_stock( SteamID, CharID, ItemAward, CashAward )
				SELECT t.SteamID,t.CharID,t.Item,0
				FROM wos_alcs_gtn_auctions t
				WHERE t.ID = ]] .. id .. [[;]] )
				delete = true
				
				ply:SendLua( [[ surface.PlaySound( "buttons/lightswitch2.wav" ) ]] )
				ply:SendLua( [[ notification.AddLegacy( "[wOS] Your listing has been placed in the stock for your redemption.", NOTIFY_HINT, 3 ) ]] )	
				
			end
			if delete then
				DATA:RunQuery( "DELETE FROM " .. tbl .. " WHERE SteamID = '" .. steam64 .. "' AND CharID = " .. charid .. " AND ID = " .. id .. ";" )
				wOS.ALCS:AddPlayerCurrency( ply, -1*wOS.ALCS.Config.GTN.CancelTax )
			end
			
		end
	end	)
	
end

function wOS.ALCS.GTN.DataStore:GetPlayerListings( ply )
	
	if ply:IsBot() then return end
	local steam64 = ply:SteamID64()
	
	local charid = wOS.ALCS:GetCharacterID( ply ) or 1
	if charid < 1 then return end

	local TRANS = DATA:CreateTransaction()
	
	TRANS:Query( "SELECT * FROM wos_alcs_gtn_trades WHERE SteamID = '" .. steam64 .. "' AND CharID = " .. charid .. ";" )
	TRANS:Query( "SELECT * FROM wos_alcs_gtn_auctions WHERE SteamID = '" .. steam64 .. "' AND CharID = " .. charid .. ";" )
	
	TRANS:Start( function( transaction, status, err )
		if (!status) then print("[MYSQL ERROR] " .. err) end
		local queries = transaction:getQueries()
		local trades = queries[1]:getData()
		local auctions = queries[2]:getData()
		
		wOS.ALCS.GTN:SendPlayerListings( ply, trades, auctions )
		
	end )
	
end

function wOS.ALCS.GTN.DataStore:RedeemStock( ply )
	
	if ply:IsBot() then return end
	local steam64 = ply:SteamID64()
	
	local charid = wOS.ALCS:GetCharacterID( ply ) or 1
	if charid < 1 then return end

	if timer.Exists( "ALCS_GTN_STOCKREMINDER_" .. steam64 ) then
		timer.Destroy( "ALCS_GTN_STOCKREMINDER_" .. steam64 )
	end
	
	DATA:RunQuery( "SELECT * FROM wos_alcs_gtn_stock WHERE SteamID = '" .. steam64 .. "' AND CharID = " .. charid .. ";", function( queries, status, err )
		if not status then
			error( err )
		end
		local qdat = queries:getData()
		
		if table.Count( qdat ) > 0 then
			local TRANS = DATA:CreateTransaction()
			local active = false
			for _, dat in ipairs( qdat ) do
				local q_active = false
				if dat.ItemAward and #dat.ItemAward > 0 then
					local nam = dat.ItemAward
					if wOS.ALCS.Config.Crafting.ShouldCraftingUseMySQL then
						local id = wOS.ALCS.Config.Crafting.CraftingDatabase.ItemToID[ dat.ItemAward ]
						if id then
							nam = wOS.ALCS.Config.Crafting.CraftingDatabase.IDToItem[ id ]
							if nam then
								if !wOS:HandleItemPickup( ply, nam ) then
									ply:SendLua( [[ surface.PlaySound( "buttons/lightswitch2.wav" ) ]] )
									ply:SendLua( [[ notification.AddLegacy( "[wOS] Failed to redeem ]] .. nam .. [[, not enough inventory space!", NOTIFY_ERROR, 3 ) ]] )										
									continue
								end
								q_active = true
							end
						end
					else
						if !wOS:HandleItemPickup( ply, nam ) then
							ply:SendLua( [[ surface.PlaySound( "buttons/lightswitch2.wav" ) ]] )
							ply:SendLua( [[ notification.AddLegacy( "[wOS] Failed to redeem ]] .. nam .. [[, not enough inventory space!", NOTIFY_ERROR, 3 ) ]] )										
							continue
						end	
						q_active = true			
					end
				end
				
				if dat.CashAward and dat.CashAward != 0 then
					wOS.ALCS:AddPlayerCurrency( ply, dat.CashAward )
					q_active = true
				end
				
				if q_active then
					active = true
					TRANS:Query( "DELETE FROM wos_alcs_gtn_stock WHERE ID = " .. dat.ID .. ";" )
				end
			end
			
			if active then
				TRANS:Start( function( transaction, status, err )
					if (!status) then print("[MYSQL ERROR] " .. err) end
				end )
			end
			
		else
			ply:SendLua( [[ surface.PlaySound( "buttons/lightswitch2.wav" ) ]] )
			ply:SendLua( [[ notification.AddLegacy( "[wOS] You have no items in stock!", NOTIFY_ERROR, 3 ) ]] )			
		end

	end )
	
end

function wOS.ALCS.GTN.DataStore:GetAuctionListings( ply )
	
	if ply:IsBot() then return end
	local steam64 = ply:SteamID64()
	
	local charid = wOS.ALCS:GetCharacterID( ply ) or 1
	if charid < 1 then return end

	DATA:RunQuery( "SELECT * FROM wos_alcs_gtn_auctions WHERE Expiration > NOW()", function( queries, status, err )
		if not status then
			error( err )
		end
		local qdat = queries:getData()
		wOS.ALCS.GTN:SendAuctionList( ply, qdat )
	end )
	
end

function wOS.ALCS.GTN.DataStore:GetTradeListings( ply )
	
	if ply:IsBot() then return end
	local steam64 = ply:SteamID64()
	
	local charid = wOS.ALCS:GetCharacterID( ply ) or 1
	if charid < 1 then return end

	DATA:RunQuery( "SELECT * FROM wos_alcs_gtn_trades WHERE Expiration > NOW()", function( queries, status, err )
		if not status then
			error( err )
		end
		local qdat = queries:getData()
		wOS.ALCS.GTN:SendTradeList( ply, qdat )
	end )
	
end

function wOS.ALCS.GTN.DataStore:MakeAuctionOffer( ply, data, offer )
	
	if ply:IsBot() then return end
	local steam64 = ply:SteamID64()
	
	local charid = wOS.ALCS:GetCharacterID( ply ) or 1
	if charid < 1 then return end

	DATA:RunQuery(  "SELECT * FROM wos_alcs_gtn_auctions WHERE ID = " .. data.ID .. " AND SteamID = '" .. DATA:escape( data.SteamID ) .. "' AND CharID = " .. data.CharID, function( queries, status, err )
		if not status then
			error( err )
		end
		local dat = queries:getData()[1]

		if not dat then 
			ply:SendLua( [[ surface.PlaySound( "buttons/lightswitch2.wav" ) ]] )
			ply:SendLua( [[ notification.AddLegacy( "[wOS] This auction does not exist!", NOTIFY_ERROR, 3 ) ]] )
			return 
		end
		local amt = tonumber( dat.CurrentBid )

		if offer <= amt then
			ply:SendLua( [[ surface.PlaySound( "buttons/lightswitch2.wav" ) ]] )
			ply:SendLua( [[ notification.AddLegacy( "[wOS] Your offer of ]] .. offer .. [[ has been outbid!", NOTIFY_ERROR, 3 ) ]] )
			return
		end	

		if dat.SteamID != dat.BidderSteamID then
			DATA:RunQuery( [[INSERT INTO wos_alcs_gtn_stock( SteamID, CharID, ItemAward, CashAward ) SELECT t.BidderSteamID,t.BidderCharID,'',t.CurrentBid FROM wos_alcs_gtn_auctions t WHERE t.ID = ]] .. dat.ID .. [[;]] )		
		end

		DATA:RunQuery( [[UPDATE wos_alcs_gtn_auctions SET BidderSteamID = ]] .. steam64 .. [[,  BidderCharID = ]] .. charid .. [[, CurrentBid = ]] .. offer .. [[ WHERE ID = ]] .. dat.ID .. [[;]] )

		ply:SendLua( [[ surface.PlaySound( "buttons/lightswitch2.wav" ) ]] )
		ply:SendLua( [[ notification.AddLegacy( "[wOS] Your offer of ]] .. offer .. [[ has successfully placed!", NOTIFY_HINT, 3 ) ]] )	

		wOS.ALCS:AddPlayerCurrency( ply, -1*offer )

	end )

end

function wOS.ALCS.GTN.DataStore:MakeAuctionBuyNow( ply, data )
	
	if ply:IsBot() then return end
	local steam64 = ply:SteamID64()
	
	local charid = wOS.ALCS:GetCharacterID( ply ) or 1
	if charid < 1 then return end

	DATA:RunQuery( "SELECT * FROM wos_alcs_gtn_auctions WHERE ID = " .. data.ID .. " AND SteamID = '" .. DATA:escape( data.SteamID ) .. "' AND CharID = " .. data.CharID, function( queries, status, err )
		if not status then
			error( err )
		end
		local dat = queries:getData()[1]

		if not dat then 
			ply:SendLua( [[ surface.PlaySound( "buttons/lightswitch2.wav" ) ]] )
			ply:SendLua( [[ notification.AddLegacy( "[wOS] This auction does not exist!", NOTIFY_ERROR, 3 ) ]] )
			return 
		end
		
		local amt = tonumber( dat.BuyNowPrice )
		if amt <= 0 then
			ply:SendLua( [[ surface.PlaySound( "buttons/lightswitch2.wav" ) ]] )
			ply:SendLua( [[ notification.AddLegacy( "[wOS] Auction does not accept Buy It Now offers!", NOTIFY_ERROR, 3 ) ]] )
			return
		end

		if wOS.ALCS:GetPlayerCurrency( ply ) < amt then
			ply:SendLua( [[ surface.PlaySound( "buttons/lightswitch2.wav" ) ]] )
			ply:SendLua( [[ notification.AddLegacy( "[wOS] Insufficient funds to buy this auction out!", NOTIFY_ERROR, 3 ) ]] )
			return
		end	

		DATA:RunQuery( [[ INSERT INTO wos_alcs_gtn_stock( SteamID, CharID, ItemAward, CashAward )
		SELECT t.BidderSteamID,t.BidderCharID,'',t.BuyNowPrice
		FROM wos_alcs_gtn_auctions t
		WHERE t.ID = ]] .. dat.ID .. [[;
		
		INSERT INTO wos_alcs_gtn_stock( SteamID, CharID, ItemAward, CashAward )
		VALUES( ]] .. steam64 .. [[,]] .. charid .. [[,']] .. DATA:escape( dat.Item ) .. [[',0);

		DELETE FROM wos_alcs_gtn_auctions 
		WHERE ID = ]] .. dat.ID .. [[;]] )
		

		ply:SendLua( [[ surface.PlaySound( "buttons/lightswitch2.wav" ) ]] )
		ply:SendLua( [[ notification.AddLegacy( "[wOS] You have bought out the auction! Your items have been placed in the stock", NOTIFY_HINT, 3 ) ]] )	

		wOS.ALCS:AddPlayerCurrency( ply, -1*amt )

		local sel = player.GetBySteamID64( dat.SteamID )
		if IsValid( sel ) then
			self:CheckStock( sel )
		end

	end )

end

function wOS.ALCS.GTN.DataStore:BuyTradeOut( ply, data )
	
	if ply:IsBot() then return end
	local steam64 = ply:SteamID64()
	
	local charid = wOS.ALCS:GetCharacterID( ply ) or 1
	if charid < 1 then return end

	DATA:RunQuery( "SELECT * FROM wos_alcs_gtn_trades WHERE ID = " .. data.ID .. " AND SteamID = '" .. DATA:escape( data.SteamID ) .. "' AND CharID = " .. data.CharID, function( queries, status, err )
		if not status then
			error( err )
		end
		local dat = queries:getData()[1]

		if not dat then 
			ply:SendLua( [[ surface.PlaySound( "buttons/lightswitch2.wav" ) ]] )
			ply:SendLua( [[ notification.AddLegacy( "[wOS] This trade offer does not exist!", NOTIFY_ERROR, 3 ) ]] )
			return 
		end

		if wOS:GetItemAmount( ply, dat.RequestedItem ) < 1 then
			ply:SendLua( [[ surface.PlaySound( "buttons/lightswitch2.wav" ) ]] )
			ply:SendLua( [[ notification.AddLegacy( "[wOS] You do not have the requested item in your inventory!", NOTIFY_ERROR, 3 ) ]] )
			return
		end

		DATA:RunQuery( [[ INSERT INTO wos_alcs_gtn_stock( SteamID, CharID, ItemAward, CashAward )
		SELECT t.SteamID,t.CharID,t.RequestedItem,0
		FROM wos_alcs_gtn_trades t
		WHERE t.ID = ]] .. dat.ID .. [[;
		
		INSERT INTO wos_alcs_gtn_stock( SteamID, CharID, ItemAward, CashAward )
		VALUES( ]] .. steam64 .. [[,]] .. charid .. [[,']] .. DATA:escape( dat.Item ) .. [[',0);

		DELETE FROM wos_alcs_gtn_trades 
		WHERE ID = ]] .. dat.ID .. [[;]] )
		

		wOS:RemoveItemBulk( ply, dat.RequestedItem )

		ply:SendLua( [[ surface.PlaySound( "buttons/lightswitch2.wav" ) ]] )
		ply:SendLua( [[ notification.AddLegacy( "[wOS] You have accepted the trade! Your items have been placed in the stock", NOTIFY_HINT, 3 ) ]] )

		local sel = player.GetBySteamID64( dat.SteamID )
		if IsValid( sel ) then
			self:CheckStock( sel )
		end

	end )

end

function wOS.ALCS.GTN.DataStore:DeleteData( ply, charid )

	if ply:IsBot() then return end
	local steam64 = ply:SteamID64()
	if charid < 1 then return end

	DATA:RunQuery( "DELETE FROM wos_alcs_gtn_auctions WHERE SteamID = '" .. steam64 .. "' AND CharID = " .. charid )
	DATA:RunQuery( "DELETE FROM wos_alcs_gtn_trades WHERE SteamID = '" .. steam64 .. "' AND CharID = " .. charid )
	DATA:RunQuery( "DELETE FROM wos_alcs_gtn_stock WHERE SteamID = '" .. steam64 .. "' AND CharID = " .. charid )

end

if wOS.ALCS.Config.GTN.StockCheckRate then
	timer.Create( "wOS.ALCS.GTN.StockChecker", wOS.ALCS.Config.GTN.StockCheckRate, 0, function() 
		for _, ply in ipairs( player.GetAll() ) do
			wOS.ALCS.GTN.DataStore:CheckStock( ply )
		end
	end )
end

hook.Add("wOS.ALCS.PlayerLoadData", "wOS.ALCS.GTN.LoadDataForChar", function( ply )
	wOS.ALCS.GTN.DataStore:CheckStock( ply )
end )  

hook.Add("wOS.ALCS.PlayerDeleteData", "wOS.ALCS.GTN.DeleteDataForChar", function( ply, charid )
	wOS.ALCS.GTN.DataStore:DeleteData( ply, charid )
end )