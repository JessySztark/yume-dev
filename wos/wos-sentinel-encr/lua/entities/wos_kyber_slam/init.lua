
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )


function ENT:Initialize()

	self.Entity:SetMoveType( MOVETYPE_NONE )
	self.Entity:SetSolid( SOLID_OBB )
	
	self.BuildingSound = CreateSound( self.Entity, "ambient/machines/combine_shield_loop3.wav" )
	self.BuildingSound:Play()	
	
	self.Entity:SetCollisionGroup( COLLISION_GROUP_BREAKABLE_GLASS )
	self.Entity:SetTrigger( true )
	self.Entity:SetNotSolid( true )
	self.Entity:DrawShadow( false )	
	
	self.Entity:Activate()
	
	local length = 750
	local width = 750
	local height = 500

	self.LifeSpan = CurTime() + 2
	
	local maxref = Vector( length/2, width/2, height )
	local minref = Vector( length/-2, width/-2, 0 )
	
	self.Entity:SetCollisionBounds( minref, maxref )
	
end

function ENT:Think()
	self:EmitSound( "ambient/levels/citadel/portal_beam_shoot" .. math.random( 1, 6 ) .. ".wav" )
	ParticleEffect( table.Random( {"har_cb_explosion_a","har_cb_explosion_b"} ), self.Owner:GetPos(), Angle(0,0,0), nil )
	
	if self.LifeSpan < CurTime() then
	
		self.Entity:Remove()
	
	end
	
end

function ENT:StartTouch( ent ) 
	if ent == self.Owner then return end
	if not ent:IsNPC() and not ent:IsPlayer() and not ent:IsNextBot() then return end
	local dmginfo = DamageInfo()
	dmginfo:SetDamage( 1200 )
	dmginfo:SetAttacker( self.Owner )
	dmginfo:SetInflictor( self.Owner:GetActiveWeapon() )
	dmginfo:SetDamageType( DMG_DISSOLVE )
	ent:TakeDamageInfo( dmginfo )
end 

function ENT:OnRemove()
	if self.BuildingSound then
		self.BuildingSound:Stop()
		self.BuildingSound = nil	
	end
end


