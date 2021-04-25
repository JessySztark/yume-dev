--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2020
	
	Contact: www.wiltostech.com
----------------------------------------]]--

wOS = wOS or {}
wOS.ALCS = wOS.ALCS or {}
wOS.ALCS.Config = wOS.ALCS.Config or {}
wOS.ALCS.Config.GTN = wOS.ALCS.Config.GTN or {}

/*
	What amount of money should we take from the poster when they make a listing?
	If you want no tax, set it to 0!
*/
wOS.ALCS.Config.GTN.PostingTax = 5000

/*
	What amount of money should we take from the poster when they want to remove a listing?
	If you want no tax, set it to 0!
*/
wOS.ALCS.Config.GTN.CancelTax = 500

/*
	How many days should a listing be made available for bidding?
	CAN HAVE DECIMALS! EX: 6.5 ( Six and a half days )
	CAN EVEN BE A DECIMAL! EX: 0.5 ( half a day )
*/
wOS.ALCS.Config.GTN.PostingDays = 2

/*
	What is the minimum amount of credits that can be placed as the starting bid when making an auction?
	This will also be the minimum for BUY IT NOW prices
*/
wOS.ALCS.Config.GTN.MinimumStart = 1

/*
	What is the minimum amount of credits that can be placed as the starting bid when making an auction?
*/
wOS.ALCS.Config.GTN.MaximumStart = false

/*
	What is the maximum amount of credits that can be placed as the BUY IT NOW price when making an auction?
*/
wOS.ALCS.Config.GTN.MaximumBuyNow = false