--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2020
	
	Contact: www.wiltostech.com
		----------------------------------------]]--

		
--DO NOT RENAME THIS FILE--
--DO NOT RENAME THIS FILE--
--DO NOT RENAME THIS FILE--
--DO NOT RENAME THIS FILE--
--DO NOT RENAME THIS FILE--
--DO NOT RENAME THIS FILE--
--DO NOT RENAME THIS FILE--
--DO NOT RENAME THIS FILE--
	
local MAP = {}

--The top text for the menu
MAP.HeaderName = "The Path Of Ascension"

--The sub-text for the menu
MAP.HeaderTagLine = "To be truly enlightened, you must be willing to sacrifice it all."

/*
	The level icons for each prestige 
	Does not have to be sequential! If you want to award a new ICON every X levels, you can
	It will automatically choose the lowest level
	
	CASES:
		Player is level 6, icons are level 5 and 10. Player will use level 5 icon until level 10
		Player is level 3, icons are level 5 and 10. Player will not have any icon until level 5
*/
MAP.LevelIcons = {
	[5] = "wos/advswl/duel_holocron.png",
	[10] = "wos/advswl/combat_holocron.png",
}

/*
	Which mastery should the player have to start on?
	Does not have to be position 1, but it's better for thinking to do so.
*/
MAP.StartingPosition = 1

/*
	These are all your different masteries. The format is typically as such:
	MAP.Paths[MASTERY_ID] = {
		Name = "NAME OF YOUR MASTERY",
		Description = "DESCRIPTION OF MASTERY",
		GridPosition = Vector( X_OFFSET, Y_OFFSET, 0 ),
		Icon = "PATH_TO_MATERIAL", 
		Amount = NUMBER_OF_TOKENS_REQUIRED,
		RequiredMastery = { MASTERY_ID1, MASTERY_ID2, MASTERY_ID3 },
		OnSpawn = FUNCTION called then player spawns with this mastery
		OnDeath = FUNCTION called when player dies with this mastery
		OnPurchased = FUNCTION called when player FIRST PURCHASES this mastery
	}
*/
MAP.Paths = {}

MAP.Paths[1] = {
	Name = "Entryway of Doom", --Name of mastery
	Description = "You have began your ascension. But where will you end?", --Description of mastery
	GridPosition = Vector( 0, 0, 0 ), --Position offset in the map
	Icon = "wos/advswl/skill_holocron.png",
	RequiredMastery = {}, --Does this require any masteries? If a single mastery is found, it will be purchasable
	Amount = 1,
	OnSpawn = function( ply )
	
	end,
	OnDeath = function( ply )
	
	end,
	OnPurchased = function( ply )
	
	end,
}

MAP.Paths[2] = {
	Name = "Path Of Exile", --Name of mastery
	Description = "You move against what you know, in hopes of learning truth", --Description of mastery
	GridPosition = Vector( 1, 0, 0 ), --Position offset in the map
	Icon = "wos/advswl/skill_holocron.png",
	RequiredMastery = { 1, }, --Does this require any masteries? If a single mastery is found, it will be purchasable
	Amount = 1,
	OnSpawn = function( ply )
	
	end,
	OnDeath = function( ply )
	
	end,
	OnPurchased = function( ply )
	
	end,
}

MAP.Paths[3] = {
	Name = "Path Of Union", --Name of mastery
	Description = "You adopt the beliefs of others and become stronger together", --Description of mastery
	GridPosition = Vector( -1, 0, 0 ), --Position offset in the map
	Icon = "wos/advswl/skill_holocron.png",
	RequiredMastery = { 1, }, --Does this require any masteries? If a single mastery is found, it will be purchasable
	Amount = 1,
	OnSpawn = function( ply )
	
	end,
	OnDeath = function( ply )
	
	end,
	OnPurchased = function( ply )
	
	end,
}

MAP.Paths[4] = {
	Name = "Path Of Suffering", --Name of mastery
	Description = "You accept the pain of others to bring happiness to them", --Description of mastery
	GridPosition = Vector( 0, 1, 0 ), --Position offset in the map
	Icon = "wos/advswl/skill_holocron.png",
	RequiredMastery = { 1, }, --Does this require any masteries? If a single mastery is found, it will be purchasable
	Amount = 1,
	OnSpawn = function( ply )
	
	end,
	OnDeath = function( ply )
	
	end,
	OnPurchased = function( ply )
	
	end,
}

MAP.Paths[5] = {
	Name = "Path Of Contemplation", --Name of mastery
	Description = "You analyze the downfalls of others in hopes of finding a better way", --Description of mastery
	GridPosition = Vector( 0, -1, 0 ), --Position offset in the map
	Icon = "wos/advswl/skill_holocron.png",
	RequiredMastery = { 1, }, --Does this require any masteries? If a single mastery is found, it will be purchasable
	Amount = 1,
	OnSpawn = function( ply )
	
	end,
	OnDeath = function( ply )
	
	end,
	OnPurchased = function( ply )
	
	end,
}

MAP.Paths[6] = {
	Name = "Dissonant Voices", --Name of mastery
	Description = "They take you somewhere you can't comprehend", --Description of mastery
	GridPosition = Vector( -1, -1, 0 ), --Position offset in the map
	Icon = "wos/advswl/skill_holocron.png",
	RequiredMastery = { 5, 3 }, --Does this require any masteries? If a single mastery is found, it will be purchasable
	Amount = 1,
	OnSpawn = function( ply )
	
	end,
	OnDeath = function( ply )
	
	end,
	OnPurchased = function( ply )
	
	end,
}

MAP.Paths[7] = {
	Name = "Haunting Enigmas", --Name of mastery
	Description = "You recognize it all, and yet it's unfamiliar", --Description of mastery
	GridPosition = Vector( 1, -1, 0 ), --Position offset in the map
	Icon = "wos/advswl/skill_holocron.png",
	RequiredMastery = { 5, 2  }, --Does this require any masteries? If a single mastery is found, it will be purchasable
	Amount = 1,
	OnSpawn = function( ply )
	
	end,
	OnDeath = function( ply )
	
	end,
	OnPurchased = function( ply )
	
	end,
}

MAP.Paths[8] = {
	Name = "Conjoining Paralysis", --Name of mastery
	Description = "Never ending escape, but without guidance", --Description of mastery
	GridPosition = Vector( 1, 1, 0 ), --Position offset in the map
	Icon = "wos/advswl/skill_holocron.png",
	RequiredMastery = { 4, 2 }, --Does this require any masteries? If a single mastery is found, it will be purchasable
	Amount = 1,
	OnSpawn = function( ply )
	
	end,
	OnDeath = function( ply )
	
	end,
	OnPurchased = function( ply )
	
	end,
}

MAP.Paths[9] = {
	Name = "Decaying Turmoil", --Name of mastery
	Description = "Things become calmer now, you can rest", --Description of mastery
	GridPosition = Vector( -1, 1, 0 ), --Position offset in the map
	Icon = "wos/advswl/skill_holocron.png",
	RequiredMastery = { 4, 3 }, --Does this require any masteries? If a single mastery is found, it will be purchasable
	Amount = 1,
	OnSpawn = function( ply )
	
	end,
	OnDeath = function( ply )
	
	end,
	OnPurchased = function( ply )
	
	end,
}

wOS.ALCS.Prestige:CreatePathConfig( MAP )