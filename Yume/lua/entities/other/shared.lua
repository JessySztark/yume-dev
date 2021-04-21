	ENT.Base = "base_ai"
	ENT.Type = "ai"
	ENT.PrintName = "Spindrall"
	ENT.Author = "Lord Lavender"
	ENT.Category = "NPC Korriban"
	ENT.Instructions = "Appuyer sur E"
	ENT.Spawnable = true
	ENT.AdminSpawnable = true
	ENT.AutomaticFrameAdvance = true

function ENT:SetAutomaticFrameAdvance( bUsingAnim )
    self.AutomaticFrameAdvance = bUsingAnim
end

function ENT:PhysicsCollide(data, physobj)
end;

function ENT:PhysicsUpdate(physobj)
end;