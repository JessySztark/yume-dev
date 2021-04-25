--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2020
	
	Contact: www.wiltostech.com
		
----------------------------------------]]--

wOS = wOS or {}
wOS.ALCS = wOS.ALCS or {}
wOS.ALCS.Combat = wOS.ALCS.Combat or {}

local dir = "wos/advswl/character"

AddCSLuaFile( dir .. "/core/cl_net.lua" )
AddCSLuaFile( dir .. "/core/cl_menu_library.lua" )


if wOS.ALCS.Config.Character.ShouldUseMySQL then
	include( dir .. "/wrappers/sv_mysql.lua" )
else
	include( dir .. "/wrappers/sv_data.lua" )
end

wOS.ALCS:ServerInclude( dir .. "/core/sv_core.lua" )
wOS.ALCS:ServerInclude( dir .. "/core/sv_net.lua" )