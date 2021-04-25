--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2020
	
	Contact: www.wiltostech.com
----------------------------------------]]--

wOS = wOS or {}
wOS.ALCS = wOS.ALCS or {}
wOS.ALCS.Config = wOS.ALCS.Config or {}
wOS.ALCS.Config.ExecSys = wOS.ALCS.Config.ExecSys or {}



/*
	Should all kills made by a lightsaber perform the SLICING animation?
	WARNING: THIS SHIT IS BAD ASS, BUT IT MAY DROP PERFORMANCE DUE TO THE GORE. YOU HAVE BEEN WARNED
*/
wOS.ALCS.Config.ExecSys.AlwaysSlice = false

/*
	Should we perform the players execution ( IF AVAILABLE ) on killing blows instead of just killing them?
	Ruins combat flow but once again: bad ass
*/
wOS.ALCS.Config.ExecSys.FinalBlowExecutions = false