include('shared.lua')
ENT.RenderGroup 		= RENDERGROUP_OPAQUE

function ENT:Draw()
	self.Entity:DrawModel()
end

function ENT:GetRarityColor()
	local col = self:GetRColor()
	return Color( col.x, col.y, col.z )
end