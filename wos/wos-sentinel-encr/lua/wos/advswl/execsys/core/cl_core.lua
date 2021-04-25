--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2020
	
	Contact: www.wiltostech.com
		----------------------------------------]]--








































































wOS = wOS or {}
wOS.ALCS = wOS.ALCS or {}
wOS.ALCS.ExecSys = wOS.ALCS.ExecSys or {}
wOS.ALCS.ExecSys.Executions = wOS.ALCS.ExecSys.Executions or {}

wOS.ALCS.ExecSys.SmallGibTable = {
"models/gibs/HGIBS_scapula.mdl",
"models/props_phx/misc/potato.mdl",
"models/gibs/antlion_gib_small_1.mdl",
"models/gibs/antlion_gib_small_2.mdl",
"models/gibs/shield_scanner_gib1.mdl",
"models/props_wasteland/prison_sinkchunk001h.mdl",
"models/props_wasteland/prison_toiletchunk01f.mdl",
"models/props_wasteland/prison_toiletchunk01i.mdl",
"models/props_wasteland/prison_toiletchunk01l.mdl",
"models/props_combine/breenbust_chunk02.mdl",
"models/props_combine/breenbust_chunk04.mdl",
"models/props_combine/breenbust_chunk05.mdl",
"models/props_combine/breenbust_chunk06.mdl",
"models/props_combine/breenbust_chunk07.mdl",
"models/props_junk/watermelon01_chunk02a.mdl",
"models/props_junk/watermelon01_chunk02b.mdl",
"models/props_junk/watermelon01_chunk02c.mdl",
}
wOS.ALCS.ExecSys.BigGibTable = {
"models/gibs/HGIBS.mdl",
"models/gibs/HGIBS_spine.mdl",
"models/weapons/w_bugbait.mdl",
"models/gibs/antlion_gib_medium_1.mdl",
"models/gibs/antlion_gib_medium_2.mdl",
"models/gibs/shield_scanner_gib5.mdl",
"models/gibs/shield_scanner_gib6.mdl",
"models/props_junk/shoe001a.mdl",
"models/props_junk/Rock001a.mdl",
"models/props_junk/garbage_bag001a.mdl",
"models/props_debris/concrete_spawnchunk001g.mdl",
"models/props_combine/breenbust_chunk03.mdl",
"models/props_wasteland/prison_sinkchunk001c.mdl",
"models/props_wasteland/prison_toiletchunk01j.mdl",
"models/props_wasteland/prison_toiletchunk01k.mdl",
"models/props_junk/watermelon01_chunk01b.mdl",
"models/props_junk/watermelon01_chunk01c.mdl", 
}

wOS.ALCS.ExecSys.SplatSounds = { 
"physics/flesh/flesh_squishy_impact_hard1.wav",
"physics/flesh/flesh_squishy_impact_hard2.wav",
"physics/flesh/flesh_squishy_impact_hard3.wav",
"physics/flesh/flesh_squishy_impact_hard4.wav",
"physics/flesh/flesh_bloody_impact_hard1.wav",
"physics/body/body_medium_break2.wav",
"physics/body/body_medium_break3.wav",
"physics/body/body_medium_break4.wav",
"ambient/levels/canals/toxic_slime_sizzle1.wav",
"ambient/levels/canals/toxic_slime_sizzle2.wav",
"ambient/levels/canals/toxic_slime_gurgle3.wav",
"ambient/levels/canals/toxic_slime_gurgle5.wav",
"ambient/levels/canals/toxic_slime_gurgle8.wav"
}

wOS.ALCS.ExecSys.LastPos = nil
wOS.ALCS.ExecSys.LastAng = nil

