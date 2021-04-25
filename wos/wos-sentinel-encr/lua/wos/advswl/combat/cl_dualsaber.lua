--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2020
	
	Contact: www.wiltostech.com
		----------------------------------------]]--








































































wOS = wOS or {}

hook.Add( "PrePlayerDraw", "wOS.CloakHook", function( ply )
	local wep = ply:GetActiveWeapon()
	if !IsValid( wep ) or !wep.IsLightsaber then 
		if ply.CloakSet then
			ply:SetMaterial( "" )		
			ply.CloakSet = false
		end
		return
	end	
	if not wep:GetCloaking() then 
		if ply.CloakSet then
			ply:SetMaterial( "" )
			ply.CloakSet = false
		end
		return
	end
	ply:SetMaterial("models/shadertest/shader3") 
	ply.CloakSet = true
	if ply:GetVelocity():Length() > 130 then return end
	return true
end )
