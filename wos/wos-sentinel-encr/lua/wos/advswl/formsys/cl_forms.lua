--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2020
	
	Contact: www.wiltostech.com
		----------------------------------------]]--








































































wOS = wOS or {}
																																																																																		
net.Receive( "wOS.SendForm", function( len, ply )

	wOS.Form = net.ReadTable()
	print( "[wOS] Advanced Lightsaber Forms have been localized!" )

end )

net.Receive( "wOS.SendFGroups", function( len, ply )

	wOS.Forms = net.ReadTable()
	wOS.DualForms = net.ReadTable()

end )