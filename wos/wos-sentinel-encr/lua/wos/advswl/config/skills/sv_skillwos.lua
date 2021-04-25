--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2020
	
	Contact: www.wiltostech.com
----------------------------------------]]--

wOS = wOS or {}
wOS.ALCS = wOS.ALCS or {}
wOS.ALCS.Config = wOS.ALCS.Config or {}
wOS.ALCS.Config.Skills = wOS.ALCS.Config.Skills or {}

wOS.ALCS.Config.Skills.ExperienceTable = {}

--Your MySQL Data ( Fill in if you are using MySQL Database )
--DO NOT GIVE THIS INFORMATION OUT! Malicious users can connect to your database with it
wOS.ALCS.Config.Skills.SkillDatabase = wOS.ALCS.Config.Skills.SkillDatabase or {}
wOS.ALCS.Config.Skills.SkillDatabase.Host = "localhost"
wOS.ALCS.Config.Skills.SkillDatabase.Port = 3306
wOS.ALCS.Config.Skills.SkillDatabase.Username = "root"
wOS.ALCS.Config.Skills.SkillDatabase.Password = ""
wOS.ALCS.Config.Skills.SkillDatabase.Database = "wos-skilltree"
wOS.ALCS.Config.Skills.SkillDatabase.Socket = ""


--How often do you want to save player progression ( in seconds )
wOS.ALCS.Config.Skills.SkillDatabase.SaveFrequency = 360

--Do you want to use MySQL Database to save your data?
--PlayerData ( text files in your data folder ) are a lot less intensive but lock you in on one server
--MySQL Saving lets you sync with many servers that share the database, but has the potential to increase server load due to querying
wOS.ALCS.Config.Skills.ShouldSkillUseMySQL = false

--Should XP gained from Vrondrakis also be used for the skill point system?
wOS.ALCS.Config.Skills.VrondrakisSync = false

--How many levels do you need to progress in order to get skill points?
wOS.ALCS.Config.Skills.LevelsPerSkillPoint = 1

--How many skill points do you get when you achieve those levels above?
wOS.ALCS.Config.Skills.SkillPointPerLevel = 1

--How long before we award free xp just for playing? ( set this to false if you don't want to do this )
wOS.ALCS.Config.Skills.TimeBetweenXP = 360

--Should we award skill points based on level when they reset, or how much they spent currently?
wOS.ALCS.Config.Skills.ResetBasedOnLevel = true

--[[
	Distribute the XP per usergroup here. The additions may be subject to change
	but the general format is:
	
	wOS.ALCS.Config.Skills.ExperienceTable[ "USERGROUP" ] = {
			Meditation = XP Per meditation tick ( every 3 seconds ),
			PlayerKill = XP for killing another player,
			NPCKill = XP for killing an NPC,
			XPPerInt = The XP gained from the playing internval above,
	}	
		
]]--

--Default is the DEFAULT xp awarded if they aren't getting special XP. Only change the numbers for this one!
wOS.ALCS.Config.Skills.ExperienceTable[ "Default" ] = {
		Meditation = 0,
		PlayerKill = 50,
		NPCKill = 0,
		XPPerInt = 100,
		XPPerHeal = 0,
}

wOS.ALCS.Config.Skills.ExperienceTable[ "VIP" ] = {
		Meditation = 0,
		PlayerKill = 100,
		NPCKill = 0,
		XPPerInt = 200,
		XPPerHeal = 0,
}
wOS.ALCS.Config.Skills.ExperienceTable[ "Animateur VIP" ] = {
	Meditation = 0,
	PlayerKill = 100,
	NPCKill = 0,
	XPPerInt = 200,
	XPPerHeal = 0,
}
wOS.ALCS.Config.Skills.ExperienceTable[ "Helpeur VIP" ] = {
	Meditation = 0,
	PlayerKill = 100,
	NPCKill = 0,
	XPPerInt = 200,
	XPPerHeal = 0,
}
wOS.ALCS.Config.Skills.ExperienceTable[ "Modérateur VIP" ] = {
	Meditation = 0,
	PlayerKill = 100,
	NPCKill = 0,
	XPPerInt = 200,
	XPPerHeal = 0,
}
wOS.ALCS.Config.Skills.ExperienceTable[ "Administrateur VIP" ] = {
	Meditation = 0,
	PlayerKill = 100,
	NPCKill = 0,
	XPPerInt = 200,
	XPPerHeal = 0,
}





