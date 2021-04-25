--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2020
	
	Contact: www.wiltostech.com
		
----------------------------------------]]--

wOS = wOS or {}
wOS.ALCS = wOS.ALCS or {}
wOS.ALCS.Dueling = wOS.ALCS.Dueling or {}

local dir = "wos/advswl/dueling"

include( dir .. "/core/cl_core.lua" )
include( dir .. "/core/cl_player_funcs.lua" )
include( dir .. "/core/cl_net.lua" )

include( dir .. "/core/cl_menu_library.lua" )

include( dir .. "/artsys/cl_net.lua" )
