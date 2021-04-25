--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2020
	
	Contact: www.wiltostech.com
		----------------------------------------]]--

wOS = wOS or {}
wOS.ALCS = wOS.ALCS or {}
wOS.ALCS.Prestige = wOS.ALCS.Prestige or {}

function wOS.ALCS.Prestige:CanEquipPrestige( mastery )
	if not mastery then return end
	local dat = wOS.ALCS.Prestige.MapData.Paths[ mastery ]
	if not dat then return end
	if dat.RequiredMastery and #dat.RequiredMastery  > 0 then
		for _, mast in ipairs( dat.RequiredMastery ) do
			if wOS.ALCS.Prestige.Data.Mastery[ mast ] then
				return true
			end
		end
	else
		return true
	end
	return false
end