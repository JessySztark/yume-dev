--[[-------------------------------------------------------------------
	Advanced Combat System Raw Materials:
		The basic materials needed for crafting
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


wOS:RegisterItem( {
	Name = "Refined Steel",
	Description = "Raw Material",
	Type = WOSTYPE.RAWMATERIAL,
	Rarity = 35,
	Model = "models/gangwars/crafting/ingot.mdl",
} )

wOS:RegisterItem( {
	Name = "Glass",
	Description = "Raw Material",
	Type = WOSTYPE.RAWMATERIAL,
	Rarity = 60,
	Model = "models/gibs/glass_shard03.mdl",
} )

wOS:RegisterItem( {
	Name = "Aluminum Alloy",
	Description = "Raw Material",
	Type = WOSTYPE.RAWMATERIAL,
	Rarity = 100,
	Model = "models/gibs/metal_gib4.mdl",
} )