ENT.Type 		= "anim"
ENT.PrintName	= "Character Skill Station"
ENT.Author		= "King David"
ENT.Contact		= ""
ENT.Category = "wiltOS Technologies"
ENT.Spawnable			= true
ENT.AdminSpawnable		= true

function ENT:Think()
	if not self.BuildingSound then
		self.BuildingSound = CreateSound( self.Entity, "ambient/levels/citadel/citadel_hub_ambience1.mp3" )
		self.BuildingSound:Play()
	end
end

function ENT:OnRemove()
	self.BuildingSound:Stop()
end