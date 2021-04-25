--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2020
	
	Contact: www.wiltostech.com
		----------------------------------------]]--








































































wOS = wOS or {}
wOS.AvailableDevestators = wOS.AvailableDevestators or {}
wOS.DevestatorIcons = wOS.DevestatorIcons or {}

net.Receive( "wOS.Lightsabers.SendDevestatorData", function()
	wOS.AvailableDevestators = net.ReadTable()
	for name, data in pairs( wOS.AvailableDevestators ) do
		if data.image then
			wOS.DevestatorIcons[ name ] = Material( data.image, "unlitgeneric" )
		end
	end
end )


net.Receive( "wOS.ALCS.OpenDevestatorMenu", function()
	wOS:OpenDevestatorMenu()
end )
