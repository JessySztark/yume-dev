--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2020
	
	Contact: www.wiltostech.com
----------------------------------------]]--

wOS = wOS or {}
wOS.ALCS = wOS.ALCS or {}
wOS.ALCS.Config = wOS.ALCS.Config or {}
wOS.ALCS.Config.Prestige = wOS.ALCS.Config.Prestige or {}


/*
	What level should a player be before they can prestige?
	Set this to false if youd just like to use the MAX LEVEL specified in the skill config
	If you set it to false and there is no max level, THIS WILL BREAK
*/
wOS.ALCS.Config.Prestige.PrestigeLevel = false

/*
	How many prestige tokens should people be given when they prestige?
*/
wOS.ALCS.Config.Prestige.TokenPerLevel = 1

/*
	What is the maximum prestige level a player can obtain?
	Set to false for there to be no limit
*/
wOS.ALCS.Config.Prestige.MaxPrestige = false