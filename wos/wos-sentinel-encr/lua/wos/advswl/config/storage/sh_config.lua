--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2020
	
	Contact: www.wiltostech.com
----------------------------------------]]--

wOS = wOS or {}
wOS.ALCS = wOS.ALCS or {}
wOS.ALCS.Config = wOS.ALCS.Config or {}
wOS.ALCS.Config.Storage = wOS.ALCS.Config.Storage or {}

--[[
	What is the default amount of space someone should have when they first join?
]]--
wOS.ALCS.Config.Storage.StartingSpace = 20

--[[
	How much should it cost to upgrade your storage space?
]]--
wOS.ALCS.Config.Storage.ExpansionCost = 30000
end 

--[[
	How much slots should be given to the player when they purchase an expansion?
]]--
wOS.ALCS.Config.Storage.ExpansionAmount = 10

--[[
	What is the maximum amount of space someone should be able to upgrade their storage space to?
	Note that this is maximum PURCHASED upgrade size.
	You can still set the storage space over this through other means.
	
	Example: 
	wOS.ALCS.Config.Storage.MaxInventorySlots = 100
	
	Set this to false for no limit:
	wOS.ALCS.Config.Storage.MaxInventorySlots = false
]]--
wOS.ALCS.Config.Storage.MaxInventorySlots = 100