--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2020
	
	Contact: www.wiltostech.com
		----------------------------------------]]--








































































wOS = wOS or {}
wOS.ALCS = wOS.ALCS or {}

wOS.ALCS.PortalCache = wOS.ALCS.PortalCache or {}

hook.Add( "CalcMainActivity", "wOS.ALCS.ClientAnimations", function( ply, velocity )
	
	if wOS.ALCS.PortalCache[ ply ] then
		wOS.ALCS.PortalCache[ ply ] = nil
		ply.SeqOverride = -1
		ply.SeqOverrideRate = nil
		return
	end
	
	if ply:InVehicle() then return end
	
	local act, seq = hook.Call( "wOS.ALCS.GetSequenceOverride", nil, ply, velocity )
	if act and seq then
		return act, seq
	end
	
	if ply.SeqOverride and ply.SeqOverride >= 0 then 
		return -1, ply.SeqOverride
	end
	
	local wep = ply:GetActiveWeapon()
	if not IsValid( wep ) then return end
	if not wep.IsLightsaber then return end
	
	if wep:GetMeditateMode() == 1 then
        return -1, ply:LookupSequence( "sit_zen" )
    end
	
	if wep:GetMeditateMode() == 2  then
		return -1, ply:LookupSequence( "idle_dual" )
	end
	
	if not wep.GetEnabled then return end
	if not wep:GetEnabled() then return end
	if not wep:GetAnimEnabled() then return end
	
	local len2d = velocity:Length2DSqr()
	local stance = wep:GetStance()
	local form = wOS.Form.LocalizedForms[ wep:GetForm() ]																																																																																
	local seq = ""
	
	if wep:GetDualMode() then
		local formdata = wOS.Form.Duals[ form ][ stance ]
		if ( len2d > 0.25 ) then
			if wep:GetBlocking() then 
				seq = "walk_slam"
			else 
				seq = formdata[ "run" ]
			end
		else
			if wep:GetBlocking() then 
				seq = "judge_b_block"
			else 
				seq = formdata[ "idle" ]
			end
		end	
	else
		local formdata = wOS.Form.Singles[ form ][ stance ]
		if ( len2d > 0.25 ) then
			if wep:GetBlocking() then 
				seq = "walk_melee2"
			else 
				seq = formdata[ "run" ]
			end
		else
			if wep:GetBlocking() then 
				seq = "judge_b_block"
			else 
				seq = formdata[ "idle" ]
			end
		end	
	end
	
	if ply:Crouching() then
		seq = "cwalk_knife"
	end		
	
	if ply:GetNW2Float( "wOS.ForceAnim", 0 ) >= CurTime() then
		seq = "walk_magic"
	end
	
	if not ply:IsOnGround() then 
		seq = "balanced_jump"
	end
	
	seq = ply:LookupSequence( seq )
	
	if seq <= 0 then return end
	
	return -1, seq
	
end )										