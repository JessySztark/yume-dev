--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2020
	
	Contact: www.wiltostech.com
		
----------------------------------------]]--

wOS = wOS or {}


AddCSLuaFile( "wos/advswl/storage/core/cl_core.lua" )	
AddCSLuaFile( "wos/advswl/storage/core/cl_menu_library.lua" )	
AddCSLuaFile( "wos/advswl/storage/core/cl_net.lua" )

if wOS.ALCS.Config.Crafting.ShouldCraftingUseMySQL then
	include( "wos/advswl/storage/wrappers/sv_mysql.lua" )
else
	include( "wos/advswl/storage/wrappers/sv_data.lua" )
end

wOS.ALCS:ServerInclude( "wos/advswl/storage/core/sv_net.lua" )
wOS.ALCS:ServerInclude( "wos/advswl/storage/core/sv_core.lua" )
