--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2020
	
	Contact: www.wiltostech.com
		----------------------------------------]]--








































































wOS = wOS or {}
wOS.ALCS = wOS.ALCS or {}
wOS.ALCS.GTN = wOS.ALCS.GTN or {}															
wOS.ALCS.GTN.BufferInfo = wOS.ALCS.GTN.BufferInfo or {}
wOS.ALCS.GTN.BufferInfo.Data = wOS.ALCS.GTN.BufferInfo.Data or {}
wOS.ALCS.GTN.BufferInfo.LastUpdated = wOS.ALCS.GTN.BufferInfo.LastUpdated or math.huge

net.Receive( "wOS.ALCS.GTN.SendPlayerTrades", function( len, ply )
	
	local init = net.ReadBool()
	if init then
		wOS.ALCS.GTN.BufferInfo.LastUpdated = CurTime()
		wOS.ALCS.GTN.BufferInfo.Data.Trades = {}
	end

	local tbl = net.ReadTable()
	table.Add( wOS.ALCS.GTN.BufferInfo.Data.Trades, tbl )
	
end )

net.Receive( "wOS.ALCS.GTN.SendPlayerAuctions", function( len, ply )
	
	local init = net.ReadBool()
	if init then
		wOS.ALCS.GTN.BufferInfo.LastUpdated = CurTime()
		wOS.ALCS.GTN.BufferInfo.Data.Auctions = {}
	end

	local tbl = net.ReadTable()
	table.Add( wOS.ALCS.GTN.BufferInfo.Data.Auctions, tbl )
	
end )

net.Receive( "wOS.ALCS.GTN.SendAuctions", function( len, ply )
	
	local init = net.ReadBool()
	if init then
		wOS.ALCS.GTN.BufferInfo.LastUpdated = CurTime()
		wOS.ALCS.GTN.BufferInfo.Data = {}
	end

	local tbl = net.ReadTable()
	table.Add( wOS.ALCS.GTN.BufferInfo.Data, tbl )

end )

net.Receive( "wOS.ALCS.GTN.SendTrades", function( len, ply )
	
	local init = net.ReadBool()
	if init then
		wOS.ALCS.GTN.BufferInfo.LastUpdated = CurTime()
		wOS.ALCS.GTN.BufferInfo.Data = {}
	end

	local tbl = net.ReadTable()
	table.Add( wOS.ALCS.GTN.BufferInfo.Data, tbl )
	
end )


net.Receive( "wOS.ALCS.GTN.RefreshClearedListing", function( len, ply )
	local trade = net.ReadBool()
	local id = net.ReadInt( 32 )
	local tbl = ( trade and wOS.ALCS.GTN.BufferInfo.Data.Trades ) or wOS.ALCS.GTN.BufferInfo.Data.Auctions

	for k, dat in pairs( tbl ) do
		if tonumber( dat.ID ) == id then
			if trade then
				table.remove( wOS.ALCS.GTN.BufferInfo.Data.Trades, k )
			else
				table.remove( wOS.ALCS.GTN.BufferInfo.Data.Auctions, k )
			end
			wOS.ALCS.GTN:RefreshMenu()
			return
		end
	end

end )