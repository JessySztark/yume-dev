include( "shared.lua" )

SWEP.DrawAmmo			= true
SWEP.DrawCrosshair		= true
SWEP.CSMuzzleFlashes	= true

SWEP.ViewModelFOV		= 74
SWEP.ViewModelFlip		= false

SWEP.PrintName = "wiltOS Duel Dome Placer"
SWEP.Slot = 5
SWEP.Slotpos = 5


function SWEP:DrawHUD()

	draw.SimpleText( "PRIMARY FIRE: Place Duel Dome ( Center )        SECONDARY FIRE: Select Nearest Duel Dome          RELOAD: Delete Nearest Duel Dome		USE: Open Configuration Menu", "Trebuchet24", ScrW() * 0.5, ScrH() - 200, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )	
	
	local text = "NO DOME SELECTED"
	if self:GetSelected() != NULL then
		text = "SELECTED: " .. self:GetSelected():GetTitle() .. "		|		RADIUS: " .. self:GetSelected():GetRadius()
	end
	draw.SimpleText( text, "Trebuchet24", ScrW() * 0.5, ScrH() - 170, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )		

end

function SWEP:Deploy()

	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )

	return true
	
end  

function SWEP:ShootEffects()	
	
	self.Owner:MuzzleFlash()								
	self.Owner:SetAnimation( PLAYER_ATTACK1 )	
	
	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK ) 
	
end

function SWEP:PrimaryAttack()

	self.Weapon:SetNextPrimaryFire( CurTime() + 1 )
	self.Weapon:EmitSound( self.Primary.Sound, 100, math.random(95,105) )
	self.Weapon:ShootEffects()
	
end

function SWEP:SecondaryAttack()

	self.Weapon:EmitSound( self.Primary.Swap )	
	self.Weapon:SetNextSecondaryFire( CurTime() + 0.5 )
	
end