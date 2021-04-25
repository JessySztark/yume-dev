--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2020
	
	Contact: www.wiltostech.com
		
----------------------------------------]]--

wOS = wOS or {}
wOS.ALCS = wOS.ALCS or {}
wOS.ALCS.Config = wOS.ALCS.Config or {}

local dir = "wos/advswl/config"

//General Config
AddCSLuaFile( dir .. "/general/sh_serverwos.lua" )
AddCSLuaFile( dir .. "/general/sh_swlwos.lua" )
include( dir .. "/general/sh_serverwos.lua" )
include( dir .. "/general/sh_swlwos.lua" )
include( dir .. "/general/sv_adminsettings.lua" )

//Lightsaber Config
AddCSLuaFile( dir .. "/lightsaber/cl_config.lua" )
include( dir .. "/lightsaber/cl_config.lua" )
include( dir .. "/lightsaber/sv_config.lua" )

//Character Config
include( dir .. "/character/sv_config.lua" )

//Skills Config
AddCSLuaFile( dir .. "/skills/sh_skillwos.lua" )
include( dir .. "/skills/sh_skillwos.lua" )
include( dir .. "/skills/sv_skillwos.lua" )

//Prestige Config
AddCSLuaFile( dir .. "/prestige/sh_config.lua" )
include( dir .. "/prestige/sh_config.lua" )
include( dir .. "/prestige/sv_config.lua" )

//Crafting Config
AddCSLuaFile( dir .. "/crafting/sh_craftwos.lua" )
include( dir .. "/crafting/sh_craftwos.lua" )
include( dir .. "/crafting/sv_craftwos.lua" )

//Storage Config
AddCSLuaFile( dir .. "/storage/sh_config.lua" )
include( dir .. "/storage/sh_config.lua" )
include( dir .. "/storage/sv_config.lua" )

//Trade Config
AddCSLuaFile( dir .. "/trade/sh_config.lua" )
include( dir .. "/trade/sh_config.lua" )
include( dir .. "/trade/sv_config.lua" )

//Dueling Config
AddCSLuaFile( dir .. "/dueling/sh_config.lua" )
include( dir .. "/dueling/sh_config.lua" )
include( dir .. "/dueling/sv_config.lua" )

//Executions Config
include( dir .. "/executions/sv_config.lua" )