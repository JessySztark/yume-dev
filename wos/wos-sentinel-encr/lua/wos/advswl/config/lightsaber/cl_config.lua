--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2020
	
	Contact: www.wiltostech.com
----------------------------------------]]--

wOS = wOS or {}
wOS.ALCS = wOS.ALCS or {}
wOS.ALCS.Config = wOS.ALCS.Config or {}

/* 
	What Lightsaber HUD do we want to use?
	Options:
		WOS_ALCS.HUD.NEWAGE			--The newest standard. Circle Icons, slot-base, gradients, and more
		WOS_ALCS.HUD.CLASSIC		--Classic Rubat design with box focus
		WOS_ALCS.HUD.FORCEMENU		--Simpler design with force menu for changing force powers
		WOS_ALCS.HUD.HYBRID			--New age slot design with draggable force powers from the force menu for assignment
*/
wOS.ALCS.Config.LightsaberHUD = WOS_ALCS.HUD.FORCEMENU

/* 
	What is the maximum number of force power slots in the hybrid menu?
	MUST USE | 		WOS_ALCS.HUD.HYBRID		| FOR IT TO FUNCTION
*/
wOS.ALCS.Config.MaximumForceSlots = 6

/* 
	Should we enable the stamina mod?
	This will only work for lightsabers!
*/
wOS.ALCS.Config.EnableStamina = true

/* 
	How much stamina should we lose when performing basic or aerial attacks?
	MUST USE | 		wOS.ALCS.Config.EnableStamina		| FOR IT TO FUNCTION	
	Try to keep this below 100
*/
wOS.ALCS.Config.StaminaAttackCost = 10

/* 
	How much stamina should we lose when performing a heavy attack?
	MUST USE | 		wOS.ALCS.Config.EnableStamina		| FOR IT TO FUNCTION
	Try to keep this below 100	
*/
wOS.ALCS.Config.StaminaHeavyCost = 75