--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2020
	
	Contact: www.wiltostech.com
----------------------------------------]]--

wOS = wOS or {}
wOS.ALCS = wOS.ALCS or {}
wOS.ALCS.Config = wOS.ALCS.Config or {}
wOS.ALCS.Config.Skills = wOS.ALCS.Config.Skills or {}

/* 
	What skill tree schema do you want to use?
	Options:
		WOS_ALCS.SKILLMENU.NEWAGE		--The UI introduced by the Dark Ascension update, 3D and with all the new features
		WOS_ALCS.SKILLMENU.CLASSIC	--The UI everyone has come to know and love, and in 2D. May not work with newer features
*/
wOS.ALCS.Config.Skills.MenuSchema = WOS_ALCS.SKILLMENU.NEWAGE

--How much experience is required for the first level?
--This is an assumption based on my default quadratic increase, but it may have no purpose to you.
wOS.ALCS.Config.Skills.MinimumExperience = 200

--Create your own leveling formula with this. The default property is a quadratic increase
--( level^2 )*wOS.ALCS.Config.Skills.MinimumExperience*0.5 + level*wOS.ALCS.Config.Skills.MinimumExperience + wOS.ALCS.Config.Skills.MinimumExperience
--This amounts to the ( ax^2 + bx + c ) format of increase
--You can use this to create set amounts per level by returning a table
--If you need help setting this up you'll probably want to ask, but it's just simple math so there's probably tutorials everywhere
wOS.ALCS.Config.Skills.XPScaleFormula = function( level )
	local required_experience = ( level^2 )*wOS.ALCS.Config.Skills.MinimumExperience*0.5 + level*wOS.ALCS.Config.Skills.MinimumExperience + wOS.ALCS.Config.Skills.MinimumExperience
	return required_experience
end 

--What is the max level for the Skill Leveling? Set this to FALSE if you want it to go infinitely
wOS.ALCS.Config.Skills.SkillMaxLevel = 200

--Should we be able to see the Combat Level and XP on the HUD?
wOS.ALCS.Config.Skills.MountLevelToHUD = true

--Should we be able to see the combat level of other players above their head?
wOS.ALCS.Config.Skills.MountLevelToPlayer = false