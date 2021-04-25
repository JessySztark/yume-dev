
AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.PrintName = "Lightsaber"
ENT.Category = "Robotboy655's Entities"

ENT.Editable = true
ENT.Spawnable = true

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

ENT.CustomSettings = {}

function ENT:SetupDataTables()


	self:NetworkVar( "Float", 0, "BladeLength" )
	self:NetworkVar( "Float", 1, "MaxLength" )
	self:NetworkVar( "Float", 2, "BladeWidth" )
	
	self:NetworkVar( "Bool", 0, "DarkInner" )
	self:NetworkVar( "Bool", 1, "Enabled" )
	
	self:NetworkVar( "Vector", 0, "CrystalColor" )
	self:NetworkVar( "Vector", 1 , "EndPos" )
	self:NetworkVar( "Vector", 2, "InnerColor" )
	
	self:NetworkVar( "String", 0, "WorldModel" )

	self:NetworkVar( "Int", 0, "Stage" )
	if ( SERVER ) then
		self:SetStage( 0 )

		self:SetBladeLength( 0 )
		self:SetBladeWidth( 2 )
		self:SetMaxLength( 42 )
		self:SetInnerColor( Vector( 255, 255, 255 ) )
		self:SetDarkInner( false )
		self:SetEnabled( true )
	end
end

function ENT:Initialize()

	if ( SERVER ) then
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_NONE )

		self.LoopSound = self.LoopSound || "lightsaber/saber_loop" .. math.random( 1, 8 ) .. ".wav"
		self.SwingSound = self.SwingSound || "lightsaber/saber_swing" .. math.random( 1, 2 ) .. ".wav"
		self.OnSound = self.OnSound || "lightsaber/saber_on" .. math.random( 1, 2 ) .. ".wav"
		self.OffSound = self.OffSound || "lightsaber/saber_off" .. math.random( 1, 2 ) .. ".wav"

		if ( self:GetEnabled() ) then self:EmitSound( self.OnSound ) end

		self.SoundSwing = CreateSound( self, Sound( self.SwingSound ) )
		if ( self.SoundSwing ) then self.SoundSwing:Play() self.SoundSwing:ChangeVolume( 0, 0 ) end

		self.SoundHit = CreateSound( self, Sound( "lightsaber/saber_hit.wav" ) )
		if ( self.SoundHit ) then self.SoundHit:Play() self.SoundHit:ChangeVolume( 0, 0 ) end

		self.SoundLoop = CreateSound( self, Sound( self.LoopSound ) )
		if ( self.SoundLoop ) then self.SoundLoop:Play() end

		self:GetPhysicsObject():EnableGravity(false)
		self:GetPhysicsObject():Wake()
	else
		self:SetRenderBounds( Vector( -self:GetBladeLength(), -128, -128 ), Vector( self:GetBladeLength(), 128, 128 ) )

		language.Add( self.ClassName, self.PrintName )
		killicon.AddAlias( "ent_lightsaber", "weapon_lightsaber" )
	end
	self:StartMotionController()
end

function ENT:OnRemove()
	if ( CLIENT ) then rb655_SaberClean_wos( self:EntIndex() ) return end

	if ( self.SoundLoop ) then self.SoundLoop:Stop() self.SoundLoop = nil end
	if ( self.SoundSwing ) then self.SoundSwing:Stop() self.SoundSwing = nil end
	if ( self.SoundHit ) then self.SoundHit:Stop() self.SoundHit = nil end

	if ( self:GetEnabled() ) then self:EmitSound( self.OffSound ) end
end

function ENT:GetSaberPosAng( num, q )
	num = num || 1

	local att = "blade" .. num
	if q then
		att = "quillon" .. num
	end
	local attachment = self:LookupAttachment( att )
	if ( attachment > 0 ) then
		local PosAng = self:GetAttachment( attachment )
		return PosAng.Pos, PosAng.Ang:Forward()
	end

	return self:LocalToWorld( Vector( 1, -0.58, -0.25 ) ), -self:GetAngles():Forward()

end

