
--[[-------------------------------------------------------------------
	Personal Shield Swep:
		This literally does fucking nothing except let me use the console command
			Powered by
						  _ _ _    ___  ____  
				__      _(_) | |_ / _ \/ ___| 
				\ \ /\ / / | | __| | | \___ \ 
				 \ V  V /| | | |_| |_| |___) |
				  \_/\_/ |_|_|\__|\___/|____/ 
											  
 _____         _                 _             _           
|_   _|__  ___| |__  _ __   ___ | | ___   __ _(_) ___  ___ 
  | |/ _ \/ __| '_ \| '_ \ / _ \| |/ _ \ / _` | |/ _ \/ __|
  | |  __/ (__| | | | | | | (_) | | (_) | (_| | |  __/\__ \
  |_|\___|\___|_| |_|_| |_|\___/|_|\___/ \__, |_|\___||___/
                                         |___/             
-------------------------------------------------------------------]]--[[
							  
	Lua Developer: King David
	Contact: www.wiltostech.com
	
		
----------------------------------------]]--

if (SERVER) then

	SWEP.Weight				= 5
	SWEP.AutoSwitchTo			= false
	SWEP.AutoSwitchFrom		= false
end

if ( CLIENT ) then
	SWEP.PrintName			= "Integrated Storage Device"	
	SWEP.DrawAmmo 			= false
	SWEP.DrawCrosshair 		= false
	SWEP.ViewModelFOV			= 77
	SWEP.ViewModelFlip		= false
	SWEP.CSMuzzleFlashes		= true
	
	SWEP.Slot				= 2
	SWEP.SlotPos			= 0
	SWEP.IconLetter			= "j"
end

SWEP.Category			= "wiltOS Technologies"

SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true

SWEP.DrawWeaponInfoBox  	= false

SWEP.Weight					= 5
SWEP.AutoSwitchTo				= false
SWEP.AutoSwitchFrom			= false

SWEP.Primary.ClipSize			= -1
SWEP.Primary.Damage			= -1
SWEP.Primary.DefaultClip		= -1
SWEP.Primary.Automatic			= true
SWEP.Primary.Ammo			="none"


SWEP.Secondary.ClipSize			= -1
SWEP.Secondary.DefaultClip		= -1
SWEP.Secondary.Damage			= -1
SWEP.Secondary.Automatic		= true
SWEP.Secondary.Ammo			="none"

SWEP.DrawWorldModel = false

/*---------------------------------------------------------
Think
---------------------------------------------------------*/
function SWEP:Think()
end

/*---------------------------------------------------------
Initialize
---------------------------------------------------------*/
function SWEP:Initialize() 
	self:SetWeaponHoldType( "slam" ) 	 
end 

/*---------------------------------------------------------
Deploy
---------------------------------------------------------*/
function SWEP:Deploy()
	return true
end

/*---------------------------------------------------------
PrimaryAttack
---------------------------------------------------------*/
function SWEP:PrimaryAttack()
	if SERVER then
		self.Owner:ConCommand( "wos_openinventory" )
	end
	self:SetNextPrimaryFire( CurTime() + 1 )
end

function SWEP:SecondaryAttack()
end

function SWEP:Reload()
	return false
end

/*---------------------------------------------------------
OnRemove
---------------------------------------------------------*/
function SWEP:OnRemove()
	return true
end

/*---------------------------------------------------------
Holster
---------------------------------------------------------*/
function SWEP:Holster()
	return true
end

if CLIENT then
	function SWEP:PreDrawViewModel() render.SetBlend(0) end
	function SWEP:DrawWorldModel() end
	function SWEP:DrawWeaponSelection(x,y,wide,tall,alpha) end
end