--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2020
	
	Contact: www.wiltostech.com
		
----------------------------------------]]--

wOS = wOS or {}
wOS.ALCS = wOS.ALCS or {}
wOS.ALCS.Config = wOS.ALCS.Config or {}

local dir = "wos/advswl/config"

//General Config
include( dir .. "/general/sh_serverwos.lua" )
include( dir .. "/general/sh_swlwos.lua" )

//Lightsaber Config
include( dir .. "/lightsaber/cl_config.lua" )

//Skills Config
include( dir .. "/skills/sh_skillwos.lua" )

//Prestige Config
include( dir .. "/prestige/sh_config.lua" )

//Crafting Config
include( dir .. "/crafting/sh_craftwos.lua" )

//Storage Config
include( dir .. "/storage/sh_config.lua" )

//Trade Config
include( dir .. "/trade/sh_config.lua" )

//Dueling Config
include( dir .. "/dueling/sh_config.lua" )