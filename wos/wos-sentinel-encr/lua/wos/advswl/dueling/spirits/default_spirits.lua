--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2020
	
	Contact: www.wiltostech.com
		----------------------------------------]]--








































































wOS.ALCS.Dueling:RegisterSpirit({
	Name = "Soul of King David",
	Description = "A love for the battle, not the outcome",
	RarityName = "Legendary",
	RarityColor = Color( 255, 125, 0 ),
	SpiritModel = "models/player/king_david_wiltos.mdl",
	DuelTitle = "The King",
	TagLine = "Hoping this one is a challenge",
	Sequence = "judge_customize",
	ChallengeSound = "vo/npc/male01/evenodds.wav",
	VictorySound = "vo/npc/male01/gordead_ques11.wav",
	MaxEnergy = 1000,
	StartingRoll = 25,
	PassiveLevel = 30,
	Rarity = 25,
	DroppableArtifacts = {
		[ "Ravager's Crux" ] = 100,
		[ "Max Strength!" ] = 250,	
	},
	OnDuelStart = function( ply )
	
	end,
	OnSpawn = function( ply )
		ply:Give( "weapon_stunstick" )
	end,
	OnThink = function( ply )
		ply:SetHealth( math.Clamp( ply:Health() + 1, 0, ply:GetMaxHealth() ) )
	end,
	OnDeath = function( ply )

	end,
})

wOS.ALCS.Dueling:RegisterSpirit({
	Name = "Spirit of the Duelist",
	Description = "Everyone starts somewhere",
	RarityName = "Common",
	RarityColor = Color( 255, 255, 255 ),
	DuelTitle = "Aspiring Duelist",
	TagLine = "Wishes you good luck!",
	SpiritModel = "models/player/barney.mdl",
	Sequence = "idle_fist",
	MaxEnergy = 500,
	StartingRoll = 0,
	Rarity = 0,
	DroppableArtifacts = {},
	ChallengeSound = "vo/npc/male01/evenodds.wav",
	VictorySound = "vo/npc/male01/gordead_ques11.wav",
})

wOS.ALCS.Dueling:RegisterSpirit({
	Name = "Programming of the Robot",
	Description = "ROBOTS DO NOT KNOW FAILURE",
	RarityName = "Rare",
	RarityColor = Color( 0, 0, 175 ),
	SpiritModel = "models/player/kleiner.mdl",
	DuelTitle = "BOT",
	MaxEnergy = 600,
	StartingRoll = 10,
	Rarity = 50,
	DroppableArtifacts = {},
	TagLine = "Beep boop boop beep",
	Sequence = "taunt_robot",
	ChallengeSound = "HL1/fvox/evacuate_area.wav",
	VictorySound = "HL1/fvox/powermove_overload.wav",
})

wOS.ALCS.Dueling:RegisterSpirit({
	Name = "Rotting Soul of Fallen Kings",
	Description = "The world was yours",
	RarityName = "Epic",
	RarityColor = Color( 175, 0, 175 ),
	SpiritModel = "models/player/charple.mdl",
	DuelTitle = "The Fallen",
	MaxEnergy = 300,
	StartingRoll = -20,
	Rarity = 25,
	DroppableArtifacts = {},
	TagLine = "Will take back what's rightfully his",
	Sequence = "zombie_walk_06",
	ChallengeSound = "vo/npc/vortigaunt/tethercut.wav",
	VictorySound = "vo/npc/vortigaunt/bodyyours.wav",
})

wOS.ALCS.Dueling:RegisterSpirit({
	Name = "Blessed Spirit of Repent",
	Description = "For the ill, forgotten, and weak",
	RarityName = "Rare",
	RarityColor = Color( 0, 0, 175 ),
	SpiritModel = "models/player/mossman_arctic.mdl",
	DuelTitle = "Spiritual Healer",
	MaxEnergy = 500,
	Rarity = 70,
	StartingRoll = 30,
	DroppableArtifacts = {},
	TagLine = "The pale queen sings for thy victim",
	Sequence = "taunt_heavy",
	ChallengeSound = "vo/npc/female01/readywhenyouare01.wav",
	VictorySound = "vo/npc/female01/notthemanithought02.wav",
})

wOS.ALCS.Dueling:RegisterSpirit({
	Name = "Tormented Soul of Defiance",
	Description = "Those who share no enemy walk alone",
	RarityName = "Common",
	RarityColor = Color( 255, 255, 255 ),
	SpiritModel = "models/player/phoenix.mdl",
	DuelTitle = "Defiant Wanderer",
	Rarity = 40,
	MaxEnergy = 1500,
	StartingRoll = 50,
	DroppableArtifacts = {},
	TagLine = "Hopes this one is quick",
	Sequence = "taunt_balanced",
	ChallengeSound = "npc/metropolice/takedown.wav",
	VictorySound = "npc/metropolice/vo/chuckle.wav",
})