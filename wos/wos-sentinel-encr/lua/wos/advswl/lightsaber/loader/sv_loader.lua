--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2020
	
	Contact: www.wiltostech.com
		
----------------------------------------]]--

wOS = wOS or {}
wOS.ALCS = wOS.ALCS or {}
wOS.ALCS.LightsaberBase = wOS.ALCS.LightsaberBase or {}

local dir = "wos/advswl/lightsaber"

AddCSLuaFile( dir .. "/core/cl_create_register.lua" )
AddCSLuaFile( dir .. "/core/cl_hud.lua" )
AddCSLuaFile( dir .. "/core/cl_core.lua" )

wOS.ALCS:ServerInclude( dir .. "/core/sv_call_register.lua" )

wOS.ALCS:ServerInclude( dir .. "/core/sv_stamina.lua" )
wOS.ALCS:ServerInclude( dir .. "/core/sv_grips.lua" )
wOS.ALCS:ServerInclude( dir .. "/core/sv_blades.lua" )
wOS.ALCS:ServerInclude( dir .. "/core/sv_binds.lua" )
wOS.ALCS:ServerInclude( dir .. "/core/sv_trace_functions.lua" )
wOS.ALCS:ServerInclude( dir .. "/core/sv_targeting.lua" )

wOS.ALCS:ServerInclude( dir .. "/core/sv_core.lua" )

