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
 
local MYSQL_COLUMNS_AUCTIONS = "( ID INTEGER PRIMARY KEY, SteamID BIGINT(64), CharID BIGINT(64) DEFAULT 1, Item VARCHAR(255), CurrentBid BIGINT DEFAULT 0, BidderSteamID BIGINT(64), BidderCharID BIGINT(64) DEFAULT 1, BuyNowPrice BIGINT, Creation DATETIME DEFAULT CURRENT_TIMESTAMP, Expiration DATETIME )"
local MYSQL_COLUMNS_TRADES = "( ID INTEGER PRIMARY KEY, SteamID BIGINT(64), CharID BIGINT(64) DEFAULT 1, Item VARCHAR(255), RequestedItem VARCHAR(255), Creation DATETIME DEFAULT CURRENT_TIMESTAMP, Expiration DATETIME )"
local MYSQL_COLUMNS_STOCK = "( ID INTEGER PRIMARY KEY, SteamID BIGINT(64), CharID BIGINT(64) DEFAULT 1, ItemAward VARCHAR(255), CashAward BIGINT, Creation DATETIME DEFAULT CURRENT_TIMESTAMP )"

--[[ local que = sql.Query
function sql.Query( str )
	local err = que( str )
	if isbool( err ) then
		print( "ERROR WITH QUERY: " .. str, sql.LastError() )
	end
end ]]

function wOS.ALCS.GTN.DataStore:UpdateTables( vdat )

	vdat = vdat or {}
	local version = ( vdat.DBVersion and tonumber( vdat.DBVersion ) ) or 0
	
	if version >= MYSQL_DATABASE_PROVISION then return end
	
	--This is about to be the most cancerous thing ever, but it will be moved to a different file eventually.
	if version < 1 then
		sql.Query( "CREATE TABLE IF NOT EXISTS wos_alcs_gtn_auctions " .. MYSQL_COLUMNS_AUCTIONS  .. ";" )
		sql.Query( "CREATE TABLE IF NOT EXISTS wos_alcs_gtn_trades " .. MYSQL_COLUMNS_TRADES .. ";" )
		sql.Query( "CREATE TABLE IF NOT EXISTS wos_alcs_gtn_stock " .. MYSQL_COLUMNS_STOCK .. ";" )
		version = version + 1
	end
	 
	sql.Query( "INSERT INTO wos_alcsgtn_schema ( ID, DBVersion ) VALUES ( '1', '" .. version .. "' ) ON CONFLICT(ID) DO UPDATE SET DBVersion='" .. version .. "';" )
	
end

function wOS.ALCS.GTN.DataStore:Initialize()
	 
	local rows = sql.Query( "SELECT name FROM sqlite_master WHERE type='table' AND name='wos_alcsgtn_schema';" )
	if not rows or table.Count( rows ) < 1 then
		local err = sql.Query( "CREATE TABLE IF NOT EXISTS wos_alcsgtn_schema ( `ID` INTEGER PRIMARY KEY, DBVersion INTEGER );" )
		wOS.ALCS.GTN.DataStore:UpdateTables()
	else
		local dat = sql.Query( "SELECT * FROM wos_alcsgtn_schema;" )
		wOS.ALCS.GTN.DataStore:UpdateTables( dat[1] )  
	end

end

function wOS.ALCS.GTN.DataStore:CheckStock( ply )
	
	if ply:IsBot() then return end
	local steam64 = ply:SteamID64()
	
	local charid = wOS.ALCS:GetCharacterID( ply ) or 1
	if charid < 1 then return end

	local qdat = sql.Query( "SELECT COUNT(*) FROM wos_alcs_gtn_stock WHERE SteamID = '" .. steam64 .. "' AND CharID = " .. charid .. ";" )
	qdat = qdat[1] or {}
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
	
end

function wOS.ALCS.GTN.DataStore:GetPlayerListings( ply )
	
	if ply:IsBot() then return end
	local steam64 = ply:SteamID64()
	
	local charid = wOS.ALCS:GetCharacterID( ply ) or 1
	if charid < 1 then return end

	local trades = sql.Query( "SELECT * FROM wos_alcs_gtn_trades WHERE SteamID = '" .. steam64 .. "' AND CharID = " .. charid .. ";" )
	local auctions = sql.Query( "SELECT * FROM wos_alcs_gtn_auctions WHERE SteamID = '" .. steam64 .. "' AND CharID = " .. charid .. ";" )
	trades = trades or {}
	auctions = auctions or {}

	wOS.ALCS.GTN:SendPlayerListings( ply, trades, auctions )
	
