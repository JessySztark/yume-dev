--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2020
	
	Contact: www.wiltostech.com
		----------------------------------------]]--








































































wOS = wOS or {}
wOS.AvailablePowers = wOS.AvailablePowers or {}
wOS.ForceIcons = wOS.ForceIcons or {}

net.Receive( "wOS.Lightsabers.SendAllForceData", function()
	wOS.AvailablePowers = net.ReadTable()
	for name, data in pairs( wOS.AvailablePowers ) do
		if data.image then
			wOS.ForceIcons[ name ] = Material( data.image, "unlitgeneric" )
		end
	end
end )