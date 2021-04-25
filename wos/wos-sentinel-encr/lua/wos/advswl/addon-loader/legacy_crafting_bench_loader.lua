wOS = wOS or {}
wOS.ALCS = wOS.ALCS or {}
wOS.ALCS.Legacy = wOS.ALCS.Legacy or {}

if SERVER then
	AddCSLuaFile( "wos/advswl/legacy-crafting/wos_craft.lua" )
else
	include( "wos/advswl/legacy-crafting/wos_craft.lua" )
end