function ENT:Draw()

	self:DrawModel()

	if ( halo.RenderedEntity && IsValid( halo.RenderedEntity() ) && halo.RenderedEntity() == self ) then return end
	
	local clr = self:GetCrystalColor()
	clr = Color( clr.x, clr.y, clr.z )
	
	local clr_inner = self:GetInnerColor()
	clr_inner = Color( clr_inner.x, clr_inner.y, clr_inner.z )
	
	local poss, dirr = self:GetSaberPosAng()
	rb655_RenderBlade_wos( poss, dirr, self:GetBladeLength(), self:GetMaxLength(), self:GetBladeWidth(), clr, self:GetDarkInner(), clr_inner, self:EntIndex(), false, false, blades, self.CustomSettings )

	for id, t in pairs( self:GetAttachments() ) do
		if ( !string.match( t.name, "blade(%d+)" ) && !string.match( t.name, "quillon(%d+)" ) ) then continue end

		local bladeNum = string.match( t.name, "blade(%d+)" )
		local quillonNum = string.match( t.name, "quillon(%d+)" )
	
		if ( bladeNum && self:LookupAttachment( "blade" .. bladeNum ) > 0 and tonumber( bladeNum ) > 0 ) then
			local pos, dir = self:GetSaberPosAng( bladeNum )
			rb655_RenderBlade_wos( pos, dir, self:GetBladeLength(), self:GetMaxLength(), self:GetBladeWidth(), clr, self:GetDarkInner(), clr_inner, self:EntIndex(), false, false, blades, self.CustomSettings )
		end

		if ( quillonNum && self:LookupAttachment( "quillon" .. quillonNum ) > 0 ) then
			local pos, dir = self:GetSaberPosAng( quillonNum, true )
			rb655_RenderBlade_wos( pos, dir, self:GetBladeLength(), self:GetMaxLength(), self:GetBladeWidth(), clr, self:GetDarkInner(), clr_inner, self:EntIndex(), false, true, blades, self.CustomSettings )
		end
	end
	
end

local params = {}
params.secondstoarrive = 0.0001 --this is probably cheating.
params.dampfactor = 0.9999
params.teleportdistance = 0
params.maxangular = 800000
params.maxangulardamp = 9000
params.maxspeed = 100000
params.maxspeeddamp = params.maxangulardamp

function ENT:PhysicsSimulate( phys, time )

	local ply = self.Owner or self:GetOwner()
	if not IsValid(ply) then return end

	phys:Wake()

	if not self.StartTime then
		self.StartTime = CurTime()
		self.EndTime = CurTime() + 3
	end

	local vec = LerpVector(math.abs((CurTime() - self.StartTime)/(self.EndTime - self.StartTime)),self:GetPos(),self:GetEndPos())
	params.deltatime = time
	local ang = (self:GetEndPos() - vec):Angle()
	ang:RotateAroundAxis(ang:Up(),CurTime() * 720 % 360)
	params.angle = ang
	if ( self:LookupAttachment( "blade2" ) > 0 ) then
		params.pos = vec
	else
		params.pos = vec + ang:Forward() * 40
	end
	phys:ComputeShadowControl(params)
	--return Vector(0,0,0),Vector(0,0,0),SIM_NOTHING
	
end

if ( CLIENT ) then return end

function ENT:OnTakeDamage( dmginfo )

	-- React physically when shot/getting blown
	self:TakePhysicsDamage( dmginfo )

end

