--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2020
	
	Contact: www.wiltostech.com
		----------------------------------------]]--








































































wOS = wOS or {}
wOS.ALCS = wOS.ALCS or {}
wOS.ALCS.LightsaberBase = wOS.ALCS.LightsaberBase or {}
wOS.ALCS.LightsaberBase.HUDS = wOS.ALCS.LightsaberBase.HUDS or {}

function wOS.ALCS.LightsaberBase:RegisterNewHUD( HUD, name )
	if not HUD then return end
	if not name then return end
	wOS.ALCS.LightsaberBase.HUDS[ name ] = HUD
end

function wOS.ALCS.LightsaberBase:AddClientWeapon( SWEP, name )
	if not SWEP then return end
	if not name then return end
	weapons.Register( SWEP, name )
end