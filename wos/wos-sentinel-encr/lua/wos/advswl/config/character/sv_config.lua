--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2020
	
	Contact: www.wiltostech.com
----------------------------------------]]--

wOS = wOS or {}
wOS.ALCS = wOS.ALCS or {}
wOS.ALCS.Config = wOS.ALCS.Config or {}
wOS.ALCS.Config.Character = wOS.ALCS.Config.Character or {}

/* 
	Should grip preferences require any skills before setting the grip on the player?
	If set to TRUE, grip preference will automatically take effect once the lightsaber is re-ignited
*/
wOS.ALCS.Config.Character.FreeGripChoice = false

/* 
	Should wielding preferences require any skills before setting the wield on the player?
	If set to TRUE, player can alternate between dual and single wield without a skill enabling it
*/
wOS.ALCS.Config.Character.FreeWieldChoice = false

/* 
	Should reverse grip angles do a full turn or a realistic turn?
	If set to TRUE, players hand will be turned exactly 180 degrees. 
	This will make some model hands look weird but is more practical. If you have models missing some bones you should set this false
*/
wOS.ALCS.Config.Character.FullReverseAngle = true


/* 
	Should we use MySQL? If false, we will use local saving
*/
wOS.ALCS.Config.Character.ShouldUseMySQL = false

/* 
	Your database credentials. KEEP THIS SAFE! 
	If you don't know what socket is, chances are you don't use it, so just leave it blank!
*/
wOS.ALCS.Config.Character.MySQL = wOS.ALCS.Config.Character.MySQL or {}
wOS.ALCS.Config.Character.MySQL.Host = "localhost"
wOS.ALCS.Config.Character.MySQL.Port = 3306
wOS.ALCS.Config.Character.MySQL.Username = "root"
wOS.ALCS.Config.Character.MySQL.Password = ""
wOS.ALCS.Config.Character.MySQL.Database = "wos-alcs-character"
wOS.ALCS.Config.Character.MySQL.Socket = ""