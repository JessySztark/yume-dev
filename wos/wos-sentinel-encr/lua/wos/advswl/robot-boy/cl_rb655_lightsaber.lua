--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2020
	
	Contact: www.wiltostech.com
		----------------------------------------]]--








































































function rb655_DrawHit_wos( pos, dir )
	local effectdata = EffectData()
	effectdata:SetOrigin( pos )
	effectdata:SetNormal( dir )
	util.Effect( "StunstickImpact", effectdata, true, true )

	--util.Decal( "LSScorch", pos + dir, pos - dir )
	util.Decal( "FadingScorch", pos + dir, pos - dir )
end

-- --------------------------------------------------------- Lightsaber blade rendering --------------------------------------------------------- --

local HardLaserTrail = Material( "lightsaber/hard_light_trail" )
local HardLaserTrailInner = Material( "lightsaber/hard_light_trail_inner" )

local HardLaserTrailEnd = Material( "lightsaber/hard_light_trail_end" )
local HardLaserTrailEndInner = Material( "lightsaber/hard_light_trail_end_inner" )

local CorruptedLaser = Material( "effects/stunstick" )
local CorruptedLaserInner = Material( "models/effects/splodearc_sheet" )

--[[local HardLaserTrailEnd = Material( "lightsaber/hard_light_trail" )
local HardLaserTrailEndInner = Material( "lightsaber/hard_light_trail_inner" )]]

local gOldBladePositions_wos = {}
local gOldBladePositions_dual_wos = {}
local gTrailLength = 3

