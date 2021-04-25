--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2020
	
	Contact: www.wiltostech.com
		
----------------------------------------]]--

wOS = wOS or {}


AddCSLuaFile( "wos/advswl/prestige/core/cl_core.lua" )	
AddCSLuaFile( "wos/advswl/prestige/core/cl_menu_library.lua" )	
AddCSLuaFile( "wos/advswl/prestige/core/cl_net.lua" )
AddCSLuaFile( "wos/advswl/prestige/core/sh_core.lua" )

include( "wos/advswl/prestige/core/sh_core.lua" )
if wOS.ALCS.Config.Prestige.ShouldUseMySQL then
	include( "wos/advswl/prestige/wrappers/sv_mysql.lua" )
else
	include( "wos/advswl/prestige/wrappers/sv_data.lua" )
end

wOS.ALCS:ServerInclude( "wos/advswl/prestige/core/sv_net.lua" )
wOS.ALCS:ServerInclude( "wos/advswl/prestige/core/sv_core.lua" )