end

function wOS.ALCS.GTN.DataStore:MakeAuctionPosting( ply, data )
	
	if ply:IsBot() then return end
	local steam64 = ply:SteamID64()
	
	local charid = wOS.ALCS:GetCharacterID( ply ) or 1
	if charid < 1 then return end
	
	local dat = sql.Query( "INSERT INTO wos_alcs_gtn_auctions ( SteamID, CharID, Item, BuyNowPrice, CurrentBid, BidderSteamID, BidderCharID, Expiration ) VALUES( " .. steam64 .. "," .. charid .. ",'" .. sql.SQLStr( data.Item, true ) .. "'," .. data.BuyNowPrice .. "," .. data.StartingBid .. "," .. steam64 .. "," .. charid .. ", DATETIME('now','+" .. wOS.ALCS.Config.GTN.PostingDays .. " day'));" )

end

function wOS.ALCS.GTN.DataStore:MakeBarterPosting( ply, data )
	
	if ply:IsBot() then return end
	local steam64 = ply:SteamID64()
	
	local charid = wOS.ALCS:GetCharacterID( ply ) or 1
	if charid < 1 then return end

	local res = sql.Query( "INSERT INTO wos_alcs_gtn_trades ( SteamID, CharID, Item, RequestedItem, Expiration ) VALUES( " .. steam64 .. "," .. charid .. ",'" .. sql.SQLStr( data.Item, true ) .. "','" .. sql.SQLStr( data.RequestedItem, true ) .. "', DATETIME('now','+" .. wOS.ALCS.Config.GTN.PostingDays .. " day') );" )

end

function wOS.ALCS.GTN.DataStore:MakeAuctionOffer( ply, data, offer )
	
	if ply:IsBot() then return end
	local steam64 = ply:SteamID64()
	
	local charid = wOS.ALCS:GetCharacterID( ply ) or 1
	if charid < 1 then return end

	local dat = sql.QueryRow( "SELECT * FROM wos_alcs_gtn_auctions WHERE ID = " .. data.ID .. " AND SteamID = " .. sql.SQLStr( data.SteamID, true ) .. " AND CharID = " .. data.CharID )
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
		sql.Query( [[INSERT INTO wos_alcs_gtn_stock( SteamID, CharID, ItemAward, CashAward ) SELECT t.BidderSteamID,t.BidderCharID,'',t.CurrentBid FROM wos_alcs_gtn_auctions t WHERE t.ID = ]] .. dat.ID .. [[;]] )
	end
	
	sql.Query( [[UPDATE wos_alcs_gtn_auctions SET BidderSteamID = ]] .. steam64 .. [[,  BidderCharID = ]] .. charid .. [[, CurrentBid = ]] .. offer .. [[ WHERE ID = ]] .. dat.ID .. [[;]] )
	ply:SendLua( [[ surface.PlaySound( "buttons/lightswitch2.wav" ) ]] )
	ply:SendLua( [[ notification.AddLegacy( "[wOS] Your offer of ]] .. offer .. [[ has successfully placed!", NOTIFY_HINT, 3 ) ]] )	

	wOS.ALCS:AddPlayerCurrency( ply, -1*offer )

end

function wOS.ALCS.GTN.DataStore:MakeAuctionBuyNow( ply, data )
	
	if ply:IsBot() then return end
	local steam64 = ply:SteamID64()
	
	local charid = wOS.ALCS:GetCharacterID( ply ) or 1
	if charid < 1 then return end

	local dat = sql.QueryRow( "SELECT * FROM wos_alcs_gtn_auctions WHERE ID = " .. data.ID .. " AND SteamID = " .. sql.SQLStr( data.SteamID, true ) .. " AND CharID = " .. data.CharID )
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

	sql.Query( [[INSERT INTO wos_alcs_gtn_stock( SteamID, CharID, ItemAward, CashAward ) SELECT t.BidderSteamID,t.BidderCharID,'',t.BuyNowPrice FROM wos_alcs_gtn_auctions t WHERE t.ID = ]] .. dat.ID .. [[;]] )

	sql.Query( [[INSERT INTO wos_alcs_gtn_stock( SteamID, CharID, ItemAward, CashAward ) VALUES( ]] .. steam64 .. [[,]] .. charid .. [[,']] .. sql.SQLStr(dat.Item, true ) .. [[',0)]] )

	sql.Query( [[DELETE FROM wos_alcs_gtn_auctions WHERE ID = ]] .. dat.ID .. [[;]] )

	ply:SendLua( [[ surface.PlaySound( "buttons/lightswitch2.wav" ) ]] )
	ply:SendLua( [[ notification.AddLegacy( "[wOS] You have bought out the auction! Your items have been placed in the stock", NOTIFY_HINT, 3 ) ]] )	

	wOS.ALCS:AddPlayerCurrency( ply, -1*amt )

	local sel = player.GetBySteamID64( dat.SteamID )
	if IsValid( sel ) then
		self:CheckStock( sel )
	end

