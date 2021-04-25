--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2020
	
	Contact: www.wiltostech.com
		
----------------------------------------]]--

wOS = wOS or {}


AddCSLuaFile( "wos/advswl/trade/core/cl_core.lua" )	
AddCSLuaFile( "wos/advswl/trade/core/cl_menu_library.lua" )	
AddCSLuaFile( "wos/advswl/trade/core/cl_net.lua" )
AddCSLuaFile( "wos/advswl/trade/core/sh_core.lua" )

include( "wos/advswl/trade/core/sh_core.lua" )
if wOS.ALCS.Config.GTN.ShouldUseMySQL then
	include( "wos/advswl/trade/wrappers/sv_mysql.lua" )
else
	include( "wos/advswl/trade/wrappers/sv_data.lua" )
end

wOS.ALCS:ServerInclude( "wos/advswl/trade/core/sv_net.lua" )
wOS.ALCS:ServerInclude( "wos/advswl/trade/core/sv_core.lua" )
