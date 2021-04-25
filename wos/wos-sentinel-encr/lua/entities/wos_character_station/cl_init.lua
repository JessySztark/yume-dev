AddCSLuaFile()
include('shared.lua')

ENT.Spawnable			= true
ENT.AdminSpawnable		= true
ENT.RenderGroup 		= RENDERGROUP_OPAQUE
ENT.Icons = {}

function ENT:Initialize()
	self:SetModel( "models/niksacokica/tech/tech_science_centrifuge.mdl" )
	self:DrawShadow(true)
	//self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_NONE )
	self:SetCollisionGroup( COLLISION_GROUP_NONE )	
	//self:SetSolid( SOLID_VPHYSICS )

	//self:PhysWake()

end

function ENT:DrawIcon( i )
	if not self.Icons[i] then
		self.Icons[i] = ClientsideModel( "models/niksacokica/vendor/vendor_sign_pvp.mdl" )
		self.Icons[i]:SetNoDraw( true )
	end
	
	local ang = Angle( 0, self:GetAngles().y + 60 + 120*(i-1), 0 )
	self.Icons[i]:SetPos( self:GetPos() + self:GetUp()*90 + ang:Forward()*30 )
	self.Icons[i]:SetAngles( ang )

	self.Icons[i]:DrawModel()

end

function ENT:Draw()
	self.Entity:DrawModel()
	for i=1, 3 do
		self:DrawIcon( i )
	end
end

function ENT:OnRemove()
	for i=1, 3 do
		self.Icons[i]:Remove()
	end
end