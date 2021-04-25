--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2020
	
	Contact: www.wiltostech.com
		----------------------------------------]]--








































































local bonesToRemove = { 
			"ValveBiped.Bip01_Head1",
			"ValveBiped.Bip01_Neck1",
			"ValveBiped.Bip01_Spine4",
			"ValveBiped.Bip01_Spine2",
			"ValveBiped.Bip01_Pelvis",
}

hook.Add( "PostPlayerDraw", "wOS.FirstPersonRemoveHead", function( ply )
	if ply != LocalPlayer() then return end
	local wep = ply:GetActiveWeapon()
	if !IsValid( wep ) or !wep.IsLightsaber or !wep.FirstPerson then 
		if wOS.FixFirstPerson then
			for _, v in pairs( ply.BoneIDTable ) do -- Loop through desired bones
				ply:ManipulateBoneScale( v, Vector( 1, 1, 1 ) )
			end
			wOS.FixFirstPerson = false
		end
		return 
	end	
	if !wOS.FixFirstPerson then
		ply.BoneIDTable = {}
		for k, v in pairs( bonesToRemove ) do -- Loop through desired bones
			local id = ply:LookupBone( v )
			if id then
				if k <= 3 then
					ply:ManipulateBoneScale( id, vector_origin )
				else
					ply:ManipulateBoneScale( id, Vector( 0.75, 0.75, 0.75 ) )			
				end
				ply.BoneIDTable[ #ply.BoneIDTable + 1 ] = id			
			end
		end	
		wOS.FixFirstPerson = true	
	end
	for k, v in pairs( ply.BoneIDTable ) do -- Loop through desired bones
		if k <= 3 then
			ply:ManipulateBoneScale( v, vector_origin )
		else
			ply:ManipulateBoneScale( v, Vector( 0.75, 0.75, 0.75 ) )			
		end
	end	
end )

local DCalledTime = 0

hook.Add( "CalcView", "wOS.CameraModeHooks", function( ply, pos, ang )
	if ( !IsValid( ply ) or !ply:Alive() or ply:InVehicle() or ply:GetViewEntity() != ply ) then return end
	local wep = LocalPlayer():GetActiveWeapon()
	if ( !IsValid( wep ) or !wep.IsLightsaber ) then return end
	if wOS.ALCS:ShouldDisableCam() then return end
	if wep.FirstPerson then 
		local eyes = ply:GetAttachment( ply:LookupAttachment( "eyes" ) );
		local angs = ang
		
		if wep.FirstPerson && ( wep:GetFPCamTime() >= CurTime() or wOS.ALCS.Config.AlwaysFirstPerson ) then
			angs = eyes.Ang
		end

		return {
			origin = eyes.Pos + Vector( 0, 0, 1.5 ),
			angles = angs,
			fov = 100, 
			drawviewer = true
		}
	elseif LocalPlayer():GetNW2Float( "wOS.DevestatorTime", 0 ) >= CurTime() then
		local dtime = LocalPlayer():GetNW2Float( "wOS.DevestatorTime", 0 )
		if !LocalPlayer().LastDevestator or LocalPlayer().LastDevestator < CurTime() then
			LocalPlayer().LastDevestator = dtime + 0.2
			DCalledtime = CurTime()
		end
		local tendpos = LocalPlayer():EyePos() + Vector( math.cos( 4.7*( DCalledtime - CurTime() ) ), math.sin( 4.7*( DCalledtime - CurTime() ) ), 0 )*150

		--if DCalledtime + 2 <= CurTime() then
			--tendpos = pos + ply:GetForward()*150 
		--end
		
		local trace = util.TraceHull( {
			start = pos,
			endpos = tendpos,
			filter = { ply:GetActiveWeapon(), ply },
			mins = Vector( -4, -4, -4 ),
			maxs = Vector( 4, 4, 4 ),
		} )
		
		if ( trace.Hit ) then pos = trace.HitPos else pos = tendpos end

		ang = ( LocalPlayer():EyePos() - pos ):Angle()
		
		return {
			origin = pos,
			angles = ang,
			drawviewer = true
		}	
	else
		local trace = util.TraceHull( {
			start = pos,
			endpos = pos - ang:Forward() * 100,
			filter = { ply:GetActiveWeapon(), ply },
			mins = Vector( -4, -4, -4 ),
			maxs = Vector( 4, 4, 4 ),
		} )

		if ( trace.Hit ) then pos = trace.HitPos else pos = pos - ang:Forward() * 100 end
		

		return {
			origin = pos,
			angles = ang,
			drawviewer = true
		}
	end
end )

hook.Add( "CreateMove", "rb655_lightsaber_no_fall_damage_wos", function( cmd/* ply, mv, cmd*/ )
	local wep = LocalPlayer():GetActiveWeapon()
	if not wep.IsLightsaber then return end
	if ( CurTime() - wep:GetAttackDelay() < 0.25 ) then
		cmd:ClearButtons() -- No attacking, we are busy
		cmd:ClearMovement() -- No moving, we are busy
	end
end )

local lastheld = 0
hook.Add( "PlayerBindPress", "rb655_sabers_force_wos", function( ply, bind, pressed )
	local wep = LocalPlayer():GetActiveWeapon()
	if ( LocalPlayer():InVehicle() || ply != LocalPlayer() || !LocalPlayer():Alive() || !IsValid( wep ) || !wep.IsLightsaber ) then return end
	if ( bind == "impulse 100" && pressed ) then
		if wOS.ALCS.Config.LightsaberHUD == WOS_ALCS.HUD.FORCEMENU then
			wOS.ALCS:OpenForceMenu()
			return true
		elseif wOS.ALCS.Config.LightsaberHUD == WOS_ALCS.HUD.HYBRID and ply:KeyDown( IN_WALK ) then
			wOS.ALCS:OpenDraggableForceMenu()
			return true
		end
		wep.ForceSelectEnabled = !wep.ForceSelectEnabled
		return true
	end
	if ( !wep.ForceSelectEnabled ) then return end

	if ( bind:StartWith( "slot" ) ) then
		RunConsoleCommand( "rb655_select_force_wos", bind:sub( 5 ) )
		return true
	end
end )

hook.Add( "PreDrawHalos", "wOS.ForceHolograms", function()

	local reflectors = {}
	local ragers = {}	
	local channelers = {}

	for _,ply in pairs( player.GetAll() ) do
		if not IsValid( ply ) then continue end
		if not ply:Alive() then continue end
		if ply:GetNW2Float( "ReflectTime", 0 ) >= CurTime() then
			table.insert( reflectors, ply )
		end
		if ply:GetNW2Float( "RageTime", 0 ) >= CurTime() then
			table.insert( ragers, ply )
		end
		if ply:GetNW2Bool( "wOS.IsChanneling", false ) then
			table.insert( channelers, ply )
		end
	end

	if #reflectors > 0 then
		halo.Add( reflectors, Color( 0, 0, 255, 175 ), 5, 5, 3, true, false )
	end
	
	if #ragers > 0 then
		halo.Add( ragers, Color( 255, 0, 0, 175 ), 5, 5, 3, true, false )
	end
	
	if #channelers > 0 then
		halo.Add( channelers, Color( 255, 0, 0, 175 ), 10 + math.max( 0, math.sin( 1.5*CurTime() ) )*10, 10 + math.max( 0, math.sin( 1.5*CurTime() ) )*10, 3, true, false )
	end
	
end )

hook.Add( "PostPlayerDraw", "wOS.Lightsaber.HolsterDrawing", function( ply )
	if ( !GetGlobalBool( "rb655_lightsaber_hiltonbelt", false ) ) then return end
	if ( !ply.LightsaberMDL ) then
		ply.LightsaberMDL = {}
	end
	if ply:GetNW2Float( "CloakTime", 0 ) >= CurTime() then return end
	
	local pi = -30
	local radian = 0
	
	for class, _ in pairs( wOS.Lightsabers.General ) do
		local wep = ply:GetWeapon( class )
		if ( !IsValid( wep ) || wep == ply:GetActiveWeapon() ) then continue end
		if not wep.WorldModel then continue end
		if ( !ply.LightsaberMDL[ class ] ) then
			ply.LightsaberMDL[ class ] = ClientsideModel( wep.WorldModel, RENDERGROUP_BOTH ) -- wep.WorldModel is nil?
			ply.LightsaberMDL[ class ]:SetNoDraw( true )
		end
		ply.LightsaberMDL[ class ]:SetModel( wep.WorldModel )

		local bone = ply:LookupBone( "ValveBiped.Bip01_Pelvis" )
		local spin = false

		if !bone then
			bone = ply:LookupBone( "ValveBiped.Bip01_Spine" )
			spin = true
		end
		if not bone then return end
		local pos, ang = ply:GetBonePosition( bone )
		local att = pi*radian
		if spin then 
			ang:RotateAroundAxis( ang:Forward(), 220 + att )
		else
			ang:RotateAroundAxis( ang:Up(), 90 )
			ang:RotateAroundAxis( ang:Forward(), att )
		end
		pos = pos - ang:Right() * 8 - ang:Forward() * 8
		if spin then
			pos = pos + ang:Up()*6 - ang:Forward()*5 + ang:Right()*5
		end
		if ( wep.WorldModel == "models/weapons/starwars/w_maul_saber_staff_hilt.mdl" ) then
			pos = pos - ang:Forward() * 1
		end
		if ( wep.WorldModel == "models/weapons/starwars/w_kr_hilt.mdl" ) then
			pos = pos + ang:Forward() * 5
		end

		ang:RotateAroundAxis( ang:Forward(), 90 )

		ply.LightsaberMDL[ class ]:SetPos( pos )
		ply.LightsaberMDL[ class ]:SetAngles( ang )

		ply.LightsaberMDL[ class ]:DrawModel()
		radian = radian + 1
	end

end )

hook.Add( "PlayerDeath", "wOS.HiltGarbageCleanup", function( ply )
	if not ply.LightsaberMDL then return end
	for class, model in pairs( ply.LightsaberMDL ) do
		model:Remove()
		ply.LightsaberMDL[ class ] = nil
	end
end )

local ColorModify = {}
ColorModify[ "$pp_colour_addr" ] 		= 0
ColorModify[ "$pp_colour_addg" ] 		= 0
ColorModify[ "$pp_colour_addb" ] 		= 0
ColorModify[ "$pp_colour_brightness" ] 	= 0
ColorModify[ "$pp_colour_contrast" ] 	= 1
ColorModify[ "$pp_colour_colour" ] 		= 1
ColorModify[ "$pp_colour_mulr" ] 		= 0
ColorModify[ "$pp_colour_mulg" ] 		= 0
ColorModify[ "$pp_colour_mulb" ] 		= 0

hook.Add( "RenderScreenspaceEffects", "wOS.DisorientForEmerald", function()
	if LocalPlayer():GetNW2Float( "wOS.SonicTime", 0 ) < CurTime() then return end
	
	ColorModify[ "$pp_colour_brightness" ] 	= -0.4*math.cos( CurTime()*3 )
	ColorModify[ "$pp_colour_contrast" ] 	= 3*math.sin( CurTime()*3 )
	
	DrawMotionBlur( 0.05, 1.0, 0.0 )	
	DrawColorModify( ColorModify )
	
end )