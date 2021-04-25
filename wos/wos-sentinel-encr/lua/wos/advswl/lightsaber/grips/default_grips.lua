--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2020
	
	Contact: www.wiltostech.com
		----------------------------------------]]--








































































wOS.ALCS.LightsaberBase:AddGrip({
	Name = "Standard",
	Type = WOS_ALCS.GRIP.BOTH,
	Ignite = function( wep )
	end,
	UnIgnite = function( wep )
	end,
})

wOS.ALCS.LightsaberBase:AddGrip({
	Name = "Reverse Blade ( Right )",
	Type = WOS_ALCS.GRIP.RIGHT,
	Ignite = function( wep )
		local bone2 = wep.Owner:LookupBone( "ValveBiped.Bip01_R_Hand" )
		if not bone2 then return end
		if !wOS.ALCS.Config.Character.FullReverseAngle then
			wep.Owner:ManipulateBoneAngles( bone2, Angle( 0, 0, -80 ) )
			wep.Owner:ManipulateBoneAngles( bone2 - 1, Angle( 0, 20, -40 ) )
			wep.Owner:ManipulateBoneAngles( bone2 - 2, Angle( 0, -20, -20 ) )
		else
			wep.Owner:ManipulateBoneAngles( bone2, Angle( 0, 0, -180 ) )	
		end
	end,
	UnIgnite = function( wep )
		local bone2 = wep.Owner:LookupBone( "ValveBiped.Bip01_R_Hand" )
		if not bone2 then return end
		for i=0, 2 do
			wep.Owner:ManipulateBoneAngles( bone2 - i, Angle( 0, 0, 0 ) )
		end	
	end,
})

wOS.ALCS.LightsaberBase:AddGrip({
	Name = "Reverse Blade ( Left )",
	Type = WOS_ALCS.GRIP.LEFT,
	Ignite = function( wep )
		local bone2 = wep.Owner:LookupBone( "ValveBiped.Bip01_L_Hand" )
		if not bone2 then return end
		if !wOS.ALCS.Config.Character.FullReverseAngle then
			wep.Owner:ManipulateBoneAngles( bone2, Angle( 0, 0, -80 ) )
			wep.Owner:ManipulateBoneAngles( bone2 - 1, Angle( 0, 20, -40 ) )
			wep.Owner:ManipulateBoneAngles( bone2 - 2, Angle( 0, -20, -20 ) )
		else
			wep.Owner:ManipulateBoneAngles( bone2, Angle( 0, 0, -180 ) )	
		end
	end,
	UnIgnite = function( wep )
		local bone2 = wep.Owner:LookupBone( "ValveBiped.Bip01_L_Hand" )
		if not bone2 then return end
		for i=0, 2 do
			wep.Owner:ManipulateBoneAngles( bone2 - i, Angle( 0, 0, 0 ) )
		end	
	end,
})

wOS.ALCS.LightsaberBase:AddGrip({
	Name = "Reverse Blade ( Both )",
	Type = WOS_ALCS.GRIP.BOTH,
	Ignite = function( wep )
		local bone2 = wep.Owner:LookupBone( "ValveBiped.Bip01_L_Hand" )
		if bone2 then 
			if !wOS.ALCS.Config.Character.FullReverseAngle then
				wep.Owner:ManipulateBoneAngles( bone2, Angle( 0, 0, -80 ) )
				wep.Owner:ManipulateBoneAngles( bone2 - 1, Angle( 0, 20, -40 ) )
				wep.Owner:ManipulateBoneAngles( bone2 - 2, Angle( 0, -20, -20 ) )
			else
				wep.Owner:ManipulateBoneAngles( bone2, Angle( 0, 0, -180 ) )	
			end
		end
		
		bone2 = wep.Owner:LookupBone( "ValveBiped.Bip01_R_Hand" )
		if not bone2 then return end
		if !wOS.ALCS.Config.Character.FullReverseAngle then
			wep.Owner:ManipulateBoneAngles( bone2, Angle( 0, 0, -80 ) )
			wep.Owner:ManipulateBoneAngles( bone2 - 1, Angle( 0, 20, -40 ) )
			wep.Owner:ManipulateBoneAngles( bone2 - 2, Angle( 0, -20, -20 ) )
		else
			wep.Owner:ManipulateBoneAngles( bone2, Angle( 0, 0, -180 ) )	
		end
		
	end,
	UnIgnite = function( wep )
		local bone2 = wep.Owner:LookupBone( "ValveBiped.Bip01_L_Hand" )
		if bone2 then 
			for i=0, 2 do
				wep.Owner:ManipulateBoneAngles( bone2 - i, Angle( 0, 0, 0 ) )
			end	
		end
		bone2 = wep.Owner:LookupBone( "ValveBiped.Bip01_R_Hand" )
		if not bone2 then return end
		for i=0, 2 do
			wep.Owner:ManipulateBoneAngles( bone2 - i, Angle( 0, 0, 0 ) )
		end	
	end,
})