function ENT:Think()
	if not IsValid( self:GetOwner() ) then self:Remove() return end
	if not self:GetOwner():Alive() then self:Remove() return end
	local ply = self:GetOwner()
	local wep = ply:GetActiveWeapon()
	if not IsValid( wep ) then self:Remove() return end
	if not wep.IsLightsaber then self:Remove() return end
	if self.EndTime then
		if self.EndTime < CurTime() then 
			ply:DrawWorldModel(true)
			wep:SetNextAttack(0.25)
			wep:SetEnabled(true)
			wep:SetBladeLength(self:GetBladeLength())
			if !( wOS.EnablewiltOSProneMod and ply:IsProne() ) then
				wep:SetEnabled(true)
				wep:SetBladeLength(self:GetBladeLength())
			end	
			self:Remove() 
			return 
		end
	end
	if self:GetPos():DistToSqr(self:GetEndPos()) <= (self:GetStage() == 1 and 75 ^ 2 or 10^2) then
		if self:GetStage() == 0 then
			self:SetStage(1)
			self.EndTime = CurTime() + (CurTime() - self.StartTime)
			self.StartTime = CurTime()
		else
			ply:DrawWorldModel(true)
			wep:SetNextAttack(0.25)
			if !( wOS.EnablewiltOSProneMod and ply:IsProne() ) then
				wep:SetEnabled(true)
				wep:SetBladeLength(self:GetBladeLength())
			end		
			self:Remove()
			return
		end
	else
		wep:SetNextAttack(1)
	end

	if self:GetStage() == 1 then
		self:SetEndPos(wep:GetSaberPosAng() + (wep:GetSaberPosAng() - self:GetPos()):GetNormal() * 20)
	else
		local tr = {}
		tr.start = self:GetPos()
		tr.endpos = tr.start + (self:GetEndPos() - self:GetPos()):GetNormal() * 20
		tr.filter = {self,ply}
		local trace = util.TraceLine(tr)
		if trace.Hit and not (IsValid(trace.Entity) and (trace.Entity:IsNPC() or trace.Entity:IsPlayer())) then
			self:SetStage(1)
			self.EndTime = CurTime() + (CurTime() - self.StartTime)
			self.StartTime = CurTime()
		end
	end
	
	if ( !self:GetEnabled() && self:GetBladeLength() != 0 ) then
		self:SetBladeLength( math.Approach( self:GetBladeLength(), 0, 2 ) )
	elseif ( self:GetEnabled() && self:GetBladeLength() != self:GetMaxLength() ) then
		self:SetBladeLength( math.Approach( self:GetBladeLength(), self:GetMaxLength(), 8 ) )
	end

	if ( self:GetBladeLength() <= 0 ) then
		if ( self.SoundSwing ) then self.SoundSwing:ChangeVolume( 0, 0 ) end
		if ( self.SoundLoop ) then self.SoundLoop:ChangeVolume( 0, 0 ) end
		if ( self.SoundHit ) then self.SoundHit:ChangeVolume( 0, 0 ) end
		return
	end

	local pos, ang = self:GetSaberPosAng()
	local hit = self:BladeThink( pos, ang )
	if ( self:LookupAttachment( "blade2" ) > 0 ) then
		local pos2, ang2 = self:GetSaberPosAng( 2 )
		local hit_2 = self:BladeThink( pos2, ang2 )
		hit = hit || hit_2
	end

	if ( self.SoundHit ) then
		if ( hit ) then self.SoundHit:ChangeVolume( math.Rand( 0.1, 0.5 ), 0 ) else self.SoundHit:ChangeVolume( 0, 0 ) end
	end

	if ( self.SoundSwing ) then
		--local ang = self:GetAngles()
		if ( self.LastAng != ang ) then
			self.LastAng = self.LastAng || ang
			self.SoundSwing:ChangeVolume( math.Clamp( ang:Distance( self.LastAng ) / 2, 0, 1 ), 0 )
			--self.SoundSwing:ChangeVolume( math.Rand( 0, 1 ), 0 ) -- For some reason if I spam always 1, the sound doesn't loop
			--self.SoundSwing:ChangeVolume( math.min( pos:Distance( self.LastPos ) / 16, 1 ), 0 )
		end
		self.LastAng = ang
	end

	if ( self.SoundLoop ) then
		local pos = pos + ang * self:GetBladeLength()
		if ( self.LastPos != pos ) then
			self.LastPos = self.LastPos || pos
			self.SoundLoop:ChangeVolume( 0.1 + math.Clamp( pos:Distance( self.LastPos ) / 32, 0, 0.2 ), 0 )
			--self.SoundLoop:ChangeVolume( 0.1 + math.Clamp( pos:Distance( self.LastPos ) / 32, 0, 0.2 ), 0 )
			--self.SoundLoop:ChangeVolume( 1 - math.min( pos:Distance( self.LastPos ) / 16, 1 ), 0 )
			--self.SoundLoop:ChangeVolume( self:GetBladeLength() / self:GetMaxLength(), 0 )
		end
		self.LastPos = pos
	end

	self:NextThink( CurTime() )
	return true
end

function ENT:DrawHitEffects( trace, traceBack )
	if ( self:GetBladeLength() <= 0 ) then return end

	if ( trace.Hit ) then
		rb655_DrawHit_wos( trace.HitPos, trace.HitNormal )
	end

	if ( traceBack && traceBack.Hit ) then
		rb655_DrawHit_wos( traceBack.HitPos, traceBack.HitNormal )
	end
end

