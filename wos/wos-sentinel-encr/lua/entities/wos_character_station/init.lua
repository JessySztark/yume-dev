AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

function ENT:Initialize()
	self:SetModel( "models/niksacokica/tech/tech_science_centrifuge.mdl" )
	self:DrawShadow(true)
	self.BuildingSound = CreateSound( self.Entity, "ambient/levels/citadel/citadel_hub_ambience1.mp3" )
	self.BuildingSound:Play()

	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_NONE )
	self:SetCollisionGroup( COLLISION_GROUP_NONE )	
	self:SetUseType( SIMPLE_USE )
	//self:SetSolid( SOLID_VPHYSICS )
	//self:PhysWake()

	self:SetModelScale( 4.5 )

end

function ENT:Use( ply )

	net.Start( "wOS.Crafting.GetInventory" )
		net.WriteTable( ply.SaberInventory )
		net.WriteTable( ply.SaberMiscItems )
	net.Send( ply )
	ply:SendLua( [[wOS.ALCS.Skills:OpenSkillsMenu()]] )
	
end

function ENT:SpawnFunction( ply, tr, ClassName )

	if ( !tr.Hit ) then return end

	local SpawnPos = tr.HitPos - tr.HitNormal * 2

	local ent = ents.Create( ClassName )
	ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Activate()

	return ent

end

function ENT:UpdateTransmitState()

	return TRANSMIT_ALWAYS 

end

