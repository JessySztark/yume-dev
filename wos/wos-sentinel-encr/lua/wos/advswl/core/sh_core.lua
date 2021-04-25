--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2020
	
	Contact: www.wiltostech.com
		----------------------------------------]]--








































































wOS = wOS or {}
wOS.ALCS = wOS.ALCS or {}
																					
PrecacheParticleSystem("har_explosion_a")
PrecacheParticleSystem("har_explosion_b")
PrecacheParticleSystem("har_explosion_c")
PrecacheParticleSystem("har_explosion_a_air")
PrecacheParticleSystem("har_explosion_b_air")
PrecacheParticleSystem("har_explosion_c_air")

if CLIENT then
	game.AddParticles( "particles/harry_explosion.pcf" )
end