end

function wOS.ALCS.GTN.DataStore:BuyTradeOut( ply, data )
	
	if ply:IsBot() then return end
	local steam64 = ply:SteamID64()
	
	local charid = wOS.ALCS:GetCharacterID( ply ) or 1
	if charid < 1 then return end

	local dat = sql.QueryRow( "SELECT * FROM wos_alcs_gtn_trades WHERE ID = " .. data.ID .. " AND SteamID = " .. sql.SQLStr( data.SteamID, true ) .. " AND CharID = " .. data.CharID )
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

	sql.Query( [[INSERT INTO wos_alcs_gtn_stock( SteamID, CharID, ItemAward, CashAward ) SELECT t.SteamID,t.CharID,t.RequestedItem,0 FROM wos_alcs_gtn_trades t WHERE t.ID = ]] .. dat.ID .. [[;]] )
	sql.Query( [[INSERT INTO wos_alcs_gtn_stock( SteamID, CharID, ItemAward, CashAward ) VALUES( ]] .. steam64 .. [[,]] .. charid .. [[,']] .. sql.SQLStr(dat.Item, true ) .. [[',0)]] )
	sql.Query( [[DELETE FROM wos_alcs_gtn_trades WHERE ID = ]] .. dat.ID .. [[;]] )

	wOS:RemoveItemBulk( ply, dat.RequestedItem )

	ply:SendLua( [[ surface.PlaySound( "buttons/lightswitch2.wav" ) ]] )
	ply:SendLua( [[ notification.AddLegacy( "[wOS] You have accepted the trade! Your items have been placed in the stock", NOTIFY_HINT, 3 ) ]] )	

	local sel = player.GetBySteamID64( dat.SteamID )
	if IsValid( sel ) then
		self:CheckStock( sel )
	end

end


function wOS.ALCS.GTN.DataStore:RedeemStock( ply )
	
	if ply:IsBot() then return end
	local steam64 = ply:SteamID64()
	
	local charid = wOS.ALCS:GetCharacterID( ply ) or 1
	if charid < 1 then return end

	if timer.Exists( "ALCS_GTN_STOCKREMINDER_" .. steam64 ) then
		timer.Destroy( "ALCS_GTN_STOCKREMINDER_" .. steam64 )
	end

	local qdat = sql.Query( "SELECT * FROM wos_alcs_gtn_stock WHERE SteamID = '" .. steam64 .. "' AND CharID = " .. charid .. ";" )
	qdat = qdat or {}

	if not qdat then return end
	
	if table.Count( qdat ) > 0 then
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
			
			if dat.CashAward and tonumber( dat.CashAward ) != 0 then
				wOS.ALCS:AddPlayerCurrency( ply, tonumber( dat.CashAward ) )
				q_active = true
			end
			
			if q_active then
				sql.Query( "DELETE FROM wos_alcs_gtn_stock WHERE ID = " .. dat.ID .. ";" )
			end
		end
		
	else
		ply:SendLua( [[ surface.PlaySound( "buttons/lightswitch2.wav" ) ]] )
		ply:SendLua( [[ notification.AddLegacy( "[wOS] You have no items in stock!", NOTIFY_HINT, 3 ) ]] )	
	end

end

function wOS.ALCS.GTN.DataStore:GetAuctionListings( ply )
	
	if ply:IsBot() then return end
	local steam64 = ply:SteamID64()
	
	local charid = wOS.ALCS:GetCharacterID( ply ) or 1
	if charid < 1 then return end

	local qdat = sql.Query( "SELECT * FROM wos_alcs_gtn_auctions WHERE Expiration > DATETIME('now')" )
	qdat = qdat or {}
	
	wOS.ALCS.GTN:SendAuctionList( ply, qdat )
	
