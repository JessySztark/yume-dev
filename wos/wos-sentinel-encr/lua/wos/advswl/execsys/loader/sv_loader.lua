--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2020
	
	Contact: www.wiltostech.com
		
----------------------------------------]]--

wOS = wOS or {}
wOS.ALCS = wOS.ALCS or {}
wOS.ALCS.ExecSys = wOS.ALCS.ExecSys or {}

local dir = "wos/advswl/execsys"

AddCSLuaFile( dir .. "/core/cl_core.lua" )
AddCSLuaFile( dir .. "/core/cl_player_funcs.lua" )
AddCSLuaFile( dir .. "/core/cl_net.lua" )

wOS.ALCS:ServerInclude( dir .. "/core/sv_core.lua" )
wOS.ALCS:ServerInclude( dir .. "/core/sv_player_funcs.lua" )
wOS.ALCS:ServerInclude( dir .. "/core/sv_net.lua" )
wOS.ALCS:ServerInclude( dir .. "/core/sv_exec_register.lua" )