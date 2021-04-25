--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2020
	
	Contact: www.wiltostech.com
----------------------------------------]]--

wOS = wOS or {}
wOS.ALCS = wOS.ALCS or {}
wOS.ALCS.Config = wOS.ALCS.Config or {}
wOS.ALCS.Config.Prestige = wOS.ALCS.Config.Prestige or {}

--Your MySQL Data ( Fill in if you are using MySQL Database )
--DO NOT GIVE THIS INFORMATION OUT! Malicious users can connect to your database with it
wOS.ALCS.Config.Prestige.Database = wOS.ALCS.Config.Prestige.Database or {}
wOS.ALCS.Config.Prestige.Database.Host = "localhost"
wOS.ALCS.Config.Prestige.Database.Port = 3306
wOS.ALCS.Config.Prestige.Database.Username = "root"
wOS.ALCS.Config.Prestige.Database.Password = ""
wOS.ALCS.Config.Prestige.Database.Database = "wos-prestige"
wOS.ALCS.Config.Prestige.Database.Socket = ""

--Do you want to use MySQL Database to save your data?
--PlayerData ( text files in your data folder ) are a lot less intensive but lock you in on one server
--MySQL Saving lets you sync with many servers that share the database, but has the potential to increase server load due to querying
wOS.ALCS.Config.Prestige.ShouldUseMySQL = false

