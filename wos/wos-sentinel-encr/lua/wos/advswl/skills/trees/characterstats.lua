
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
TREE.Name = "Arbre de compétences"

--Description of the skill tree
TREE.Description = "Découvrez le pouvoir de la Force."

--Icon for the skill tree ( Appears in category menu and above the skills )
TREE.TreeIcon = "wos/skilltrees/characterstats/characterstats.png"

--What is the background color in the menu for this 
TREE.BackgroundColor = Color( 170, 0, 255, 25 )

--How many tiers of skills are there?
TREE.MaxTiers = 6

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
	Name = "Vitalité 1",
	Description = "Ajoute 50 HP à votre vitalité actuel",
	Icon = "wos/skilltrees/characterstats/health.png",
	PointsRequired = 1,
	Requirements = {},
	LockOuts = {
		[1] = { 2, }
	},
	OnPlayerSpawn = function( ply ) ply:SetHealth( ply:Health() + 50 ) ply:SetMaxHealth( ply:GetMaxHealth() + 50 ) end,
	OnPlayerDeath = function( ply ) end,
	OnSaberDeploy = function( wep ) end,
}

TREE.Tier[1][2] = {
	Name = "Armure 1",
	Description = "Ajoute 10 d'armure à votre armure actuel",
	Icon = "wos/skilltrees/characterstats/armor.png",
	PointsRequired = 1,
	Requirements = {},
	OnPlayerSpawn = function( ply ) ply:SetArmor( ply:Armor() + 10 ) end,
	OnPlayerDeath = function( ply ) end,
	OnSaberDeploy = function( wep ) end,
}

TREE.Tier[1][3] = {
	Name = "Vitesse 1",
	Description = "Ajoute 15 de vitesse à votre vitesse actuel",
	Icon = "wos/skilltrees/characterstats/speed.png",
	PointsRequired = 1,
	Requirements = {},
	OnPlayerSpawn = function( ply ) ply:SetRunSpeed( ply:GetRunSpeed() + 15 ) end,
	OnPlayerDeath = function( ply ) end,
	OnSaberDeploy = function( wep ) end,
}

TREE.Tier[2] = {}
TREE.Tier[2][1] = {
	Name = "Vitalité 2",
	Description = "Ajoute 50 HP à votre vitalité actuel",
	Icon = "wos/skilltrees/characterstats/health.png",
	PointsRequired = 2,
	Requirements = {
	[1] = { 1 },
	},
	OnPlayerSpawn = function( ply ) ply:SetHealth( ply:Health() + 50 ) ply:SetMaxHealth( ply:GetMaxHealth() + 50 ) end,
	OnPlayerDeath = function( ply ) end,
	OnSaberDeploy = function( wep ) end,
}

TREE.Tier[2][2] = {
	Name = "Armure 2",
	Description = "Ajoute 10 d'armure à votre armure actuel",
	Icon = "wos/skilltrees/characterstats/armor.png",
	PointsRequired = 2,
	Requirements = {
	[1] = { 2 },
	},
	OnPlayerSpawn = function( ply ) ply:SetArmor( ply:Armor() + 10 ) end,
	OnPlayerDeath = function( ply ) end,
	OnSaberDeploy = function( wep ) end,
}

TREE.Tier[2][3] = {
	Name = "Vitesse 2",
	Description = "Ajoute 15 de vitesse à votre vitesse actuel",
	Icon = "wos/skilltrees/characterstats/speed.png",
	PointsRequired = 2,
	Requirements = {
	[1] = { 3 },
	},
	OnPlayerSpawn = function( ply ) ply:SetRunSpeed( ply:GetRunSpeed() + 15 ) end,
	OnPlayerDeath = function( ply ) end,
	OnSaberDeploy = function( wep ) end,
}

TREE.Tier[3] = {}
TREE.Tier[3][1] = {
	Name = "Vitalité 3",
	Description = "Ajoute 50 HP à votre vitalité actuel",
	Icon = "wos/skilltrees/characterstats/health.png",
	PointsRequired = 3,
	Requirements = {
	[2] = { 1 },
	},
	OnPlayerSpawn = function( ply ) ply:SetHealth( ply:Health() + 50 ) ply:SetMaxHealth( ply:GetMaxHealth() + 50 ) end,
	OnPlayerDeath = function( ply ) end,
	OnSaberDeploy = function( wep ) end,
}

TREE.Tier[3][2] = {
	Name = "Armure 3",
	Description = "Ajoute 10 d'armure à votre armure actuel",
	Icon = "wos/skilltrees/characterstats/armor.png",
	PointsRequired = 3,
	Requirements = {
	[2] = { 2 },
	},
	OnPlayerSpawn = function( ply ) ply:SetArmor( ply:Armor() + 10 ) end,
	OnPlayerDeath = function( ply ) end,
	OnSaberDeploy = function( wep ) end,
}

TREE.Tier[3][3] = {
	Name = "Vitesse 3",
	Description = "Ajoute 15 de vitesse à votre vitesse actuel",
	Icon = "wos/skilltrees/characterstats/speed.png",
	PointsRequired = 3,
	Requirements = {
	[2] = { 3 },
	},
	OnPlayerSpawn = function( ply ) ply:SetRunSpeed( ply:GetRunSpeed() + 15 ) end,
	OnPlayerDeath = function( ply ) end,
	OnSaberDeploy = function( wep ) end,
}

