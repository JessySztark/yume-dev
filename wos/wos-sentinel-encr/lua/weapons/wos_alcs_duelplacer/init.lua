AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

SWEP.Weight				= 1
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.LastUse = 0
SWEP.LastDelete = 0

function SWEP:Initialize()

	self.Weapon:SetWeaponHoldType( self.HoldType )

end

function SWEP:Deploy()

	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )

	self:SetSelected( NULL )

	return true
	
end  

function SWEP:Think()	
	
	if self.Owner:KeyDown( IN_USE ) and self.LastUse < CurTime() then
		if self:GetSelected() != NULL then
			self.Owner:SendLua( [[ wOS.ALCS.Dueling:OpenConfigurationMenu() ]] )
		end
		self.LastUse = CurTime() + 1
		self.Weapon:EmitSound( self.Primary.Swap )	
	end
	
end

function SWEP:Reload()

	if self.LastDelete > CurTime() then return end

	local aimpos = self:GetHitPos()
	local closest
	local dist = 10000
	
	for k,v in pairs( ents.FindByClass( "wos_duel_dome" ) ) do
	
		if v:GetPos():Distance( aimpos ) < dist then
		
			dist = v:GetPos():Distance( aimpos )
			closest = v
		
		end
	
	end
	
	if IsValid( closest ) then
		self.Owner:EmitSound( self.Primary.Delete )
		closest:Remove()
	end
	
	self.LastDelete = CurTime() + 1
	
end

function SWEP:Holster()

	self:SetSelected( NULL )
	return true

end

function SWEP:ShootEffects()	
	
	self.Owner:MuzzleFlash()								
	self.Owner:SetAnimation( PLAYER_ATTACK1 )	
	
	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK ) 
	
end

function SWEP:GetHitPos()
	local look = self.Owner:EyeAngles()
	local dir = look:Forward()
	local trace = {}
	trace.start = self.Owner:GetShootPos()	
	trace.endpos = trace.start + dir * 50
	trace.filter = { self.Owner }
	trace.mask = MASK_SOLID
	local tr = util.TraceLine( trace )
	
	return tr.HitPos
end

function SWEP:PrimaryAttack()

	self.Weapon:SetNextPrimaryFire( CurTime() + 1 )
	self.Weapon:EmitSound( self.Primary.Sound, 100, math.random(95,105) )
	self.Weapon:ShootEffects()
	
	local tr = util.TraceLine( util.GetPlayerTrace( self.Owner ) )
	local pos = tr.HitPos
	
	local dome = ents.Create( "wos_duel_dome" )
	dome:SetPos( pos )
	dome:Spawn()
	
end

function SWEP:SecondaryAttack()

	local aimpos = self:GetHitPos()
	local closest
	local dist = 1000

	for k,v in pairs( ents.FindByClass( "wos_duel_dome" ) ) do
	
		if v:GetPos():Distance( aimpos ) < dist then
		
			dist = v:GetPos():Distance( aimpos )
			closest = v
		
		end
	
	end
	
	if IsValid( closest ) then
		self:SetSelected( closest )
	else
		self:SetSelected( NULL )
	end

	self.Weapon:EmitSound( self.Primary.Swap )	
	self.Weapon:SetNextSecondaryFire( CurTime() + 0.5 )

end
