--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2020
	
	Contact: www.wiltostech.com
		
----------------------------------------]]--

wOS = wOS or {}
wOS.ALCS = wOS.ALCS or {}
wOS.ALCS.Dueling = wOS.ALCS.Dueling or {}

local dir = "wos/advswl/dueling"

AddCSLuaFile( dir .. "/core/cl_core.lua" )
AddCSLuaFile( dir .. "/core/cl_player_funcs.lua" )
AddCSLuaFile( dir .. "/core/cl_net.lua" )
AddCSLuaFile( dir .. "/core/cl_menu_library.lua" )

AddCSLuaFile( dir .. "/artsys/cl_net.lua" )

if wOS.ALCS.Config.Dueling.ShouldUseMySQL then
	include( dir .. "/wrappers/sv_mysql.lua" )
else
	include( dir .. "/wrappers/sv_data.lua" )
end

wOS.ALCS:ServerInclude( dir .. "/core/sv_core.lua" )
wOS.ALCS:ServerInclude( dir .. "/core/sv_concommands.lua" )
wOS.ALCS:ServerInclude( dir .. "/core/sv_player_funcs.lua" )
wOS.ALCS:ServerInclude( dir .. "/core/sv_net.lua" )
wOS.ALCS:ServerInclude( dir .. "/core/sv_spirit_register.lua" )


wOS.ALCS:ServerInclude( dir .. "/artsys/sv_core.lua" )
wOS.ALCS:ServerInclude( dir .. "/artsys/sv_net.lua" )
wOS.ALCS:ServerInclude( dir .. "/artsys/sv_artifact_register.lua" )
