--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2020
	
	Contact: www.wiltostech.com
----------------------------------------]]--

wOS = wOS or {}
wOS.ALCS = wOS.ALCS or {}
wOS.ALCS.Config = wOS.ALCS.Config or {}

--Which usergroups can access the admin menu?
-- Format: [ "USERGROUP" ] = true,
-- DO NOT FORGET THE COMMA!!!
wOS.ALCS.Config.CanAccessAdminMenu = {
	["Gérant"] = true,
	["Administrateur VIP"] = true,
	["Administrateur"] = true,
	["developpeur"] = true,
}