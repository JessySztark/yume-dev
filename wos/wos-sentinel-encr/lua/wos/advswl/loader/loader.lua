--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2020
	
	Contact: www.wiltostech.com
		
----------------------------------------]]--

wOS = wOS or {}
wOS.Lightsaber = wOS.Lightsaber or {}
wOS.ALCS = wOS.ALCS or {}

--This order may look completely stupid, and you'd ask why I wouldn't just cluster them all together
--Well, load orders are very important, and this is the best way to control it

local string = string
local file = file

if SERVER then
	AddCSLuaFile( "wos/advswl/config/_loader_/cl_loader.lua" )	
	include( "wos/advswl/config/_loader_/sv_loader.lua" )	
else
	include( "wos/advswl/config/_loader_/cl_loader.lua" )	
end

if SERVER then
	
	AddCSLuaFile( "wos/advswl/robot-boy/cl_rb655_lightsaber.lua" )	
	
	AddCSLuaFile( "wos/advswl/core/cl_core.lua" )
	AddCSLuaFile( "wos/advswl/core/cl_form_menu.lua" )
	AddCSLuaFile( "wos/advswl/core/cl_net.lua" )
	AddCSLuaFile( "wos/advswl/core/sh_core.lua" )
	AddCSLuaFile( "wos/advswl/core/sh_hilt_extension.lua" )
	AddCSLuaFile( "wos/advswl/core/cl_wyozi_tdui.lua" )	
	
	AddCSLuaFile( "wos/advswl/anim/sh_forcesequence.lua" )
	AddCSLuaFile( "wos/advswl/anim/cl_forcesequence.lua" )
	
	AddCSLuaFile( "wos/advswl/combat/cl_dualsaber.lua" )	
	AddCSLuaFile( "wos/advswl/combat/cl_saberbase_hook.lua" )		
	
	AddCSLuaFile( "wos/advswl/forcesys/cl_core.lua" )	
	AddCSLuaFile( "wos/advswl/forcesys/cl_net.lua" )
	
	AddCSLuaFile( "wos/advswl/devsys/cl_core.lua" )	
	AddCSLuaFile( "wos/advswl/devsys/cl_net.lua" )
	
	AddCSLuaFile( "wos/advswl/crafting/loader/loader.lua" )	
	
	AddCSLuaFile( "wos/advswl/formsys/cl_forms.lua" )	
	
	AddCSLuaFile( "wos/advswl/skills/loader/loader.lua" )	
	
	AddCSLuaFile( "wos/advswl/adminmenu/cl_core.lua" )	
	AddCSLuaFile( "wos/advswl/adminmenu/cl_net.lua" )	
	
end
	
include( "wos/advswl/core/sh_core.lua" )
include( "wos/advswl/core/sh_hilt_extension.lua" )
include( "wos/advswl/anim/sh_forcesequence.lua" )

if SERVER then
	
	include( "wos/advswl/anim/sh_forcesequence.lua" )
	include( "wos/advswl/core/sv_mysqloo_funcs.lua" )
	
	wOS.ALCS:ServerInclude( "wos/advswl/robot-boy/sv_rb655_lightsaber.lua" )	
	
	wOS.ALCS:ServerInclude( "wos/advswl/core/sv_resources.lua" )		
	wOS.ALCS:ServerInclude( "wos/advswl/core/sv_concommands.lua" )	
	wOS.ALCS:ServerInclude( "wos/advswl/core/sv_core.lua" )
	wOS.ALCS:ServerInclude( "wos/advswl/core/sv_net.lua" )
	wOS.ALCS:ServerInclude( "wos/advswl/core/sv_saber_registry.lua" )
	
	wOS.ALCS:ServerInclude( "wos/advswl/anim/sv_forcesequence.lua" )
	
	wOS.ALCS:ServerInclude( "wos/advswl/combat/sv_saberbase_hook.lua" )		
	wOS.ALCS:ServerInclude( "wos/advswl/combat/sv_combat_hook.lua" )	
			
	wOS.ALCS:ServerInclude( "wos/advswl/forcesys/sv_core.lua" )		
	wOS.ALCS:ServerInclude( "wos/advswl/forcesys/sv_net.lua" )	
	
	wOS.ALCS:ServerInclude( "wos/advswl/devsys/sv_core.lua" )		
	wOS.ALCS:ServerInclude( "wos/advswl/devsys/sv_net.lua" )		
	
	wOS.ALCS:ServerInclude( "wos/advswl/formsys/sv_forms.lua" )		
	wOS.ALCS:ServerInclude( "wos/advswl/formsys/sv_form_register.lua" )
	
	wOS.ALCS:ServerInclude( "wos/advswl/adminmenu/sv_net.lua" )	
	
