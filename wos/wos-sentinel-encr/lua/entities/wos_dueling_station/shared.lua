ENT.Type 		= "anim"
ENT.PrintName	= "Dueling Station"
ENT.Author		= "King David"
ENT.Contact		= ""
ENT.Category = "wiltOS Technologies"
ENT.Spawnable			= true
ENT.AdminSpawnable		= true

function ENT:Think()
	if not self.BuildingSound then
		self.BuildingSound = CreateSound( self.Entity, "ambient/machines/combine_shield_loop3.wav" )
		self.BuildingSound:Play()
	end
end

function ENT:OnRemove()
	self.BuildingSound:Stop()
end