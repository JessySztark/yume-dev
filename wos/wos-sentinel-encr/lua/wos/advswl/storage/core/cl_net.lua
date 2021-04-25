--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2020
	
	Contact: www.wiltostech.com
		----------------------------------------]]--








































































wOS = wOS or {}
wOS.ALCS = wOS.ALCS or {}
wOS.ALCS.Storage = wOS.ALCS.Storage or {}																																																																										

net.Receive( "wOS.ALCS.Storage.SendPlayerData", function()

	wOS.ALCS.Storage.Data = net.ReadTable()
	
end )

net.Receive( "wOS.ALCS.Storage.Refresh", function( len )

	wOS.ALCS.Skills:ChangeCamFocus( "Storage-ViewDeck" )

end )