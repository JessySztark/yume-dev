
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )


function ENT:Initialize()

	self.Entity:SetMoveType( MOVETYPE_NONE )
	self.Entity:SetSolid( SOLID_OBB )
	
	self.BuildingSound = CreateSound( self.Entity, "ambient/levels/citadel/portal_beam_loop1.wav" )
	self.BuildingSound:Play()	
	
	self.Entity:SetCollisionGroup( COLLISION_GROUP_BREAKABLE_GLASS )
	self.Entity:SetTrigger( true )
	self.Entity:SetNotSolid( true )
	self.Entity:DrawShadow( false )	
	
	self.Entity:Activate()
	
	local length = 750
	local width = 750
	local height = 750
	self.Radius = math.sqrt( length^2 + width^2 )
	self.LifeSpan = CurTime() + 3.5
	
	local maxref = Vector( length/2, width/2, height/2 )
	local minref = Vector( length/-2, width/-2, height/-2 )
	
	self.Entity:SetCollisionBounds( minref, maxref )
	
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
	
	local effectdata = EffectData()
	effectdata:SetEntity(self.Owner)
	effectdata:SetRadius( self.Radius ) 
	effectdata:SetMagnitude(5)
	effectdata:SetScale(20)
	util.Effect("TeslaHitBoxes", effectdata)
	
	local pos = self.Owner:GetPos() + Vector( 0, 0, 25 ) 
	local effect = EffectData()
	effect:SetStart( pos )
	effect:SetOrigin( pos )
	effect:SetScale( 100 )
	util.Effect("cball_explode", effect, true, true)
	
end

function ENT:Touch( ent ) 

	local interval = self.LifeSpan - CurTime()
	interval = math.Round( ( interval%0.5 )*10 )
	if interval > 0 then return end
	
	if ent == self:GetOwner() then return end
	if !ent:IsPlayer() and !ent:IsNPC() and !ent:IsNextBot() then return end
	
	local ed = EffectData()
	ed:SetOrigin( self.Owner:GetActiveWeapon():GetSaberPosAng() )
	ed:SetEntity( ent )
	util.Effect( "wos_tesla_coil_lightning", ed, true, true )

	local dmginfo = DamageInfo()
	dmginfo:SetAttacker( self.Owner )
	dmginfo:SetInflictor( self.Owner:GetActiveWeapon() )
	dmginfo:SetDamage( 30 )
	dmginfo:SetDamageType( DMG_SHOCK )
	ent:TakeDamageInfo( dmginfo )
	
	local chance = math.random( 100 )
	if chance < 10 then
		local effectdata = EffectData()
		effectdata:SetEntity(ent)
		effectdata:SetRadius(3) 
		effectdata:SetMagnitude(2)
		effectdata:SetScale(1)
		util.Effect("TeslaHitBoxes", effectdata)
		local n = math.random(11)
		ent:EmitSound("ambient/energy/newspark"..(n<10 and "0" or "")..n..".wav")
	end
	
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


