AddCSLuaFile()
include('shared.lua')

ENT.Spawnable			= true
ENT.AdminSpawnable		= true
ENT.RenderGroup 		= RENDERGROUP_OPAQUE

function ENT:DrawIcon()
	if not self.Icon then
		self.Icon = ClientsideModel( "models/niksacokica/vendor/vendor_sign_warrior.mdl" )
		self.Icon:SetNoDraw( true )
	end

	local pos = ( LocalPlayer():GetPos() - self:GetPos() ):Angle().y

	self.Icon:SetPos( self:GetPos() + self:GetUp()*100 )
	self.Icon:SetAngles( Angle( 0, pos, 0 ) )
	self.Icon:DrawModel()
end

function ENT:Draw()
	self.Entity:DrawModel()
	self:DrawIcon()
end

function ENT:OnRemove()
	if self.Icon then
		self.Icon:Remove()
	end
	self.BuildingSound:Stop()
end