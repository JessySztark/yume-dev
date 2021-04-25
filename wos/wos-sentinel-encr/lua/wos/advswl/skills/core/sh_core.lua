--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2020
	
	Contact: www.wiltostech.com
		----------------------------------------]]--








































































wOS = wOS or {}
																																																																																																																																																						

local meta = FindMetaTable( "Player" )

----GET FUNCTIONS

function meta:GetSkillPoints()
	return self:GetNW2Int( "wOS.SkillPoints", 0 )
end

function meta:GetSkillLevel()
	return self:GetNW2Int( "wOS.SkillLevel", 0 )
end

function meta:GetSkillXP()
	return self:GetNW2Int( "wOS.SkillExperience", 0 )
end

function meta:GetSkillRequiredXP()
	local level = self:GetSkillLevel()
	return wOS.ALCS.Config.Skills.XPScaleFormula( level )
end

function meta:HasSkillEquipped( tree, tier, skill )

	if not self.EquippedSkills[ name ] then return false end
	if not self.EquippedSkills[ name ][ tier ] then return false end
	
	return self.EquippedSkills[ name ][ tier ][ skill ]
	
end

function meta:CanEquipSkill( tree, tier, skill )

	local skilldata = wOS.SkillTrees[ name ][ tier ][ skill ]
	
	if not skilldata then return false end
	
	if table.Count( skilldata.Requirements ) < 1 then return true end
	
	for num, skills in pairs( skilldata.Requirements ) do
		if not self:HasSkillEquipped( tree, skills[1], skills[2] ) then return false end
	end
	
	if self:GetSkillPoints() < skilldata.PointsRequired then return false end
	
	return true
	
end