function rb655_RenderBlade_wos( pos, dir, len, maxlen, width, color, black_inner, inner_color, eid, underwater, quillon, bladeNum, settings, dual )
	--render.DrawLine( pos + dir * len*-2, pos + dir * len*2, color, true )
	settings = settings or {}
	quillon = quillon or false
	bladeNum = bladeNum or 1

	if ( quillon ) then
		len = rb655_CalculateQuillonLength_wos( len, maxlen )
		maxlen = rb655_SaberClean_wos( maxlen )
	end

	if ( len <= 0 ) then rb655_SaberClean_wos( eid, bladeNum ) return end

	if ( underwater ) then
		local ed = EffectData()
		ed:SetOrigin( pos )
		ed:SetNormal( dir )
		ed:SetRadius( len )
		util.Effect( "rb655_saber_underwater", ed )
	end
	
	settings.Blade = settings.Blade or "Standard"
	local data = wOS.ALCS.LightsaberBase.Blades[ settings.Blade ]
	
	if settings.Rainbow then
		color = HSVToColor( CurTime() % 6 * 60, 1, 1 )
	end
	
	inner_color = inner_color or color_white
	if ( black_inner ) then inner_color = Color( 0, 0, 0 ) end
	
	if settings.RainbowInner then
		inner_color = HSVToColor( CurTime() % 7.5 * 60, 1, 1 )
	end
	
	if quillon and data.QuillonParticle then
		local ed = EffectData()
		ed:SetOrigin( pos )
		ed:SetNormal( dir )
		ed:SetRadius( len )
		ed:SetAngles( Angle( color.r, color.g, color.b ) )
		util.Effect( data.QuillonParticle, ed )
	else
		if data.UseParticle then
			local ed = EffectData()
			ed:SetOrigin( pos )
			ed:SetNormal( dir )
			ed:SetRadius( len )
			ed:SetAngles( Angle( color.r, color.g, color.b ) )
			util.Effect( data.UseParticle, ed )	
		end
	end

	if quillon and #data.QuillonEnvelopeMaterial > 0 then
		render.SetMaterial( data.QuillonLaser )
		render.DrawBeam( pos, pos + dir * len, width * 1.3, 1, 0.01, color )
	else
		if #data.EnvelopeMaterial > 0 then
			render.SetMaterial( data.Laser )
			render.DrawBeam( pos, pos + dir * len, width * 1.3, 1, 0.01, color )
		end
	end
	
	if quillon and #data.QuillonInnerMaterial > 0 then
		render.SetMaterial( data.QuillonLaserInner )
		render.DrawBeam( pos, pos + dir * len, width * 1.2, 1, 0.01, inner_color )
	else
		if #data.InnerMaterial > 0 then
			render.SetMaterial( data.LaserInner )
			render.DrawBeam( pos, pos + dir * len, width * 1.2, 1, 0.01, inner_color )
		end
	end

	if wOS.ShouldDrawLightsaberLight:GetBool() then
		if ( !quillon ) then
			local SaberLight = DynamicLight( eid + 1000 * bladeNum )
			if ( SaberLight ) then
				SaberLight.Pos = pos + dir * ( len / 2 )
				SaberLight.r = color.r
				SaberLight.g = color.g
				SaberLight.b = color.b
				SaberLight.Brightness = 0.6
				SaberLight.Size = 176 * ( len / maxlen )
				SaberLight.Decay = 0
				SaberLight.DieTime = CurTime() + 0.1
			end
		end
	end

	if not data.DrawTrail or settings.CraftingSaber then return end
	
	local prevB = pos
	local prevT = pos + dir * len
	
	if !dual then
	
		if ( !gOldBladePositions_wos[ eid ] ) then gOldBladePositions_wos[ eid ] = {} end
		if ( !gOldBladePositions_wos[ eid ][ bladeNum ] ) then gOldBladePositions_wos[ eid ][ bladeNum ] = {} end
		for id, prevpos in ipairs( gOldBladePositions_wos[ eid ][ bladeNum ] ) do
			local posB = prevpos.pos
			local posT = prevpos.pos + prevpos.dir * prevpos.len
			--local posB = prevB
			--local posT = prevB + prevpos.dir * prevpos.len

			if ( id == gTrailLength ) then
				HardLaserTrailEnd:SetVector( "$color", Vector( color.r / 255, color.g / 255, color.b / 255 ) )
				render.SetMaterial( HardLaserTrailEnd )
			else
				HardLaserTrail:SetVector( "$color", Vector( color.r / 255, color.g / 255, color.b / 255 ) )
				render.SetMaterial( HardLaserTrail )
			end
			render.DrawQuad( posB, prevB, prevT, posT )

			if ( id == gTrailLength ) then
				HardLaserTrailEndInner:SetVector( "$color", Vector( inner_color.r / 255, inner_color.g / 255, inner_color.b / 255 ) )
				render.SetMaterial( HardLaserTrailEndInner )
			else
				HardLaserTrailInner:SetVector( "$color", Vector( inner_color.r / 255, inner_color.g / 255, inner_color.b / 255 ) )
				render.SetMaterial( HardLaserTrailInner )
			end
			render.DrawQuad( posB, prevB, prevT, posT )

			prevB = prevpos.pos
			prevT = prevpos.pos + prevpos.dir * prevpos.len
			--prevT = prevB + prevpos.dir * prevpos.len
		end
	
	else
	
		if ( !gOldBladePositions_dual_wos[ eid ] ) then gOldBladePositions_dual_wos[ eid ] = {} end
		if ( !gOldBladePositions_dual_wos[ eid ][ bladeNum ] ) then gOldBladePositions_dual_wos[ eid ][ bladeNum ] = {} end
		for id, prevpos in ipairs( gOldBladePositions_dual_wos[ eid ][ bladeNum ] ) do
			local posB = prevpos.pos
			local posT = prevpos.pos + prevpos.dir * prevpos.len
			--local posB = prevB
			--local posT = prevB + prevpos.dir * prevpos.len

			if ( id == gTrailLength ) then
				HardLaserTrailEnd:SetVector( "$color", Vector( color.r / 255, color.g / 255, color.b / 255 ) )
				render.SetMaterial( HardLaserTrailEnd )
			else
				HardLaserTrail:SetVector( "$color", Vector( color.r / 255, color.g / 255, color.b / 255 ) )
				render.SetMaterial( HardLaserTrail )
			end
			render.DrawQuad( posB, prevB, prevT, posT )

			if ( id == gTrailLength ) then
				HardLaserTrailEndInner:SetVector( "$color", Vector( inner_color.r / 255, inner_color.g / 255, inner_color.b / 255 ) )
				render.SetMaterial( HardLaserTrailEndInner )
			else
				HardLaserTrailInner:SetVector( "$color", Vector( inner_color.r / 255, inner_color.g / 255, inner_color.b / 255 ) )
				render.SetMaterial( HardLaserTrailInner )
			end
			render.DrawQuad( posB, prevB, prevT, posT )

			prevB = prevpos.pos
			prevT = prevpos.pos + prevpos.dir * prevpos.len
			--prevT = prevB + prevpos.dir * prevpos.len
		end
	
	end
	
