--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2020
	
	Contact: www.wiltostech.com
		----------------------------------------]]--








































































wOS = wOS or {}
																																																																																																																																																						

local meta = FindMetaTable( "Player" )

----GET FUNCTIONS

function meta:GetSaberLevel()
	return self:GetNW2Int( "wOS.ProficiencyLevel", 0 )
end

function meta:GetSaberXP()
	return self:GetNW2Int( "wOS.ProficiencyExperience", 0 )
end

function meta:GetSaberRequiredXP()
	local level = self:GetSaberLevel()
	return wOS.ALCS.Config.Crafting.SaberXPScaleFormula( level )
end

function wOS:GetSaberItemInInventory( inventory, item )

	for slot, dat in pairs( inventory ) do
		local name = dat
		local amount = 1
		if istable( dat ) then
			name = dat.Name
			amount = dat.Amount or 1
		end
		if name == item and amount > 0 then
			return slot
		end
	end
	
	return false
	
end