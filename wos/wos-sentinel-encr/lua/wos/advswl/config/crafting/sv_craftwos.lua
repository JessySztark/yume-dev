--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2020
	
	Contact: www.wiltostech.com
----------------------------------------]]--

wOS = wOS or {}
wOS.ALCS = wOS.ALCS or {}
wOS.ALCS.Config = wOS.ALCS.Config or {}
wOS.ALCS.Config.Crafting = wOS.ALCS.Config.Crafting or {}


--Your MySQL Data ( Fill in if you are using MySQL Database )
--DO NOT GIVE THIS INFORMATION OUT! Malicious users can connect to your database with it
wOS.ALCS.Config.Crafting.CraftingDatabase = wOS.ALCS.Config.Crafting.CraftingDatabase or {}
wOS.ALCS.Config.Crafting.CraftingDatabase.Host = "localhost"
wOS.ALCS.Config.Crafting.CraftingDatabase.Port = 3306
wOS.ALCS.Config.Crafting.CraftingDatabase.Username = "root"
wOS.ALCS.Config.Crafting.CraftingDatabase.Password = ""
wOS.ALCS.Config.Crafting.CraftingDatabase.Database = "wos-crafting"
wOS.ALCS.Config.Crafting.CraftingDatabase.Socket = ""


--How often do you want to save player crafting ( in seconds )
wOS.ALCS.Config.Crafting.CraftingDatabase.SaveFrequency = 360

--Do you want to use MySQL Database to save your data?
--PlayerData ( text files in your data folder ) are a lot less intensive but lock you in on one server
--MySQL Saving lets you sync with many servers that share the database, but has the potential to increase server load due to querying
wOS.ALCS.Config.Crafting.ShouldCraftingUseMySQL = false

--How long should we wait before doing a respawn wave of items? ( seconds )
wOS.ALCS.Config.Crafting.ItemSpawnFrequency = 0.1

--How much of the lootspawns should be active? ( 0 to 1 )
wOS.ALCS.Config.Crafting.LootSpawnPercent = 1

--How long should it take before the items despawn? ( seconds )
wOS.ALCS.Config.Crafting.ItemDespawnTime = 600

wOS.ALCS.Config.Crafting.SaberExperienceTable = {}

wOS.ALCS.Config.Crafting.SaberExperienceTable[ "Default" ] = {
		PlayerKill = 20,
		NPCKill = 0,
}

wOS.ALCS.Config.Crafting.SaberExperienceTable[ "vip" ] = {
		PlayerKill = 40,
		NPCKill = 0,
}


