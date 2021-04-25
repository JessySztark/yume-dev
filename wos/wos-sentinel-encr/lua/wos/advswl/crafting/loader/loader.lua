--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2020
	
	Contact: www.wiltostech.com
		
----------------------------------------]]--

wOS = wOS or {}

--This order may look completely stupid, and you'd ask why I wouldn't just cluster them all together
--Well, load orders are very important, and this is the best way to control it

if SERVER then

	AddCSLuaFile( "wos/advswl/crafting/core/sh_enums.lua" )
	AddCSLuaFile( "wos/advswl/crafting/core/cl_core.lua" )	
	AddCSLuaFile( "wos/advswl/crafting/core/cl_net.lua" )
	AddCSLuaFile( "wos/advswl/crafting/inventory/cl_core.lua" )
	AddCSLuaFile( "wos/advswl/crafting/core/sh_core.lua" )
	
end

include( "wos/advswl/crafting/core/sh_enums.lua" )
include( "wos/advswl/crafting/core/sh_core.lua" )
 

if SERVER then

	if wOS.ALCS.Config.Crafting.ShouldCraftingUseMySQL then
		include( "wos/advswl/crafting/wrappers/sv_mysql.lua" )
	else
		include( "wos/advswl/crafting/wrappers/sv_data.lua" )
	end
	
	wOS.ALCS:ServerInclude( "wos/advswl/crafting/core/sv_core.lua" )
	wOS.ALCS:ServerInclude( "wos/advswl/crafting/core/sv_item_register.lua" )
	wOS.ALCS:ServerInclude( "wos/advswl/crafting/core/sv_net.lua" )
	wOS.ALCS:ServerInclude( "wos/advswl/crafting/core/sv_concommands.lua" )
	wOS.ALCS:ServerInclude( "wos/advswl/crafting/inventory/sv_core.lua" )
	wOS.ALCS:ServerInclude( "wos/advswl/crafting/core/sv_craft_meta.lua" )
	
else
	include( "wos/advswl/crafting/core/cl_core.lua" )
	include( "wos/advswl/crafting/core/cl_net.lua" )
	include( "wos/advswl/crafting/inventory/cl_core.lua" )
	
end