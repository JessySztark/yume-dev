
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
TREE.Name = "Forms"

--Description of the skill tree
TREE.Description = "Learn the Martial Arts of the Force."

--Icon for the skill tree ( Appears in category menu and above the skills )
TREE.TreeIcon = "wos/skilltrees/forms/forms_skill.png"

--What is the background color in the menu for this 
TREE.BackgroundColor = Color( 255, 0, 0, 25 )

--How many tiers of skills are there?
TREE.MaxTiers = 3

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
	Name = "Defensive 1",
	Description = "Gives your Form Defensive Stance 1",
	Icon = "wos/skilltrees/forms/defensive.png",
	PointsRequired = 2,
	Requirements = {},
	OnPlayerSpawn = function( ply ) end,
	OnPlayerDeath = function( ply ) end,
	OnSaberDeploy = function( wep ) wep:AddForm( "Defensive", 1 ) end,
}

TREE.Tier[1][2] = {
	Name = "Aggressive 1",
	Description = "Gives your Form Aggressive Stance 1",
	Icon = "wos/skilltrees/forms/aggressive.png",
	PointsRequired = 2,
	Requirements = {},
	OnPlayerSpawn = function( ply ) end,
	OnPlayerDeath = function( ply ) end,
	OnSaberDeploy = function( wep ) wep:AddForm( "Aggressive", 1 ) end,
}

TREE.Tier[1][3] = {
	Name = "Versatile 2",
	Description = "Gives your Form Versatile Stance 2",
	Icon = "wos/skilltrees/forms/versatile.png",
	PointsRequired = 2,
	Requirements = {},
	OnPlayerSpawn = function( ply ) end,
	OnPlayerDeath = function( ply ) end,
	OnSaberDeploy = function( wep ) wep:AddForm( "Versatile", 2 ) end,
}

TREE.Tier[1][4] = {
	Name = "Agile 3",
	Description = "Gives your Form Agile Stance 3",
	Icon = "wos/skilltrees/forms/agile.png",
	PointsRequired = 2,
	Requirements = {},
	OnPlayerSpawn = function( ply ) end,
	OnPlayerDeath = function( ply ) end,
	OnSaberDeploy = function( wep ) wep:AddForm( "Agile", 3 ) end,
}

TREE.Tier[2] = {}
TREE.Tier[2][1] = {
	Name = "Defensive 2",
	Description = "Gives your Form Defensive Stance 2",
	Icon = "wos/skilltrees/forms/defensive.png",
	PointsRequired = 2,
	Requirements = {
	[1] = { 1 },
	},
	OnPlayerSpawn = function( ply ) end,
	OnPlayerDeath = function( ply ) end,
	OnSaberDeploy = function( wep ) wep:AddForm( "Defensive", 2 ) end,
}

TREE.Tier[2][2] = {
	Name = "Aggressive 2",
	Description = "Gives your Form Aggressive Stance 2",
	Icon = "wos/skilltrees/forms/aggressive.png",
	PointsRequired = 3,
	Requirements = {
	[1] = { 2 },
	},
	OnPlayerSpawn = function( ply ) end,
	OnPlayerDeath = function( ply ) end,
	OnSaberDeploy = function( wep ) wep:AddForm( "Aggressive", 2 ) end,
}

TREE.Tier[2][3] = {
	Name = "Versatile 1",
	Description = "Gives your Form Versatile Stance 1",
	Icon = "wos/skilltrees/forms/versatile.png",
	PointsRequired = 3,
	Requirements = {
	[1] = { 3 },
	},
	OnPlayerSpawn = function( ply ) end,
	OnPlayerDeath = function( ply ) end,
	OnSaberDeploy = function( wep ) wep:AddForm( "Versatile", 1 ) end,
}

TREE.Tier[2][4] = {
	Name = "Agile 2",
	Description = "Gives your Form Agile Stance 2",
	Icon = "wos/skilltrees/forms/agile.png",
	PointsRequired = 3,
	Requirements = {
	[1] = { 4 },
	},
	OnPlayerSpawn = function( ply ) end,
	OnPlayerDeath = function( ply ) end,
	OnSaberDeploy = function( wep ) wep:AddForm( "Agile", 2 ) end,
}

TREE.Tier[3] = {}
TREE.Tier[3][1] = {
	Name = "Defensive 3",
	Description = "Gives your Form Defensive Stance 3",
	Icon = "wos/skilltrees/forms/defensive.png",
	PointsRequired = 3,
	Requirements = {
	[2] = { 1 },
	},
	OnPlayerSpawn = function( ply ) end,
	OnPlayerDeath = function( ply ) end,
	OnSaberDeploy = function( wep ) wep:AddForm( "Defensive", 3 ) end,
}

TREE.Tier[3][2] = {
	Name = "Aggressive 3",
	Description = "Gives your Form Aggressive Stance 3",
	Icon = "wos/skilltrees/forms/aggressive.png",
	PointsRequired = 4,
	Requirements = {
	[2] = { 2 },
	},
	OnPlayerSpawn = function( ply ) end,
	OnPlayerDeath = function( ply ) end,
	OnSaberDeploy = function( wep ) wep:AddForm( "Aggressive", 3 ) end,
}

TREE.Tier[3][3] = {
	Name = "Versatile 3",
	Description = "Gives your Form Versatile Stance 3",
	Icon = "wos/skilltrees/forms/versatile.png",
	PointsRequired = 4,
	Requirements = {
	[2] = { 3 },
	},
	OnPlayerSpawn = function( ply ) end,
	OnPlayerDeath = function( ply ) end,
	OnSaberDeploy = function( wep ) wep:AddForm( "Versatile", 3 ) end,
}

TREE.Tier[3][4] = {
	Name = "Agile 1",
	Description = "Gives your Form Agile Stance 1",
	Icon = "wos/skilltrees/forms/agile.png",
	PointsRequired = 4,
	Requirements = {
	[2] = { 4 },
	},
	OnPlayerSpawn = function( ply ) end,
	OnPlayerDeath = function( ply ) end,
	OnSaberDeploy = function( wep ) wep:AddForm( "Agile", 1 ) end,
}
wOS:RegisterSkillTree( TREE )