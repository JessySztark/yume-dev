include('shared.lua')

local mat_orb = Material("sprites/rollermine_shock")

function ENT:Initialize()

end

function ENT:Think()
	
end

function ENT:OnRemove()

end

function ENT:Draw()

	local wep = LocalPlayer():GetActiveWeapon()
	if not IsValid( wep ) then return end
	if wep:GetClass() != "wos_alcs_duelplacer" then return end
	
	render.SetColorMaterial( mat_orb )
	local color = Color( 0, 125, 175, 175 )
	if wep:GetSelected() == self then
		color = Color( 0, 175, 125, 175 )
	end
	render.DrawSphere( self:GetPos(), -1*self:GetRadius(), 75, 75, color )
	render.DrawSphere( self:GetPos(), self:GetRadius(), 75, 75, color )
	
end
