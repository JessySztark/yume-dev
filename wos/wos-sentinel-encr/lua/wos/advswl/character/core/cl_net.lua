--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2020
	
	Contact: www.wiltostech.com
		----------------------------------------]]--








































































wOS = wOS or {}
wOS.ALCS = wOS.ALCS or {}

net.Receive( "wOS.ALCS.GetSaberPreferences", function( len )

	wOS.ALCS.LightsaberPreferences = net.ReadTable()
	
end )