else

	include( "wos/advswl/robot-boy/cl_rb655_lightsaber.lua" )	
	
	include( "wos/advswl/core/cl_core.lua" )
	include( "wos/advswl/core/cl_net.lua" )
	include( "wos/advswl/core/cl_wyozi_tdui.lua" )
	
	include( "wos/advswl/anim/cl_forcesequence.lua" )
	
	include( "wos/advswl/combat/cl_dualsaber.lua" )	
	include( "wos/advswl/combat/cl_saberbase_hook.lua" )		
	
	include( "wos/advswl/forcesys/cl_core.lua" )	
	include( "wos/advswl/core/cl_form_menu.lua" )
	include( "wos/advswl/forcesys/cl_net.lua" )
	
	include( "wos/advswl/devsys/cl_core.lua" )	
	include( "wos/advswl/devsys/cl_net.lua" )
	
	include( "wos/advswl/formsys/cl_forms.lua" )	
	
	include( "wos/advswl/adminmenu/cl_core.lua" )	 
	include( "wos/advswl/adminmenu/cl_net.lua" )	 
	
end

include( "wos/advswl/crafting/loader/loader.lua" )	
include( "wos/advswl/skills/loader/loader.lua" )	

--Fix this later
if SERVER then
	AddCSLuaFile( "wos/advswl/lightsaber/loader/cl_loader.lua" )	
	include( "wos/advswl/lightsaber/loader/sv_loader.lua" )	
else
	include( "wos/advswl/lightsaber/loader/cl_loader.lua" )	
end

if SERVER then
	AddCSLuaFile( "wos/advswl/dueling/loader/cl_loader.lua" )	
	include( "wos/advswl/dueling/loader/sv_loader.lua" )	
else
	include( "wos/advswl/dueling/loader/cl_loader.lua" )	
end

if SERVER then
	AddCSLuaFile( "wos/advswl/execsys/loader/cl_loader.lua" )	
	include( "wos/advswl/execsys/loader/sv_loader.lua" )	
else
	include( "wos/advswl/execsys/loader/cl_loader.lua" )	
end

if SERVER then
	AddCSLuaFile( "wos/advswl/character/loader/cl_loader.lua" )	
	include( "wos/advswl/character/loader/sv_loader.lua" )	
else
	include( "wos/advswl/character/loader/cl_loader.lua" )	
end

if SERVER then
	AddCSLuaFile( "wos/advswl/storage/loader/cl_loader.lua" )	
	include( "wos/advswl/storage/loader/sv_loader.lua" )	
else
	include( "wos/advswl/storage/loader/cl_loader.lua" )	
end

if SERVER then
	AddCSLuaFile( "wos/advswl/prestige/loader/cl_loader.lua" )	
	include( "wos/advswl/prestige/loader/sv_loader.lua" )	
else
	include( "wos/advswl/prestige/loader/cl_loader.lua" )	
end

if SERVER then
	AddCSLuaFile( "wos/advswl/trade/loader/cl_loader.lua" )	
	include( "wos/advswl/trade/loader/sv_loader.lua" )	
else
	include( "wos/advswl/trade/loader/cl_loader.lua" )	
end

for _,source in pairs( file.Find( "wos/advswl/addon-loader/*", "LUA"), true ) do
	local lua = "wos/advswl/addon-loader/" .. source
	if SERVER then
		AddCSLuaFile( lua )
	end
	include( lua )
end

hook.Call( "wOS.ALCS.OnLoaded" )