
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )


function ENT:Initialize()

	self.Entity:SetMoveType( MOVETYPE_NONE )
	self.Entity:SetSolid( SOLID_NONE )
	
	self.BuildingSound = CreateSound( self.Entity, "ambient/atmosphere/ambience5.wav" )
	self.BuildingSound:Play()	
	
	self.Entity:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
	self.Entity:SetTrigger( true )
	self.Entity:SetNotSolid( true )
	self.Entity:DrawShadow( false )	
	
	self.Entity:SetCustomCollisionCheck( true )
	self.Entity:Activate()
	
	local length = 750
	local width = 750
	local height = 750
	self.Radius = math.sqrt( length^2 + width^2 )
	self.LifeSpan = CurTime() + 3.7
	
	local maxref = Vector( length/2, width/2, height/2 )
	local minref = Vector( length/-2, width/-2, height/-2 )
	
	self.Entity:SetCollisionBounds( minref, maxref )
	self.Entity:PhysicsInitBox( minref, maxref )
	
end

function ENT:Think()

	-- THIS ONE IS GOOD ParticleEffect("hpw_protego_main", self.Entity:GetPos(), Angle(90, 0, 0))
	-- GOES WITH ABOVE ParticleEffect("hpw_protego_impact", self.Entity:GetPos(), Angle(90, 0, 0))		
	
	if !self.Owner then self:Remove() return end
	if !self.Owner:Alive() then self:Remove() return end
	
	
	if self.LifeSpan < CurTime() then
	
		self.Entity:Remove()
	
	end

	self.Owner:SetMoveType( MOVETYPE_NONE )
	
	local ed = EffectData()
	ed:SetOrigin( self.Owner:GetPos() + Vector( 0, 0, 36 ) )
	ed:SetRadius( self.Radius/4 )
	util.Effect( "rb655_force_repulse_out", ed, true, true )
	
end

function ENT:Touch( ent ) 

	if ent == self:GetOwner() then return end
	
	local v = ( self.Owner:GetPos() - ent:GetPos() ):GetNormalized()
	v.z = 0

	if ( ent:IsPlayer() && ent:IsOnGround() ) then
		ent:SetVelocity( v * -2048 + Vector( 0, 0, 64 ) )
	elseif ( ent:IsPlayer() && !ent:IsOnGround() ) then
		ent:SetVelocity( v * -384 + Vector( 0, 0, 64 ) )
	end
	
	ent:SetNW2Float( "wOS.SonicTime", CurTime() + 4 )
	
end 

function ENT:OnRemove()
	if self.BuildingSound then
		self.BuildingSound:Stop()
		self.BuildingSound = nil	
	end
	
	if !self.Owner then return end
	if !self.Owner:Alive() then return end
	
	self.Owner:SetSequenceOverride()	
	self.Owner:SetMoveType( MOVETYPE_WALK )
	
end


