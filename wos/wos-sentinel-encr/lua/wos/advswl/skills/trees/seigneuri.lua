local TREE = {}
 
--Name of the skill tree
TREE.Name = "Seigneur - Inquisiteur"
 
--Description of the skill tree
TREE.Description = "Visitez les recoins les plus sombres de la Force"
 
--Icon for the skill tree ( Appears in category menu and above the skills )
TREE.TreeIcon = "wos/forceicons/lightstream.png"
 
--What is the color for the background of skill icons
TREE.BackgroundColor = Color( 255, 0, 0 )
 
--How many tiers of skills are there?
TREE.MaxTiers = 3
 
--Add user groups that are allowed to use this tree. If anyone is allowed, set this to FALSE ( TREE.UserGroups = false )
TREE.JobRestricted = { "TEAM_SEIGNEURI" }

TREE.Tier[1] = {}
TREE.Tier[1][1] = {
    Name = "Canalisation",
    Description = "Canalisez votre haine",
    Icon = "wos/skilltrees/ravager/channel.png",
    PointsRequired = 3,
    Requirements = {},
    LockOuts = {},
    OnPlayerSpawn = function( ply ) end,
    OnPlayerDeath = function( ply ) end,
    OnSaberDeploy = function( wep ) wep:AddForcePower( "Canalisation" ) end,
}
TREE.Tier[1][2] = {
    Name = "Saut de Force",
    Description = "Canalisez la Force dans vos jambes pour sauter plus haut et plus loin",
    Icon = "wos/forceicons/leap.png",
    PointsRequired = 3,
    Requirements = {},
    LockOuts = {},
    OnPlayerSpawn = function( ply ) end,
    OnPlayerDeath = function( ply ) end,
    OnSaberDeploy = function( wep ) wep:AddForcePower( "Saut De Force" ) end,
}
TREE.Tier[2][1] = {
    Name = "Attraction de Force",
    Description = "Ramenez l'ennemis vers vous grâce à la Force",
    Icon = "wos/forceicons/pull.png",
    PointsRequired = 5,
    Requirements = {
        [1] = { 1 , 2 }
    },
    LockOuts = {},
    OnPlayerSpawn = function( ply ) end,
    OnPlayerDeath = function( ply ) end,
    OnSaberDeploy = function( wep ) wep:AddForcePower( "Attraction De Force" ) end,
}
TREE.Tier[2][2] = {
    Name = "Pousée de Force",
    Description = "Poussez l'ennemis grâce à la Force",
    Icon = "wos/forceicons/push.png",
    PointsRequired = 5,
    Requirements = {
        [1] = { 1 , 2 }
    },
    LockOuts = {},
    OnPlayerSpawn = function( ply ) end,
    OnPlayerDeath = function( ply ) end,
    OnSaberDeploy = function( wep ) wep:AddForcePower( "Pousée De Force" ) end,
}
TREE.Tier[2][3] = {
    Name = "Répulsion de Force",
    Description = "Pousse les ennemis autour de vous grâce à la Force",
    Icon = "wos/forceicons/repulse.png",
    PointsRequired = 5,
    Requirements = {
        [1] = { 1 , 2 }
    },
    LockOuts = {},
    OnPlayerSpawn = function( ply ) end,
    OnPlayerDeath = function( ply ) end,
    OnSaberDeploy = function( wep ) wep:AddForcePower( "Répulsion De Force" ) end,
}
TREE.Tier[3][1] = {
    Name = "Éclair de Force",
    Description = "Torture les personnes et monstres à volonté.",
    Icon = "wos/forceicons/lightning.png",
    PointsRequired = 7,
    Requirements = {
        [2] = { 1 , 2 , 3 }
    },
    LockOuts = {},
    OnPlayerSpawn = function( ply ) end,
    OnPlayerDeath = function( ply ) end,
    OnSaberDeploy = function( wep ) wep:AddForcePower( "Éclair De Force" ) end,
}
TREE.Tier[4][1] = {
    Name = "Frappe Éclair",
    Description = "Une charge d'éclair concentrée puissante.",
    Icon = "wos/forceicons/lightningstrike.png",
    PointsRequired = 7,
    Requirements = {
        [3] = { 1 }
    },
    LockOuts = {},
    OnPlayerSpawn = function( ply ) end,
    OnPlayerDeath = function( ply ) end,
    OnSaberDeploy = function( wep ) wep:AddForcePower( "Frappe D'Éclair" ) end,
}
TREE.Tier[4][2] = {
    Name = "Tempête de Force",
    Description = "Se charge pendant 2 secondes. Libère une tempête de Force sur vos ennemis.",
    Icon = "wos/forceicons/storm.png",
    PointsRequired = 10,
    Requirements = {
        [3] = { 1 }
    },
    LockOuts = {},
    OnPlayerSpawn = function( ply ) end,
    OnPlayerDeath = function( ply ) end,
    OnSaberDeploy = function( wep ) wep:AddForcePower( "Tempête De Force" ) end,
}