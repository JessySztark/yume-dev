

ENT.Type 			= "anim"
ENT.Base 			= "base_point"

function ENT:Initialize()

	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_NONE )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	
	self.Entity:DrawShadow( false )

end

function ENT:GetOccupied()
	local tr = util.TraceLine( { start = self:GetPos(), endpos = self:GetPos() + Vector( 0, 0, 3 ) } )
	if IsValid( tr.Entity ) then
		if tr.Entity:GetClass() == "wos_item_base" then return true end
	end
	return false
end

function ENT:KeyValue( key, value )

end
