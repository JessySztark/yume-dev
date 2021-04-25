--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2020
	
	Contact: www.wiltostech.com
		----------------------------------------]]--








































































wOS.ALCS.LightsaberBase:AddBind({
	Name = "Form Menu",
	Binds = { IN_USE, IN_RELOAD },
	Func = function( wep )
		net.Start( "wOS.ALCS.OpenFormMenu" )
			net.WriteBool( wep.IsDualLightsaber )
		net.Send( wep.Owner )
	end,
})

wOS.ALCS.LightsaberBase:AddBind({
	Name = "Devestator Menu",
	Binds = { IN_WALK, IN_RELOAD },
	Func = function( wep )
		net.Start( "wOS.ALCS.OpenDevestatorMenu" )
		net.Send( wep.Owner )
	end,
})

wOS.ALCS.LightsaberBase:AddBind({
	Name = "Change Stance",
	Binds = { IN_ATTACK, IN_USE },
	Func = function( wep )
		wep:ChangeStance()
	end,
})

wOS.ALCS.LightsaberBase:AddBind({
	Name = "Ignite / Extinguish",
	Binds = { IN_RELOAD },
	Func = function( wep )
		if ( wep:WaterLevel() > 2 && !wep:GetWorksUnderwater() ) then return end
		wep:SetEnabled( !wep:GetEnabled() )
	end,
})

wOS.ALCS.LightsaberBase:AddBind({
	Name = "Force Lock-On",
	Binds = { IN_WALK, IN_USE },
	Func = function( wep )
		wep:UseForceLockon()
	end,
})

--E + Right Click
--E + F
--ALT + E