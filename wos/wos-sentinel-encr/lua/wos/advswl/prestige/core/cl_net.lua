--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2020
	
	Contact: www.wiltostech.com
		----------------------------------------]]--








































































wOS = wOS or {}
wOS.ALCS = wOS.ALCS or {}
wOS.ALCS.Prestige = wOS.ALCS.Prestige or {}
wOS.ALCS.Prestige.MapData = wOS.ALCS.Prestige.MapData or {}																
net.Receive( "wOS.ALCS.Prestige.SendPlayerData", function()

	wOS.ALCS.Prestige.Data = net.ReadTable()
	
end )

net.Receive( "wOS.ALCS.Prestige.SendMapData", function()

	wOS.ALCS.Prestige.MapData = net.ReadTable()
	
	for slot, dat in pairs( wOS.ALCS.Prestige.MapData.Paths ) do
		if dat.Icon then
			dat.Icon = wOS.ALCS.Skills:PrecacheIcon( "wos-alcs-prestigemap-" .. slot, dat.Icon )
		end
	end
	
end )