end

function wOS.ALCS.GTN.DataStore:GetTradeListings( ply )
	
	if ply:IsBot() then return end
	local steam64 = ply:SteamID64()
	
	local charid = wOS.ALCS:GetCharacterID( ply ) or 1
	if charid < 1 then return end

	local qdat = sql.Query( "SELECT * FROM wos_alcs_gtn_trades WHERE Expiration > DATETIME('now')" )
	qdat = qdat or {}

	wOS.ALCS.GTN:SendTradeList( ply, qdat )

end

function wOS.ALCS.GTN.DataStore:RemoveListing( ply, id, trade )
	
	if ply:IsBot() then return end
	local steam64 = ply:SteamID64()
	
	local charid = wOS.ALCS:GetCharacterID( ply ) or 1
	if charid < 1 then return end

	local tbl = ( trade and "wos_alcs_gtn_trades" ) or "wos_alcs_gtn_auctions"

	local lst = sql.Query( "SELECT * FROM " .. tbl .. " WHERE SteamID = " .. steam64 .. " AND CharID = " .. charid .. " AND ID = " .. id .. ";" )
	lst = lst or {}
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
			
			local sl = sql.Query( [[ INSERT INTO wos_alcs_gtn_stock( SteamID, CharID, ItemAward, CashAward ) SELECT t.BidderSteamID,t.BidderCharID,'',t.CurrentBid FROM wos_alcs_gtn_auctions t WHERE t.ID = ]] .. id .. [[;]] )
			
			local sl = sql.Query( [[INSERT INTO wos_alcs_gtn_stock( SteamID, CharID, ItemAward, CashAward ) SELECT t.SteamID,t.CharID,t.Item,0 FROM wos_alcs_gtn_auctions t WHERE t.ID = ]] .. id .. [[;]] )
			delete = true
			
			ply:SendLua( [[ surface.PlaySound( "buttons/lightswitch2.wav" ) ]] )
			ply:SendLua( [[ notification.AddLegacy( "[wOS] Your listing has been placed in the stock for your redemption.", NOTIFY_HINT, 3 ) ]] )	
			
		end
		if delete then
			sql.Query( "DELETE FROM " .. tbl .. " WHERE SteamID = " .. steam64 .. " AND CharID = " .. charid .. " AND ID = " .. id .. ";" )
			wOS.ALCS:AddPlayerCurrency( ply, -1*wOS.ALCS.Config.GTN.CancelTax )
		end
		
	end

	
end

function wOS.ALCS.GTN.DataStore:CheckAllAuctions()

	sql.Query( [[INSERT INTO wos_alcs_gtn_stock( SteamID, CharID, ItemAward, CashAward ) SELECT t.BidderSteamID,t.BidderCharID,t.Item,t.CurrentBid*-1 FROM wos_alcs_gtn_auctions t WHERE t.Expiration <= DATETIME('now');]] )
	
	sql.Query( [[INSERT INTO wos_alcs_gtn_stock( SteamID, CharID, ItemAward, CashAward ) SELECT t.SteamID,t.CharID,'',t.CurrentBid FROM wos_alcs_gtn_auctions t WHERE t.Expiration <= DATETIME('now');]] )
	
	sql.Query( [[DELETE FROM wos_alcs_gtn_auctions WHERE Expiration <= DATETIME('now');]] )
	
	sql.Query( [[DELETE FROM wos_alcs_gtn_trades WHERE Expiration <= DATETIME('now');]] )
	
end


function wOS.ALCS.GTN.DataStore:DeleteData( ply, charid )

	if ply:IsBot() then return end
	local steam64 = ply:SteamID64()
	if charid < 1 then return end

	sql.Query( "DELETE FROM wos_alcs_gtn_auctions WHERE SteamID = '" .. steam64 .. "' AND CharID = " .. charid )
	sql.Query( "DELETE FROM wos_alcs_gtn_trades WHERE SteamID = '" .. steam64 .. "' AND CharID = " .. charid )
	sql.Query( "DELETE FROM wos_alcs_gtn_stock WHERE SteamID = '" .. steam64 .. "' AND CharID = " .. charid )

end


timer.Create( "wOS.ALCS.GTN.AuctionChecker", wOS.ALCS.Config.GTN.AuctionCheckRate*60, 0, function()
	wOS.ALCS.GTN.DataStore:CheckAllAuctions()
end )

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