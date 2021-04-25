--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2020
	
	Contact: www.wiltostech.com
----------------------------------------]]--

wOS = wOS or {}
wOS.ALCS = wOS.ALCS or {}
wOS.ALCS.Config = wOS.ALCS.Config or {}
wOS.ALCS.Config.Dueling = wOS.ALCS.Config.Dueling or {}

/* 
	Should we use MySQL? If false, we will use local saving
*/
wOS.ALCS.Config.Dueling.ShouldUseMySQL = false


/* 
	Your database credentials. KEEP THIS SAFE! 
	If you don't know what socket is, chances are you don't use it, so just leave it blank!
*/
wOS.ALCS.Config.Dueling.MySQL = wOS.ALCS.Config.Dueling.MySQL or {}
wOS.ALCS.Config.Dueling.MySQL.Host = "localhost"
wOS.ALCS.Config.Dueling.MySQL.Port = 3306
wOS.ALCS.Config.Dueling.MySQL.Username = "root"
wOS.ALCS.Config.Dueling.MySQL.Password = ""
wOS.ALCS.Config.Dueling.MySQL.Database = "wos-dueling"
wOS.ALCS.Config.Dueling.MySQL.Socket = ""


/* 
	What should the default dueling spirit be?
	This is the NAME of the dueling spirit. Make sure it exists!
*/
wOS.ALCS.Config.Dueling.DefaultSpirit = "Spirit of the Duelist"

/* 
	How much Duel Spirit XP should you gain when you win a duel with FIGHTING SPIRIT active?
*/
wOS.ALCS.Config.Dueling.DuelSpiritWinXP = 300

/* 
	How much Duel Spirit XP should you lose when you lose a duel with FIGHTING SPIRIT active?
	KEEP THIS AT A POSITIVE NUMBER!
*/
wOS.ALCS.Config.Dueling.DuelSpiritLoseXP = 50

/* 
	How much Lightsaber Proficiency should you gain when you win a duel with FIGHTING SPIRIT active?
*/
wOS.ALCS.Config.Dueling.DuelSaberProficiencyXP = 500


/* 
	What percentage of passive Skill XP should a dueling spirit get?
	Set it to 0 for none, 1 for 100%
*/
wOS.ALCS.Config.Dueling.SpiritXPPercent = 0.5