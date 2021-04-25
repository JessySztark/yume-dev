
--[[-------------------------------------------------------------------
	Lightsaber Force Powers:
		The available powers that the new saber base uses.
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
----------------------------- Copyright 2017, David "King David" Wiltos ]]--[[
							  
	Lua Developer: King David
	Contact: www.wiltostech.com
		
-- Copyright 2017, David "King David" Wiltos ]]--

local TREE = {}

--Name of the skill tree
TREE.Name = "Ravager"

--Description of the skill tree
TREE.Description = "Master the blade, not the mind"

--Icon for the skill tree ( Appears in category menu and above the skills )
TREE.TreeIcon = "wos/skilltrees/ravager/main_icon.png"

--What is the background color in the menu for this 
TREE.BackgroundColor = Color( 255, 0, 0, 25 )

--How many tiers of skills are there?
TREE.MaxTiers = 5

--Add user groups that are allowed to use this tree. If anyone is allowed, set this to FALSE ( TREE.UserGroups = false )
TREE.UserGroups = false

TREE.Tier = {}

--Tier format is as follows:
--To create the TIER Table, do the following
--TREE.Tier[ TIER NUMBER ] = {} 
--To populate it with data, the format follows this
--TREE.Tier[ TIER NUMBER ][ SKILL NUMBER ] = DATA
--Name, description, and icon are exactly the same as before
--PointsRequired is for how many skill points are needed to unlock this particular skill
--Requirements prevent you from unlocking this skill unless you have the pre-requisite skills from the last tiers. If you are on tier 1, this should be {}
--OnPlayerSpawn is a function called when the player just spawns
--OnPlayerDeath is a function called when the player has just died
--OnSaberDeploy is a function called when the player has just pulled out their lightsaber ( assuming you have SWEP.UsePlayerSkills = true )


TREE.Tier[1] = {}
TREE.Tier[1][1] = {
	Name = "Strength",
	Description = "+50 Max Health",
	Icon = "wos/skilltrees/ravager/strength.png",
	PointsRequired = 1,
	Requirements = {},
	OnPlayerSpawn = function( ply ) ply:SetMaxHealth( ply:GetMaxHealth() + 50 ) end,
	OnPlayerDeath = function( ply ) end,
	OnSaberDeploy = function( wep ) end,
}

TREE.Tier[1][2] = {
	Name = "Agility",
	Description = "+5% Movement Speed",
	Icon = "wos/skilltrees/ravager/agility.png",
	PointsRequired = 1,
	Requirements = {},
	OnPlayerSpawn = function( ply ) ply:SetRunSpeed( ply:GetRunSpeed()*1.05 ) end,
	OnPlayerDeath = function( ply ) end,
	OnSaberDeploy = function( wep ) end,
}

TREE.Tier[1][3] = {
	Name = "Combatant",
	Description = "+30 base damage to your lightsaber",
	Icon = "wos/skilltrees/ravager/combatant.png",
	PointsRequired = 1,
	Requirements = {},
	OnPlayerSpawn = function( ply ) end,
	OnPlayerDeath = function( ply ) end,
	OnSaberDeploy = function( wep ) wep.SaberDamage = wep.SaberDamage + 30 end,
}

TREE.Tier[1][4] = {
	Name = "Emergent",
	Description = "+10 burn damage to your lightsaber",
	Icon = "wos/skilltrees/ravager/emergent.png",
	PointsRequired = 1,
	Requirements = {},
	OnPlayerSpawn = function( ply ) end,
	OnPlayerDeath = function( ply ) end,
	OnSaberDeploy = function( wep ) wep.SaberBurnDamage = wep.SaberBurnDamage + 10 end,
}


TREE.Tier[2] = {}
TREE.Tier[2][1] = {
	Name = "Enlightening Scars",
	Description = "-25% Block Drain Rate",
	Icon = "wos/skilltrees/ravager/scars.png",
	PointsRequired = 1,
	Requirements = {
	[1] = { 1, 2 },
	},
	OnPlayerSpawn = function( ply ) end,
	OnPlayerDeath = function( ply ) end,
	OnSaberDeploy = function( wep ) wep.BlockDrainRate = wep.BlockDrainRate*0.75 end,
}

TREE.Tier[2][2] = {
	Name = "Tormented Soul",
	Description = "Learn to use your rage as a weapon",
	Icon = "wos/skilltrees/ravager/torment.png",
	PointsRequired = 1,
	Requirements = {},
	OnPlayerSpawn = function( ply ) end,
	OnPlayerDeath = function( ply ) end,
	OnSaberDeploy = function( wep ) wep:AddForcePower( "Rage" ) end,
}

TREE.Tier[2][3] = {
	Name = "Mindful Propulsion",
	Description = "Throw your lightsaber for those out of reach",
	Icon = "wos/skilltrees/ravager/mindful.png",
	PointsRequired = 1,
	Requirements = {
	[1] = { 3, 4 },
	},
	OnPlayerSpawn = function( ply ) end,
	OnPlayerDeath = function( ply ) end,
	OnSaberDeploy = function( wep ) wep:AddForcePower( "Saber Throw" ) end,
}

TREE.Tier[3] = {}
TREE.Tier[3][1] = {
	Name = "Internal Conflict",
	Description = "Rage effects are now permanent. -75% Force power energy",
	Icon = "wos/skilltrees/ravager/internal.png",
	PointsRequired = 1,
	Requirements = {
	[2] = { 2 },
	},
	OnPlayerSpawn = function( ply ) end,
	OnPlayerDeath = function( ply ) end,
	OnSaberDeploy = function( wep ) 
		wep.SaberDamage = wep.SaberDamage*1.5 
		wep.MaxForce = wep.MaxForce*0.25
	end,
}

TREE.Tier[3][2] = {
	Name = "Focus From Anger",
	Description = "Learn to channel your hatred",
	Icon = "wos/skilltrees/ravager/channel.png",
	PointsRequired = 1,
	Requirements = {
	[2] = { 1, 3 },
	},
	OnPlayerSpawn = function( ply ) end,
	OnPlayerDeath = function( ply ) end,
	OnSaberDeploy = function( wep ) wep:AddForcePower( "Channel Hatred" ) end,
}

TREE.Tier[4] = {}
TREE.Tier[4][1] = {
	Name = "Double Trouble",
	Description = "Two hands make all the difference",
	Icon = "wos/skilltrees/ravager/release.png",
	PointsRequired = 1,
	Requirements = {
	[3] = { 2 },
	},
	OnPlayerSpawn = function( ply ) ply.CanUseDuals = true end,
	OnPlayerDeath = function( ply ) end,
	OnSaberDeploy = function( wep ) wep:AddForm( "Arrogant", 1 ) wep:AddForm( "Arrogant", 2 ) wep:AddForm( "Arrogant", 3 ) end,
}

TREE.Tier[5] = {}
TREE.Tier[5][1] = {
	Name = "Final Blow",
	Description = "Release an explosion when you die",
	Icon = "wos/skilltrees/ravager/final_blow.png",
	PointsRequired = 1,
	Requirements = {
	[4] = { 1 },
	},
	OnPlayerSpawn = function( ply ) end,
	OnPlayerDeath = function( ply ) 
		local effectdata = EffectData()
		effectdata:SetOrigin( ply:GetPos() )
		util.Effect( "HelicopterMegaBomb", effectdata )		
		ply:EmitSound( "weapons/explode3.wav" )
		util.BlastDamage( ply, ply, ply:GetPos(), 50, 100 )  
	end,
	OnSaberDeploy = function( wep ) end,

}

wOS:RegisterSkillTree( TREE )