function wOS.ALCS.ExecSys:CanUseExecution( exec )
	if not exec then return false end
	if not wOS.ALCS.ExecSys.Executions[ exec ] then return false end
	if not wOS.ALCS.Dueling.DuelData then return false end
	local dat = wOS.ALCS.ExecSys.Executions[ exec ]
	if wOS.ALCS.ExecSys.Whitelists and wOS.ALCS.ExecSys.Whitelists[ exec ] then return true end
	if dat.Milestone then
		local wins = wOS.ALCS.Dueling.DuelData.Wins or 0
		local losses = wOS.ALCS.Dueling.DuelData.Losses or 0
		local total = wins + losses
		if dat.Milestone.Wins and dat.Milestone.Wins > wins then return false end
		if dat.Milestone.Losses and dat.Milestone.Losses > losses then return false end		
		if dat.Milestone.Total and dat.Milestone.Total > total then return false end		
	end
	
	return true
end

hook.Add( "wOS.ALCS.ShouldDisableCam", "wOS.ALCS.Executions.DisableCam", function()  

	if LocalPlayer():GetExecuted() then return true end

end )

hook.Add( "FinishMove", "wOS.ALCS.Executions.StopMove", function( ply, mv ) 
	if !ply:GetExecuted() then return end
	mv:SetForwardSpeed( 0.1 )
	mv:SetSideSpeed( 0.1 )
	mv:SetUpSpeed( 0.1 )
	return true
end )

hook.Add( "CalcView", "wOS.ALCS.Executions.FinishHim", function( ply, pos, ang )

	if !LocalPlayer():GetExecuted() then return end
	local dat = wOS.ALCS.ExecSys.ExecutionData
	if not dat then return end
	if dat.endtime < CurTime() then return end
	if dat.stagetime < CurTime() then
		if dat.camdata[ dat.stage + 1 ] then
			dat.stagetime = CurTime() + dat.camdata[ dat.stage + 1 ].time
			dat.stage = dat.stage + 1
			return
		end
	end
	
	if not wOS.ALCS.ExecSys.LastPos or not wOS.ALCS.ExecSys.LastAng then
		wOS.ALCS.ExecSys.LastPos = pos
		wOS.ALCS.ExecSys.LastAng = ang
	end

	local npos, nang = vector_origin, Angle( 0, 0, 0 )
	if dat.camdata.target != WOS_ALCS.EXECUTE.NO_TARGET then
		local target = ( dat.camdata.target == WOS_ALCS.EXECUTE.VICTIM and dat.victim ) or dat.attacker
		local angles = target:GetAngles()
		angles.p = 0
		angles.r = 0
		local offset = dat.camdata[ dat.stage ].OffsetPos
		npos = target:GetPos() + angles:Right()*offset.x + angles:Forward()*offset.y + angles:Up()*offset.z
		nang = angles + dat.camdata[ dat.stage ].OffsetAng
	else
		npos = dat.camdata[ dat.stage ].OffsetPos
		nang = dat.camdata[ dat.stage ].OffsetAng
		wOS.ALCS.ExecSys.LastPos = npos
		wOS.ALCS.ExecSys.LastAng = nang
	end
	
	
	wOS.ALCS.ExecSys.LastPos = ( wOS.ALCS.ExecSys.LastPos == npos and npos ) or Lerp( FrameTime()*3, wOS.ALCS.ExecSys.LastPos, npos )
	wOS.ALCS.ExecSys.LastAng = ( wOS.ALCS.ExecSys.LastAng == nang and nang ) or Lerp( FrameTime()*3, wOS.ALCS.ExecSys.LastAng, nang )	
	 
	return {
		origin = wOS.ALCS.ExecSys.LastPos,
		angles = wOS.ALCS.ExecSys.LastAng,
		drawviewer = true
	}
	
end )

hook.Add( "StartCommand", "wOS.ALCS.Executions.StopAll", function( ply, cmd )
	if !ply:GetExecuted() then return end

	cmd:ClearButtons()
	cmd:ClearMovement()
	
end )

hook.Add( "InputMouseApply", "wOS.ALCS.Executions.StopTurning", function( cmd )
	if !LocalPlayer():GetExecuted() then return end
	
	cmd:SetMouseX( 0 )
	cmd:SetMouseY( 0 )
	cmd:SetMouseWheel( 0 )

	return true
end )