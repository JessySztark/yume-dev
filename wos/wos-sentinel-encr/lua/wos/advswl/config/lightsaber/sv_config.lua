--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2020
	
	Contact: www.wiltostech.com
----------------------------------------]]--

wOS = wOS or {}
wOS.ALCS = wOS.ALCS or {}
wOS.ALCS.Config = wOS.ALCS.Config or {}

/* 
	What Lightsaber Trace schema do you want to use?
	Options:
		WOS_ALCS.TRACE.CLASSIC		--Classic Rubat traces. Never stops tracing
		WOS_ALCS.TRACE.MINIMAL		--Traces only occur when swinging/attacking, good for performance but removes burn damage and scorch
		WOS_ALCS.TRACE.INTERP		--Trace travels path of lightsaber. Useful for precision but a little more intensive
		WOS_ALCS.TRACE.MINIMALINTERP		--Same as INTERP, but following MINIMAL rules. Precision with a slightly reduced load
*/
wOS.ALCS.Config.LightsaberTrace = WOS_ALCS.TRACE.MINIMAL

/*
	How far away can we lock onto targets with the Force Lock On ( IN UNITS )
*/
wOS.ALCS.Config.LightsaberLockOnDistance = 850

/*
	How far away can we be until the lock on breaks? ( IN SQUARE UNITS )
	SQAURE MEANS SQUARE THE NUMBER
	Example: 
		50 UNITS = 2500 SQUARE UNITS
*/
wOS.ALCS.Config.LightsaberLockOnBreakSquare = 800000

/*
	How long should a parry stun the victim? IN SECONDS
*/
wOS.ALCS.Config.LightsaberParryStun = 1