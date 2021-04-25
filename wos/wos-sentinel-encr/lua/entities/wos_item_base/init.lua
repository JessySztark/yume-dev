AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include( 'shared.lua' )

ENT.DespawnTime = false

function ENT:Initialize()

	self:DrawShadow(true)
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	self.Entity:SetUseType( SIMPLE_USE )

	local phys = self:GetPhysicsObject()
	if phys then
		phys:Wake()
	end

end

function ENT:Think()
	if self.DespawnTime then
		if self.DespawnTime < CurTime() then
			self:Remove()
			return
		end
	end
	
	if IsValid( self:GetOwner() ) then
		self.ActivePlayer = true
	end
	
	if self.ActivePlayer then
		if not self:GetOwner():IsValid() then
			self:Remove()
		end
	end
	
end

function ENT:Use( ply )
	
	if self:GetItemType() == WOSTYPE.RAWMATERIAL then
		if wOS:HandleMaterialPickup( ply, self:GetItemName(), self:GetAmount() ) then
			self:Remove()
		end
		return
	end
	
	if wOS:HandleItemPickup( ply, self:GetItemName() ) then self:Remove() end

end