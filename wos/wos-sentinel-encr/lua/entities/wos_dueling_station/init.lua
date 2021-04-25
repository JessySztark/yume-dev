AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

function ENT:Initialize()
	self:SetModel( "models/niksacokica/tech/tech_pvp_targeting_consol.mdl" )
	self:DrawShadow(true)
	self.BuildingSound = CreateSound( self.Entity, "ambient/machines/combine_shield_loop3.wav" )
	self.BuildingSound:Play()
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_NONE )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	self.Entity:SetUseType( SIMPLE_USE )
	
	self:SetCollisionGroup( COLLISION_GROUP_NONE )	

end

function ENT:Use( ply )

	ply:SendLua( [[wOS.ALCS.Dueling:OpenDuelingMenu()]] )
	
end

function ENT:UpdateTransmitState()

	return TRANSMIT_ALWAYS 

end

