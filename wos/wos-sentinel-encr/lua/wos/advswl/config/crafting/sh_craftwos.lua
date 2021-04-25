--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2020
	
	Contact: www.wiltostech.com
----------------------------------------]]--

wOS = wOS or {}
wOS.ALCS = wOS.ALCS or {}
wOS.ALCS.Config = wOS.ALCS.Config or {}
wOS.ALCS.Config.Crafting = wOS.ALCS.Config.Crafting or {}

--How much experience is required for the first level?
--This is an assumption based on my default quadratic increase, but it may have no purpose to you.
wOS.ALCS.Config.Crafting.SaberMinimumExperience = 200

--Create your own leveling formula with this. The default property is a quadratic increase
--( level^2 )*wOS.ALCS.Config.Skills.MinimumExperience*0.5 + level*wOS.ALCS.Config.Skills.MinimumExperience + wOS.ALCS.Config.Skills.MinimumExperience
--This amounts to the ( ax^2 + bx + c ) format of increase
--You can use this to create set amounts per level by returning a table
--If you need help setting this up you'll probably want to ask, but it's just simple math so there's probably tutorials everywhere
wOS.ALCS.Config.Crafting.SaberXPScaleFormula = function( level )
	local required_experience = ( level^2 )*wOS.ALCS.Config.Crafting.SaberMinimumExperience*0.5 + level*wOS.ALCS.Config.Crafting.SaberMinimumExperience + wOS.ALCS.Config.Crafting.SaberMinimumExperience
	return required_experience
end 

--What is the max level for the proficiency system? Set this to FALSE if you want it to go infinitely
wOS.ALCS.Config.Crafting.SaberMaxLevel = 200

--How many proficiency levels will it take before the saber gets another misc slot?
wOS.ALCS.Config.Crafting.LevelPerSlot = 1

wOS.ALCS.Config.Crafting.DefaultPersonalSaber = {}
wOS.ALCS.Config.Crafting.DefaultPersonalSaber.UseHilt = "models/sgg/starwars/weapons/w_common_jedi_saber_hilt.mdl"
wOS.ALCS.Config.Crafting.DefaultPersonalSaber.UseLength = 32
wOS.ALCS.Config.Crafting.DefaultPersonalSaber.UseWidth = 2
wOS.ALCS.Config.Crafting.DefaultPersonalSaber.UseColor = Color( 255, 0, 0 )
wOS.ALCS.Config.Crafting.DefaultPersonalSaber.UseDarkInner  = 0
wOS.ALCS.Config.Crafting.DefaultPersonalSaber.SaberDamage  = 50
wOS.ALCS.Config.Crafting.DefaultPersonalSaber.SaberBurnDamage  = 5
wOS.ALCS.Config.Crafting.DefaultPersonalSaber.UseInnerColor  = color_white
wOS.ALCS.Config.Crafting.DefaultPersonalSaber.UseSwingSound = "lightsaber/saber_swing1.wav" 
wOS.ALCS.Config.Crafting.DefaultPersonalSaber.UseLoopSound = "lightsaber/saber_loop1.wav"
wOS.ALCS.Config.Crafting.DefaultPersonalSaber.UseOnSound = "lightsaber/saber_on1.wav"
wOS.ALCS.Config.Crafting.DefaultPersonalSaber.UseOffSound = "lightsaber/saber_off1.wav"

-- YOU CAN SET CUSTOM SETTINGS FOR THE PERSONAL LIGHTSABER HERE, SUCH AS A DEFAULT CRYSTAL TYPE
wOS.ALCS.Config.Crafting.DefaultPersonalSaber.CustomSettings = {}

-- THESE ARE DEFAULT FORMS FOR THE PERSONAL LIGHTSABER. SET THIS TO FALSE IF YOU WANT IT TO HAVE NOTHING
wOS.ALCS.Config.Crafting.DefaultPersonalSaber.UseForms = { 
	[ "Defensive" ] = { 1 }
}

wOS.ALCS.Config.Crafting.DefaultSecPersonalSaber = {}
wOS.ALCS.Config.Crafting.DefaultSecPersonalSaber.UseHilt = "models/sgg/starwars/weapons/w_common_jedi_saber_hilt.mdl"
wOS.ALCS.Config.Crafting.DefaultSecPersonalSaber.UseLength = 32
wOS.ALCS.Config.Crafting.DefaultSecPersonalSaber.UseWidth = 2
wOS.ALCS.Config.Crafting.DefaultSecPersonalSaber.UseColor = Color( 255, 0, 0 )
wOS.ALCS.Config.Crafting.DefaultSecPersonalSaber.UseDarkInner  = 0
wOS.ALCS.Config.Crafting.DefaultSecPersonalSaber.UseInnerColor  = color_white
wOS.ALCS.Config.Crafting.DefaultSecPersonalSaber.SaberDamage  = 50
wOS.ALCS.Config.Crafting.DefaultSecPersonalSaber.SaberBurnDamage  = 5
wOS.ALCS.Config.Crafting.DefaultSecPersonalSaber.CustomSettings = {}


wOS.ALCS.Config.Crafting.MaxInventorySlots = 40

--Where is the crafting camera located? ( VECTOR POSITION )
wOS.ALCS.Config.Crafting.CraftingCamLocation = Vector( -9999, -9999, -9999 )