--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2020
	
	Contact: www.wiltostech.com
----------------------------------------]]--

wOS = wOS or {}
wOS.ALCS = wOS.ALCS or {}
wOS.ALCS.Config = wOS.ALCS.Config or {}
wOS.ALCS.Config.Dueling = wOS.ALCS.Config.Dueling or {}

/* 
	How much sacrifice energy must be gained from items before a spirit can be rolled?
*/
wOS.ALCS.Config.Dueling.SacrificeRoll = false

/* 
	How long should duel requests last before they are expired and cycled?
*/
wOS.ALCS.Config.Dueling.DuelExpirationTime = 10

/* 
	How far away does a player have to be from a dueling station in order be considered ready for dueling?
	Set to FALSE for infinite distance
*/
wOS.ALCS.Config.Dueling.StationDistance = 450