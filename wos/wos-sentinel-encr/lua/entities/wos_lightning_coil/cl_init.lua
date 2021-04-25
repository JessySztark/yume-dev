include('shared.lua')

local model_orb = Model("models/Combine_Helicopter/helicopter_bomb01.mdl")
local mat_orb = "models/alyx/emptool_glow"
local r = 28 / 4

ENT.Radius = 100
ENT.LifeSpan = 0

function ENT:Initialize()
	
	self:CreateBoom()		
end

function ENT:CreateBoom()

   if IsValid( self.Orb ) then self.Orb:Remove() end
   self.StartLife = CurTime()
   self.LifeSpan = CurTime() + 0.5
   self.Orb = ClientsideModel(model_orb, RENDERGROUP_OPAQUE )
   self.Orb:SetRenderMode( RENDERMODE_TRANSALPHA )
   self.Orb:SetPos( self.Owner:GetPos() )
   self.Orb:SetColor( Color( 255, 255, 255, 100 ) )
   self.Orb:SetModelScale( 0, 0 )
   self.Orb:SetMaterial( "models/effects/splodearc_sheet" ) 
   self:EmitSound( "weapons/physcannon/energy_sing_explosion2.wav", 100, math.random( 65, 135 ) )
end

function ENT:OnRemove()

	if IsValid( self.Orb ) then
		self.Orb:Remove()
	end

end

function ENT:Think()
	if IsValid( self.Orb ) then
	
       local ratio = ( CurTime() - self.StartLife ) / 0.01
	   self.Orb:SetModelScale( ratio, 0 ) 
	   self.Orb:SetMaterial( mat_orb )
	   self.Orb:SetPos( self.Owner:GetPos() )	   
	   if self.LifeSpan <= CurTime() then
			self:CreateBoom()
	   end
	end
	
end

function ENT:Draw()
	
end