end

function rb655_SaberClean_wos( eid, bladeNum )
	if ( !bladeNum ) then 
		gOldBladePositions_dual_wos[ eid ] = nil
		gOldBladePositions_wos[ eid ] = nil 
		return 
	end
	if ( gOldBladePositions_wos[ eid ] ) then
		gOldBladePositions_wos[ eid ][ bladeNum ] = nil
	end
	if ( gOldBladePositions_dual_wos[ eid ] ) then
		gOldBladePositions_dual_wos[ eid ][ bladeNum ] = nil
	end
end

-- Extremely ugly hack workaround :(
function rb655_ProcessBlade_wos( eid, pos, dir, len, bladeNum, dual )
	
	if !dual then
		if ( !gOldBladePositions_wos[ eid ] ) then gOldBladePositions_wos[ eid ] = {} end
		if ( !gOldBladePositions_wos[ eid ][ bladeNum ] ) then gOldBladePositions_wos[ eid ][ bladeNum ] = {} end
		local hax = gOldBladePositions_wos[ eid ][ bladeNum ]
		for i = 0, gTrailLength - 1 do
			hax[ gTrailLength - i ] = hax[ gTrailLength - i - 1 ]
			if ( gTrailLength - i == 1 ) then
				hax[ 1 ] = { dir = dir, len = len, pos = pos }
			end
		end
	else
		if ( !gOldBladePositions_dual_wos[ eid ] ) then gOldBladePositions_dual_wos[ eid ] = {} end
		if ( !gOldBladePositions_dual_wos[ eid ][ bladeNum ] ) then gOldBladePositions_dual_wos[ eid ][ bladeNum ] = {} end
		local hax = gOldBladePositions_dual_wos[ eid ][ bladeNum ]
		for i = 0, gTrailLength - 1 do
			hax[ gTrailLength - i ] = hax[ gTrailLength - i - 1 ]
			if ( gTrailLength - i == 1 ) then
				hax[ 1 ] = { dir = dir, len = len, pos = pos }
			end
		end	
	end
end

function rb655_CalculateQuillonLength_wos( length, maxLength )
	local len = maxLength/7
	local maxLen = maxLength/7
	return math.Clamp( maxLen - ( maxLength - length ), 0, len )
end

function rb655_ProcessLightsaberEntity_wos( ent )
	
	local bladesFound = false -- true if the model is OLD and does not have blade attachments
	local blades = 0
	for id, t in pairs( ent:GetAttachments() ) do
		if ( !string.match( t.name, "blade(%d+)" ) && !string.match( t.name, "quillon(%d+)" ) ) then continue end

		local bladeNum = string.match( t.name, "blade(%d+)" )
		local quillonNum = string.match( t.name, "quillon(%d+)" )

		if ( bladeNum && ent:LookupAttachment( "blade" .. bladeNum ) > 0 ) then
			blades = blades + 1
			local pos, ang = ent:GetSaberPosAng( bladeNum )
			rb655_ProcessBlade_wos( ent:EntIndex(), pos, ang, ent:GetBladeLength(), blades )
			bladesFound = true
		end

		if ( quillonNum && ent:LookupAttachment( "quillon" .. quillonNum ) > 0 ) then
			blades = blades + 1
			local pos, ang = ent:GetSaberPosAng( quillonNum, true )
			rb655_ProcessBlade_wos( ent:EntIndex(), pos, ang, rb655_CalculateQuillonLength_wos( ent:GetBladeLength(), ent:GetMaxLength() ), blades )
		end
	end

	if ( !bladesFound ) then
		local pos, ang = ent:GetSaberPosAng()
		rb655_ProcessBlade_wos( ent:EntIndex(), pos, ang, ent:GetBladeLength(), 1 )
	end
	
end

function rb655_ProcessLightsaberEntity_dual_wos( ent )

	if not IsValid( ent.LeftHilt ) then return end
	local bladesFound = false -- true if the model is OLD and does not have blade attachments
	local blades = 0
	for id, t in pairs( ent.LeftHilt:GetAttachments() ) do
		if ( !string.match( t.name, "blade(%d+)" ) && !string.match( t.name, "quillon(%d+)" ) ) then continue end

		local bladeNum = string.match( t.name, "blade(%d+)" )
		local quillonNum = string.match( t.name, "quillon(%d+)" )

		if ( bladeNum && ent.LeftHilt:LookupAttachment( "blade" .. bladeNum ) > 0 ) then
			blades = blades + 1
			local pos, ang = ent:GetSaberPosAng( bladeNum, false, ent.LeftHilt )
			rb655_ProcessBlade_wos( ent:EntIndex(), pos, ang, ent:GetSecBladeLength(), blades, true )
			bladesFound = true
		end

		if ( quillonNum && ent.LeftHilt:LookupAttachment( "quillon" .. quillonNum ) > 0 ) then
			blades = blades + 1
			local pos, ang = ent:GetSaberPosAng( quillonNum, true, ent.LeftHilt )
			rb655_ProcessBlade_wos( ent:EntIndex(), pos, ang, rb655_CalculateQuillonLength_wos( ent:GetSecBladeLength(), ent:GetSecMaxLength() ), blades, true )
		end
	end

	if ( !bladesFound ) then
		local pos, ang = ent:GetSaberPosAng( nil, nil, ent.LeftHilt )
		if not ent:GetAnimEnabled() then
			ang = ang*-1
			pos = pos + ang*12 - ang:Angle():Right()*0.8 - ang:Angle():Up()*1.5
		end
		rb655_ProcessBlade_wos( ent:EntIndex(), pos, ang, ent:GetSecBladeLength(), 1, true )
	end
	
end

hook.Add( "Think", "rb655_lightsaber_ugly_fixes_wOS", function()

	if not wOS.Lightsabers then return end
	if not wOS.Lightsabers.General then return end

	for class, _ in pairs( wOS.Lightsabers.General ) do
		for id, ent in pairs( ents.FindByClass( class ) ) do
			if ( !IsValid( ent:GetOwner() ) || ent:GetOwner():GetActiveWeapon() != ent || !ent.GetBladeLength || ent:GetBladeLength() <= 0 ) then continue end

			rb655_ProcessLightsaberEntity_wos( ent )
			if ent:GetDualMode() then
				rb655_ProcessLightsaberEntity_dual_wos( ent )
			end
		end
	end

	for id, ent in pairs( ents.FindByClass( "ent_lightsaber*" ) ) do
		if ( !ent.GetBladeLength || ent:GetBladeLength() <= 0 ) then continue end
		rb655_ProcessLightsaberEntity_wos( ent, ent.LeftHilt )
	end
	
end )

hook.Add( "InitPostEntity", "wOS.RemoveRobotBoyHolster!", function()
	hook.Remove( "PostPlayerDraw", "rb655_lightsaber" )
end )