function ENT:BladeThink( startpos, dir )
	--[[local trace = util.TraceHull( {
		start = startpos,
		endpos = startpos + dir * self:GetBladeLength(),
		filter = self,
		/*mins = Vector( -1, -1, -1 ) * self:GetBladeWidth() / 2,
		maxs = Vector( 1, 1, 1 ) * self:GetBladeWidth() / 2*/
	} )

	if ( trace.Hit ) and not (IsValid(trace.Entity) and trace.Entity == self:GetOwner()) then
		rb655_DrawHit_wos( trace.HitPos, trace.HitNormal )
		rb655_LS_DoDamage_wos( trace, self )
	end

	return trace.Hit]]

	-- Up
	local pos, ang = startpos, dir
	local trace = util.TraceHull( {
		start = pos,
		endpos = pos + ang * self:GetBladeLength(),
		filter = { self, self.Owner },
		mins = Vector( -2, -2, -2 ),
		maxs = Vector( 2, 2, 2 )
	} )
	local traceBack = util.TraceHull( {
		start = pos + ang * self:GetBladeLength(),
		endpos = pos,
		filter = { self, self.Owner },
		mins = Vector( -2, -2, -2 ),
		maxs = Vector( 2, 2, 2 )
	} )

	self.LastEndPos = trace.endpos
	if ( SERVER ) then debugoverlay.Line( trace.StartPos, trace.HitPos, .1, Color( 255, 0, 0 ), false ) end

	if ( trace.HitSky || trace.StartSolid ) then trace.Hit = false end
	if ( traceBack.HitSky || traceBack.StartSolid ) then traceBack.Hit = false end

	self:DrawHitEffects( trace, traceBack )
	isTrace1Hit = trace.Hit || traceBack.Hit

	// Don't deal the damage twice to the same entity
	if ( traceBack.Entity == trace.Entity && IsValid( trace.Entity ) ) then traceBack.Hit = false end

	local ent = trace.Hit and IsValid(trace.Entity) and trace.Entity
	if not IsValid(ent) and traceBack.Hit then
		ent = IsValid(traceBack.Entity) and traceBack.Entity
	end
	
	if ( trace.Hit ) then rb655_LS_DoDamage_wos( trace, self ) end
	if ( traceBack.Hit ) then rb655_LS_DoDamage_wos( traceBack, self ) end

	if self.LastEndPos then
		local traceTo = util.TraceHull({
			start = pos + ang * self:GetBladeLength(),
			endpos = self.LastEndPos,
			filter = { self, self.Owner },
			mins = Vector( -2, -2, -2 ),
			maxs = Vector( 2, 2, 2 )
		})

		if ( traceTo.Hit ) and (IsValid(traceTo.Entity) and (not IsValid(ent) or traceTo.Entity != ent)) then 
			rb655_LS_DoDamage_wos( traceTo, self ) 
			ent = traceTo.Entity 
		end

		util.TraceHull({
			start = pos,
			endpos = self.LastEndPos,
			filter = { self, self.Owner },
			mins = Vector( -2, -2, -2 ),
			maxs = Vector( 2, 2, 2 ),
			output = traceTo
		})

		if ( traceTo.Hit ) and (IsValid(traceTo.Entity) and (not IsValid(ent) or traceTo.Entity != ent)) then rb655_LS_DoDamage_wos( traceTo, self ) return true end
	end
	return trace.Hit or traceBack.Hit
end

function ENT:Use( activator, caller, useType, value )
	if ( !IsValid( activator ) || !activator:KeyPressed( IN_USE ) ) then return end

	if ( self:GetEnabled() ) then
		self:EmitSound( self.OffSound )
	else
		self:EmitSound( self.OnSound )
	end

	self:SetEnabled( !self:GetEnabled() )
end

function ENT:SpawnFunction( ply, tr )
	if ( !tr.Hit || !ply:CheckLimit( "ent_lightsabers" ) ) then return end

	local ent = ents.Create( ClassName )
	ent:SetPos( tr.HitPos + tr.HitNormal * 2 )

	local ang = ply:EyeAngles()
	ang.p = 0
	ang:RotateAroundAxis( ang:Right(), 180 )
	ent:SetAngles( ang )

	-- Sync values from the tool
	ent:SetMaxLength( math.Clamp( ply:GetInfoNum( "rb655_lightsaber_bladel", 42 ), 32, 64 ) )
	ent:SetCrystalColor( Vector( ply:GetInfo( "rb655_lightsaber_red" ), ply:GetInfo( "rb655_lightsaber_green" ), ply:GetInfo( "rb655_lightsaber_blue" ) ) / 255 )
	ent:SetDarkInner( ply:GetInfo( "rb655_lightsaber_dark" ) == "1" )
	ent:SetModel( ply:GetInfo( "rb655_lightsaber_model" ) )
	ent:SetBladeWidth( math.Clamp( ply:GetInfoNum( "rb655_lightsaber_bladew", 2 ), 2, 4 ) )

	ent.LoopSound = ply:GetInfo( "rb655_lightsaber_humsound" )
	ent.SwingSound = ply:GetInfo( "rb655_lightsaber_swingsound" )
	ent.OnSound = ply:GetInfo( "rb655_lightsaber_onsound" )
	ent.OffSound = ply:GetInfo( "rb655_lightsaber_offsound" )

	ent:Spawn()
	ent:Activate()

	ent.Owner = ply
	ent.Color = ent:GetColor()

	local phys = ent:GetPhysicsObject()
	if ( IsValid( phys ) ) then phys:Wake() end

	if ( IsValid( ply ) ) then
		ply:AddCount( "ent_lightsabers", ent )
		ply:AddCleanup( "ent_lightsabers", ent )
	end

	return ent
end
