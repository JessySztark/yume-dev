--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2020
	
	Contact: www.wiltostech.com
		----------------------------------------]]--








































































wOS = wOS or {}

local meta = FindMetaTable("Player")

hook.Add( "UpdateAnimation", "wOS.SharedAnimations", function( ply, velocity, maxseqgroundspeed )

	local wep = ply:GetActiveWeapon()
	if not IsValid( wep ) then return end
	if not wep.IsLightsaber then return end

	local len = velocity:Length()
	local movement = 1.0

	if ( len > 0.2 ) then
		movement = ( len / maxseqgroundspeed )
	end

	local rate = math.min( movement, 1 )
	-- if we're under water we want to constantly be swimming..
	if ( ply:WaterLevel() >= 2 ) then
		rate = math.max( rate, 0.5 )
	elseif ( !ply:IsOnGround() && len >= 1000 ) then
		rate = 0.1
	end
	
	ply:SetPlaybackRate( ply.SeqOverrideRate or rate )
	return true
	
end )