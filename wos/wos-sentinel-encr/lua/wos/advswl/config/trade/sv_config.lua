--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2020
	
	Contact: www.wiltostech.com
----------------------------------------]]--

wOS = wOS or {}
wOS.ALCS = wOS.ALCS or {}
wOS.ALCS.Config = wOS.ALCS.Config or {}
wOS.ALCS.Config.GTN = wOS.ALCS.Config.GTN or {}

--Your MySQL Data ( Fill in if you are using MySQL Database )
--DO NOT GIVE THIS INFORMATION OUT! Malicious users can connect to your database with it
wOS.ALCS.Config.GTN.Database = wOS.ALCS.Config.GTN.Database or {}
wOS.ALCS.Config.GTN.Database.Host = "localhost"
wOS.ALCS.Config.GTN.Database.Port = 3306
wOS.ALCS.Config.GTN.Database.Username = "root"
wOS.ALCS.Config.GTN.Database.Password = ""
wOS.ALCS.Config.GTN.Database.Database = "wos-trade-network"
wOS.ALCS.Config.GTN.Database.Socket = ""

/*
	Do you want to use MySQL Database to save your data?
	
	- SQLite is used for local saving ( your sv.db file ) and all performance hits will be contained on the server
	- MySQL Saving lets you sync with many servers that share the database, but has the potential to increase network load due to querying
*/
wOS.ALCS.Config.GTN.ShouldUseMySQL = false

/*
	How often should the database check for expirations on auctions? IN MINUTES
	THIS SETTING ONLY AFFECTS NON-MYSQL
*/
wOS.ALCS.Config.GTN.AuctionCheckRate = 10

/*
	How often should the server check if a player has any new stock available? IN SECONDS
	Set this to FALSE for stock updates to only occur during BUY IT NOW sales, TRADES, CANCELLATIONS, and SERVER CONNECTS
*/
wOS.ALCS.Config.GTN.StockCheckRate = false