TREE.Tier[4] = {}
TREE.Tier[4][1] = {
	Name = "Vitalité 4",
	Description = "Ajoute 50 HP à votre vitalité actuel",
	Icon = "wos/skilltrees/characterstats/health.png",
	PointsRequired = 4,
	Requirements = {
	[3] = { 1 },
	},
	OnPlayerSpawn = function( ply ) ply:SetHealth( ply:Health() + 50 ) ply:SetMaxHealth( ply:GetMaxHealth() + 50 ) end,
	OnPlayerDeath = function( ply ) end,
	OnSaberDeploy = function( wep ) end,
}

TREE.Tier[4][2] = {
	Name = "Armure 4",
	Description = "Ajoute 10 d'armure à votre armure actuel",
	Icon = "wos/skilltrees/characterstats/armor.png",
	PointsRequired = 4,
	Requirements = {
	[3] = { 2 },
	},
	OnPlayerSpawn = function( ply ) ply:SetArmor( ply:Armor() + 10 ) end,
	OnPlayerDeath = function( ply ) end,
	OnSaberDeploy = function( wep ) end,
}

TREE.Tier[4][3] = {
	Name = "Vitesse 4",
	Description = "Ajoute 15 de vitesse à votre vitesse actuel",
	Icon = "wos/skilltrees/characterstats/speed.png",
	PointsRequired = 4,
	Requirements = {
	[3] = { 3 },
	},
	OnPlayerSpawn = function( ply ) ply:SetRunSpeed( ply:GetRunSpeed() + 15 ) end,
	OnPlayerDeath = function( ply ) end,
	OnSaberDeploy = function( wep ) end,
}

TREE.Tier[5] = {}
TREE.Tier[5][1] = {
	Name = "Vitalité 5",
	Description = "Ajoute 50 HP à votre vitalité actuel",
	Icon = "wos/skilltrees/characterstats/health.png",
	PointsRequired = 5,
	Requirements = {
	[4] = { 1 },
	},
	OnPlayerSpawn = function( ply ) ply:SetHealth( ply:Health() + 100 ) ply:SetMaxHealth( ply:GetMaxHealth() + 100 ) end,
	OnPlayerDeath = function( ply ) end,
	OnSaberDeploy = function( wep ) end,
}

TREE.Tier[5][2] = {
	Name = "Armure 5",
	Description = "Ajoute 40 d'armure à votre armure actuel",
	Icon = "wos/skilltrees/characterstats/armor.png",
	PointsRequired = 5,
	Requirements = {
	[4] = { 2 },
	},
	OnPlayerSpawn = function( ply ) ply:SetArmor( ply:Armor() + 60 ) end,
	OnPlayerDeath = function( ply ) end,
	OnSaberDeploy = function( wep ) end,
}

TREE.Tier[5][3] = {
	Name = "Vitesse 5",
	Description = "Ajoute 40 de vitesse à votre vitesse actuel",
	Icon = "wos/skilltrees/characterstats/speed.png",
	PointsRequired = 5,
	Requirements = {
	[4] = { 3 },
	},
	OnPlayerSpawn = function( ply ) ply:SetRunSpeed( ply:GetRunSpeed() + 30 ) end,
	OnPlayerDeath = function( ply ) end,
	OnSaberDeploy = function( wep ) end,
}


TREE.Tier[6] = {}
TREE.Tier[6][1] = {
	Name = "Vitalité 6",
	Description = "Ajoute 100 HP à votre vitalité actuel",
	Icon = "wos/skilltrees/characterstats/health.png",
	PointsRequired = 6,
	Requirements = {
	[5] = { 1 },
	},
	OnPlayerSpawn = function( ply ) ply:SetHealth( ply:Health() + 100 ) ply:SetMaxHealth( ply:GetMaxHealth() + 100 ) end,
	OnPlayerDeath = function( ply ) end,
	OnSaberDeploy = function( wep ) end,
}

TREE.Tier[6][2] = {
	Name = "Armure 6",
	Description = "Ajoute 100 d'armure à votre armure actuel",
	Icon = "wos/skilltrees/characterstats/armor.png",
	PointsRequired = 6,
	Requirements = {
	[5] = { 2 },
	},
	OnPlayerSpawn = function( ply ) ply:SetArmor( ply:Armor() + 100 ) end,
	OnPlayerDeath = function( ply ) end,
	OnSaberDeploy = function( wep ) end,
}

TREE.Tier[6][3] = {
	Name = "Vitesse 6",
	Description = "Ajoute 75 de vitesse à votre vitesse actuel",
	Icon = "wos/skilltrees/characterstats/speed.png",
	PointsRequired = 6,
	Requirements = {
	[5] = { 3 },
	},
	OnPlayerSpawn = function( ply ) ply:SetRunSpeed( ply:GetRunSpeed() + 50 ) end,
	OnPlayerDeath = function( ply ) end,
	OnSaberDeploy = function( wep ) end,
}

wOS:RegisterSkillTree( TREE )