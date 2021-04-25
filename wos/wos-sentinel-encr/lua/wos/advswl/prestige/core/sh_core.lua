--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2020
	
	Contact: www.wiltostech.com
		----------------------------------------]]--

wOS = wOS or {}
wOS.ALCS = wOS.ALCS or {}
wOS.ALCS.Prestige = wOS.ALCS.Prestige or {}

local meta = FindMetaTable( "Player" )

function meta:WOS_GetSkillPrestigeLevel()
	return self:GetNW2Int( "wOS.ALCS.Prestige.Level", 0 )
end

function meta:WOS_GetSkillPrestigeIcon()
	return self:GetNW2String( "wOS.ALCS.Prestige.Icon", "" )
end