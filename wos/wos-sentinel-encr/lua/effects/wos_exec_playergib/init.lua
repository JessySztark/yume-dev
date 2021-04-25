
function EFFECT:Init( data )	
	local scale = data:GetScale()
	if scale < 2 then
		self:SetModel( table.Random( wOS.ALCS.ExecSys.SmallGibTable ) )
	else
		self:SetModel( table.Random( wOS.ALCS.ExecSys.BigGibTable ) ) 
	end
	self:PhysicsInit( SOLID_VPHYSICS )	self:SetMoveType( MOVETYPE_VPHYSICS )	
	self:SetMaterial( "models/flesh" )
	self:SetCollisionGroup( COLLISION_GROUP_DEBRIS )
	self:SetCollisionBounds( Vector( -128 -128, -128 ), Vector( 128, 128, 128 ) )
	self:SetAngles( Angle( math.Rand(0,360), math.Rand(0,360), math.Rand(0,360) ) )
	local phys = self:GetPhysicsObject()
	if IsValid( phys ) then
		local vec = VectorRand()
		vec.z = math.Clamp( vec.z, -0.4, 0.8 )		
		phys:Wake()
		phys:SetMass( 100 )
		phys:AddAngleVelocity( VectorRand() * 500 )
		phys:SetMaterial( "gmod_silent" )		
		if scale < 2 then
			phys:SetVelocity( vec * math.Rand( 100, 200 ) )
		else
			phys:SetVelocity( vec * math.Rand( 300, 600 ) )
		end
	end
	self.LifeTime = CurTime() + 8	self.SoundTime = CurTime() + math.Rand( 0.2, 0.6 )
end

function EFFECT:Think()
	return self.LifeTime > CurTime()
end
function EFFECT:PhysicsCollide()end
function EFFECT:Render()
	self:DrawModel()
end

