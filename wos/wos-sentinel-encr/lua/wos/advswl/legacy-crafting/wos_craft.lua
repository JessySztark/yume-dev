--[[-------------------------------------------------------------------
	Legacy Lightsaber Crafting System:
		If you build it, Sith will come
			Powered by
						  _ _ _    ___  ____  
				__      _(_) | |_ / _ \/ ___| 
				\ \ /\ / / | | __| | | \___ \ 
				 \ V  V /| | | |_| |_| |___) |
				  \_/\_/ |_|_|\__|\___/|____/ 
											  
 _____         _                 _             _           
|_   _|__  ___| |__  _ __   ___ | | ___   __ _(_) ___  ___ 
  | |/ _ \/ __| '_ \| '_ \ / _ \| |/ _ \ / _` | |/ _ \/ __|
  | |  __/ (__| | | | | | | (_) | | (_) | (_| | |  __/\__ \
  |_|\___|\___|_| |_|_| |_|\___/|_|\___/ \__, |_|\___||___/
                                         |___/             
----------------------------- Copyright 2019, David "King David" Wiltos ]]--[[
							  
	Lua Developer: King David
	Contact: http://steamcommunity.com/groups/wiltostech
		
-- Copyright 2019, David "King David" Wiltos ]]--

wOS = wOS or {}
wOS.ALCS = wOS.ALCS or {}
wOS.ALCS.Legacy = wOS.ALCS.Legacy or {}

language.Add( "wos_l_primary_saber", "PRIMARY" )
language.Add( "wos_l_secondary_saber", "SECONDARY" )
language.Add( "wos_l_primary_blade", "Primary Blade" )
language.Add( "wos_l_secondary_blade", "Secondary Blade" )
language.Add( "wos_l_dual_saber", "DUAL" )
language.Add( "wos_l_option_hilt", "Hilt" )
language.Add( "wos_l_option_color", "Crystal" )
language.Add( "wos_l_option_blade", "Blade" )
language.Add( "wos_l_option_misc", "Energizers" )
language.Add( "wos_l_advert_wiltos", "Powered by wiltOS Technologies" )
language.Add( "wos_l_select_primaryhilt", "Set as Primary Hilt" )
language.Add( "wos_l_select_secondaryhilt", "Set as Secondary Hilt" )
language.Add( "wos_l_info_bladel", "Blade Length:" )
language.Add( "wos_l_info_bladew", "Blade Width:" )
language.Add( "wos_l_info_dark", "Dark Inner Blade" )
language.Add( "wos_l_info_primcrystal", "Primary Crystal" )
language.Add( "wos_l_info_seccrystal", "Secondary Crystal" )
language.Add( "wos_l_info_igniter", "Crystal Activator:" )
language.Add( "wos_l_info_humsound", "Idle Regulator:" )
language.Add( "wos_l_info_swingsound", "Power Vortex Regulator:" )

local w,h = ScrW(), ScrH()

function wOS.ALCS.Legacy:OpenSaberCrafting()

	if self.SaberStation then return end
	gui.EnableScreenClicker( true )

	self.SaberStation = vgui.Create( "DPanel" )
	self.SaberStation:SetSize( w*0.5, h*0.5 )
	self.SaberStation:Center()
	self.SaberStation.Paint = function( pan, ww, hh )
		draw.RoundedBox( 3, 0, 0, ww, hh, Color( 25, 25, 25, 245 ) )
	end 
	self.SaberStation.CurrentButton = language.GetPhrase( "wos_l_option_hilt" )
	
	local fw, fh = self.SaberStation:GetSize()
	
	local button = vgui.Create( "DButton", self.SaberStation )
	button:SetSize( fw*0.04, fh*0.05 )
	button:SetPos( fw*0.95, fh*0.01 )
	button:SetText( "" )
	button.Paint = function( pan, ww, hh )
		surface.SetDrawColor( Color( 255, 0, 0, 255 ) )
		surface.DrawLine( 0, 0, ww, hh )
		surface.DrawLine( 0, hh, ww, 0 )
	end
	button.DoClick = function()
		self.SaberStation:Remove()
		self.SaberStation = nil
		gui.EnableScreenClicker( false )
	end
	
	local button1 = vgui.Create( "DButton", self.SaberStation )
	button1:SetSize( fw, fh*0.1 )
	button1:SetPos( 0, fh*0.9 )
	button1:SetText( "" )
	button1.Paint = function( pan, ww, hh )
		if pan:IsHovered() then
			draw.SimpleText( language.GetPhrase( "wos_l_advert_wiltos" ), "Trebuchet24", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )		
		else
			draw.SimpleText( language.GetPhrase( "wos_l_advert_wiltos" ), "Trebuchet24", ww/2, hh/2, Color( 75, 75, 75, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
	end
	button1.DoClick = function()
		gui.OpenURL( "https://www.wiltostech.com" )
	end	
	
	local hiltbutt = vgui.Create( "DButton", self.SaberStation )
	hiltbutt:SetSize( fw*0.2, fh*0.05 )
	hiltbutt:SetPos( fw*0.055, fh*0.01 )
	hiltbutt:SetText( "" )
	hiltbutt.Paint = function( pan, ww, hh )
		local col = ( wOS.ALCS.Legacy.SaberStation.CurrentButton == "Hilt" and Color( 175, 175, 175, 255 ) ) or Color( 88, 88, 88, 255 )
		draw.RoundedBox( 5, 0, 0, ww, hh, col )
		draw.SimpleText( language.GetPhrase( "wos_l_option_hilt" ), "Trebuchet18", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	hiltbutt.DoClick = function( pan )
		if wOS.ALCS.Legacy.SaberStation.CurrentButton == language.GetPhrase( "wos_l_option_hilt" ) then return end
		wOS.ALCS.Legacy.SaberStation.CurrentButton = language.GetPhrase( "wos_l_option_hilt" )
		wOS.ALCS.Legacy:CraftUpdateControlPanel()
	end
	
	local bladebutt = vgui.Create( "DButton", self.SaberStation )
	bladebutt:SetSize( fw*0.2, fh*0.05 )
	bladebutt:SetPos( fw*0.265, fh*0.01 )
	bladebutt:SetText( "" )
	bladebutt.Paint = function( pan, ww, hh )
		local col = ( wOS.ALCS.Legacy.SaberStation.CurrentButton == language.GetPhrase( "wos_l_option_blade" ) and Color( 175, 175, 175, 255 ) ) or Color( 88, 88, 88, 255 )
		draw.RoundedBox( 5, 0, 0, ww, hh, col )
		draw.SimpleText( language.GetPhrase( "wos_l_option_blade" ), "Trebuchet18", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	bladebutt.DoClick = function( pan )
		if wOS.ALCS.Legacy.SaberStation.CurrentButton == language.GetPhrase( "wos_l_option_blade" ) then return end
		wOS.ALCS.Legacy.SaberStation.CurrentButton = language.GetPhrase( "wos_l_option_blade" )
		wOS.ALCS.Legacy:CraftUpdateControlPanel()
	end
	
	local crystalbutt = vgui.Create( "DButton", self.SaberStation )
	crystalbutt:SetSize( fw*0.2, fh*0.05 )
	crystalbutt:SetPos( fw*0.475, fh*0.01 )
	crystalbutt:SetText( "" )
	crystalbutt.Paint = function( pan, ww, hh )
		local col = ( wOS.ALCS.Legacy.SaberStation.CurrentButton == language.GetPhrase( "wos_l_option_color" ) and Color( 175, 175, 175, 255 ) ) or Color( 88, 88, 88, 255 )
		draw.RoundedBox( 5, 0, 0, ww, hh, col )
		draw.SimpleText( language.GetPhrase( "wos_l_option_color" ), "Trebuchet18", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	crystalbutt.DoClick = function( pan )
		if wOS.ALCS.Legacy.SaberStation.CurrentButton == language.GetPhrase( "wos_l_option_color" ) then return end
		wOS.ALCS.Legacy.SaberStation.CurrentButton = language.GetPhrase( "wos_l_option_color" )
		wOS.ALCS.Legacy:CraftUpdateControlPanel()
	end
	
	local energybutt = vgui.Create( "DButton", self.SaberStation )
	energybutt:SetSize( fw*0.2, fh*0.05 )
	energybutt:SetPos( fw*0.685, fh*0.01 )
	energybutt:SetText( "" )
	energybutt.Paint = function( pan, ww, hh )
		local col = ( wOS.ALCS.Legacy.SaberStation.CurrentButton == language.GetPhrase( "wos_l_option_misc" ) and Color( 175, 175, 175, 255 ) ) or Color( 88, 88, 88, 255 )
		draw.RoundedBox( 5, 0, 0, ww, hh, col )
		draw.SimpleText( language.GetPhrase( "wos_l_option_misc" ), "Trebuchet18", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	energybutt.DoClick = function( pan )
		if wOS.ALCS.Legacy.SaberStation.CurrentButton == language.GetPhrase( "wos_l_option_misc" ) then return end
		wOS.ALCS.Legacy.SaberStation.CurrentButton = language.GetPhrase( "wos_l_option_misc" )
		wOS.ALCS.Legacy:CraftUpdateControlPanel()
	end	
	
	self.ContentPanel = vgui.Create("DScrollPanel", self.SaberStation )
	self.ContentPanel:SetSize( fw*0.98, fh*0.83 )
	self.ContentPanel:SetPos( fw*0.01, fh*0.07 )
	self.ContentPanel.Paint = function( pan, ww, hh ) 
	end
	self.ContentPanel.VBar.Paint = function() end
	self.ContentPanel.VBar.btnUp.Paint = function() end
	self.ContentPanel.VBar.btnDown.Paint = function() end
	self.ContentPanel.VBar.btnGrip.Paint = function() end
	
	self:CraftUpdateControlPanel()
	
end

local function CalcSize( num, width )
	
	if width then
		num = 4 - 2*num
	else
		num = 32 + 32*num
	end
	
	return num
	
end

local function ReverseSize( num, width )
	
	if width then
		num = ( 4 - num )/2
	else
		num = ( num - 32 )/32
	end
	
	return num	
	
end

function wOS.ALCS.Legacy:CraftUpdateControlPanel()
	if not self.SaberStation then wOS.ALCS.Legacy:OpenSaberCrafting() return end
	if not self.ContentPanel then return end
	self.ContentPanel:Clear()
	
	local mode = self.SaberStation.CurrentButton
	local mw, mh = self.ContentPanel:GetSize()
	
	if mode == language.GetPhrase( "wos_l_option_hilt" ) then
		local padx, pady = mw*0.02, mh*0.05
		local bw, bh = mw*0.18, mw*0.15
		local offsetx, offsety = 0, 0
		local hilts = list.Get( "LightsaberModels" )
		for model, _ in pairs( hilts ) do
			if offsetx + bw >= mw then 
				offsetx = 0
				offsety = offsety + bh + pady
			end
			
			local datamask = vgui.Create( "DPanel", self.ContentPanel )
			datamask:SetSize( bw, bh )
			datamask:SetPos( offsetx, offsety )
			datamask.Paint = function() end
			
			local Iconent = ClientsideModel("borealis/barrel.mdl")
			Iconent:SetAngles(Angle(0,0,0))
			Iconent:SetPos(Vector(0,0,0))
			Iconent:Spawn()
			Iconent:Activate()	
			
			local ItemIcon = vgui.Create( "DModelPanel", datamask )
			ItemIcon:SetSize( bw, bh )
			ItemIcon:SetModel( model )
			Iconent:SetModel( model )
			
			local center = Iconent:OBBCenter()
			local dist = Iconent:BoundingRadius()*1.6
			ItemIcon:SetLookAt( center )
			ItemIcon:SetCamPos( center + Vector( dist, dist, 0 ) )	
			Iconent:Remove()
			
			local ItemButt = vgui.Create( "DButton", ItemIcon )
			ItemButt:SetSize( bw, bh )
			ItemButt:SetText( "" )
			ItemButt.Paint = function( pan, ww, hh ) 	
				local primary = GetConVar( "rb655_lightsaber_model" ):GetString() == model || GetConVar( "rb655_lightsaber_dual_model" ):GetString() == model
				local secondary = GetConVar( "rb655_lightsaber_dual_model_single" ):GetString() == model
				if primary and not secondary then
					surface.SetDrawColor( Color( 0, 100, 155, 255 ) )
					surface.DrawOutlinedRect( 0, 0, ww, hh )
					draw.SimpleText( language.GetPhrase( "wos_l_primary_saber" ), "Trebuchet18", ww/2, hh*0.02, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
				elseif secondary and not primary then
					surface.SetDrawColor( Color( 155, 100, 0, 255 ) )
					surface.DrawOutlinedRect( 0, 0, ww, hh )
					draw.SimpleText( language.GetPhrase( "wos_l_secondary_saber" ), "Trebuchet18", ww/2, hh*0.02, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
				elseif primary and secondary then
					surface.SetDrawColor( Color( 155, 200, 155, 255 ) )
					surface.DrawOutlinedRect( 0, 0, ww, hh )
					draw.SimpleText( language.GetPhrase( "wos_l_dual_saber" ), "Trebuchet18", ww/2, hh*0.02, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
				else
					surface.SetDrawColor( Color( 105, 105, 105, 255 ) )
					surface.DrawOutlinedRect( 0, 0, ww, hh )						
				end
			end
			ItemButt.DoClick = function( pan )
				if ItemButt.ItemIconOptions then ItemButt.ItemIconOptions:Remove() ItemButt.ItemIconOptions = nil end
				ItemButt.ItemIconOptions = DermaMenu( ItemIcon )
				ItemButt.ItemIconOptions:SetPos( gui.MouseX(), gui.MouseY() )
				ItemButt.ItemIconOptions.Think = function( self )
					if not wOS.ALCS.Legacy.SaberStation then self:Remove() return end
					if not ItemButt then self:Remove() return end
				end
				ItemButt.ItemIconOptions:AddOption( "Set as Primary Hilt", function() 
					LocalPlayer():ConCommand( "rb655_lightsaber_model " .. model )
					LocalPlayer():ConCommand( "rb655_lightsaber_dual_model " .. model  )
					surface.PlaySound( Sound( "buttons/button14.wav" ) )
				end )
				ItemButt.ItemIconOptions:AddOption( "Set as Secondary Hilt", function() 
					LocalPlayer():ConCommand( "rb655_lightsaber_dual_model_single " .. model )
					surface.PlaySound( Sound( "buttons/button14.wav" ) )
				end )
			end					
			offsetx = offsetx + bw + padx
		end
	elseif mode == language.GetPhrase( "wos_l_option_blade" ) then
		local infoframe = vgui.Create( "DPanel", self.ContentPanel )
		infoframe:SetSize( mw, mh )
		infoframe.Paint = function( pan, ww, hh ) 
			local tx, ty = draw.SimpleText( language.GetPhrase( "wos_l_primary_blade" ), "TreBuchet24", ww*0.245, hh*0.06, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM )
			surface.SetDrawColor( color_white )
			surface.DrawLine( ww*0.245 - tx*0.75, hh*0.06 + ty*0.03, ww*0.245 + tx*0.75, hh*0.06 + ty*0.03 )
			tx, ty = draw.SimpleText( language.GetPhrase( "wos_l_secondary_blade" ), "TreBuchet24", ww*0.755, hh*0.06, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM )
			surface.DrawLine( ww*0.755 - tx*0.75, hh*0.06 + ty*0.03, ww*0.755 + tx*0.75, hh*0.06 + ty*0.03 )
			draw.SimpleText( language.GetPhrase( "wos_l_info_bladel" ), "TreBuchet24", ww*0.11, hh*0.85, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			draw.SimpleText( language.GetPhrase( "wos_l_info_bladew" ), "TreBuchet24", ww*0.11, hh*0.94, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			draw.SimpleText( language.GetPhrase( "wos_l_info_bladel" ), "TreBuchet24", ww*0.62, hh*0.85, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			draw.SimpleText( language.GetPhrase( "wos_l_info_bladew" ), "TreBuchet24", ww*0.62, hh*0.94, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		end
		
		local primsize = vgui.Create( "DSlider", infoframe )
		primsize:SetSize( mw*0.49, mh*0.75 )
		primsize:SetPos( 0, mh*0.08 )
		primsize:SetLockX( false )
		primsize:SetLockY( false )
		primsize:SetNotches( true )
		primsize:SetBackground( "wos/utilities/saber_measurement_axis.png" )
		primsize.Paint = function( pan, ww, hh )
			draw.RoundedBox( 0, 0, 0, ww, hh, Color( 155, 155, 155, 105 ) )
		end	
		primsize:SetSlideX( ReverseSize( GetConVar( "rb655_lightsaber_bladel" ):GetInt() ) )
		primsize:SetSlideY( ReverseSize( GetConVar( "rb655_lightsaber_bladew" ):GetInt(), true ) )	
		
		local primlength = vgui.Create( "DNumberWang", infoframe )
		primlength:SetPos( mw*0.29, mh*0.85 )
		primlength:SetSize( mw*0.1, mh*0.06 )
		primlength:SetMin( 32 )
		primlength:SetMax( 64 )
		primlength.Think = function( pan )
			local val = CalcSize( primsize:GetSlideX() )
			pan:SetValue( val )
			LocalPlayer():ConCommand( "rb655_lightsaber_bladel " .. val )
			LocalPlayer():ConCommand( "rb655_lightsaber_dual_bladel " .. val )		
		end
		
		local primwidth = vgui.Create( "DNumberWang", infoframe )
		primwidth:SetPos( mw*0.29, mh*0.94 )
		primwidth:SetSize( mw*0.1, mh*0.06 )
		primwidth:SetMin( 2 )
		primwidth:SetMax( 4 )
		primwidth.Think = function( pan )
			local val = CalcSize( primsize:GetSlideY(), true )
			pan:SetValue( val )
			LocalPlayer():ConCommand( "rb655_lightsaber_bladew " .. val )
			LocalPlayer():ConCommand( "rb655_lightsaber_dual_bladew " .. val )		
		end
		
		local secsize = vgui.Create( "DSlider", infoframe )
		secsize:SetSize( mw*0.49, mh*0.75 )
		secsize:SetPos( mw*0.51, mh*0.08 )
		secsize:SetLockX( false )
		secsize:SetLockY( false )
		secsize:SetNotches( true )
		secsize:SetBackground( "wos/utilities/saber_measurement_axis.png" )
		secsize.Paint = function( pan, ww, hh )
			draw.RoundedBox( 0, 0, 0, ww, hh, Color( 155, 155, 155, 105 ) )
		end	
		secsize:SetSlideX( ReverseSize( GetConVar( "rb655_lightsaber_dual_bladel_single" ):GetInt() ) )
		secsize:SetSlideY( ReverseSize( GetConVar( "rb655_lightsaber_dual_bladew_single" ):GetInt(), true ) )	
		
		local seclength = vgui.Create( "DNumberWang", infoframe )
		seclength:SetPos( mw*0.8, mh*0.85 )
		seclength:SetSize( mw*0.1, mh*0.06 )
		seclength:SetMin( 32 )
		seclength:SetMax( 64 )
		seclength.Think = function( pan )
			local val = CalcSize( secsize:GetSlideX() )
			pan:SetValue( val )
			LocalPlayer():ConCommand( "rb655_lightsaber_dual_bladel_single " .. val )		
		end
		
		local secwidth = vgui.Create( "DNumberWang", infoframe )
		secwidth:SetPos( mw*0.8, mh*0.94 )
		secwidth:SetSize( mw*0.1, mh*0.06 )
		secwidth:SetMin( 2 )
		secwidth:SetMax( 4 )
		secwidth.Think = function( pan )
			local val = CalcSize( secsize:GetSlideY(), true )
			pan:SetValue( val )
			LocalPlayer():ConCommand( "rb655_lightsaber_dual_bladew_single " .. val )		
		end		
		
	elseif mode == language.GetPhrase( "wos_l_option_color" ) then
		local infoframe = vgui.Create( "DPanel", self.ContentPanel )
		infoframe:SetSize( mw, mh )
		infoframe.Paint = function( pan, ww, hh ) 
			local tx, ty = draw.SimpleText( language.GetPhrase( "wos_l_info_primcrystal" ), "TreBuchet24", ww*0.245, hh*0.06, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM )
			surface.SetDrawColor( color_white )
			surface.DrawLine( ww*0.245 - tx*0.75, hh*0.06 + ty*0.03, ww*0.245 + tx*0.75, hh*0.06 + ty*0.03 )
			tx, ty = draw.SimpleText( language.GetPhrase( "wos_l_info_seccrystal" ), "TreBuchet24", ww*0.755, hh*0.06, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM )
			surface.DrawLine( ww*0.755 - tx*0.75, hh*0.06 + ty*0.03, ww*0.755 + tx*0.75, hh*0.06 + ty*0.03 )
		end
		
		local primcolor = vgui.Create( "DColorMixer", infoframe )
		primcolor:SetSize( mw*0.49, mh*0.75 )
		primcolor:SetPos( 0, mh*0.08 )
		primcolor:SetPalette( true ) 	
		primcolor:SetAlphaBar( false )
		primcolor:SetWangs( false )			
		primcolor:SetColor( Color( GetConVar( "rb655_lightsaber_red" ):GetInt(), GetConVar( "rb655_lightsaber_green" ):GetInt(), GetConVar( "rb655_lightsaber_blue" ):GetInt(), 255 ) )	--Set the default color
		function primcolor:ValueChanged()
			local color = self:GetColor()
			LocalPlayer():ConCommand( "rb655_lightsaber_red " .. color.r )
			LocalPlayer():ConCommand( "rb655_lightsaber_green " .. color.g )
			LocalPlayer():ConCommand( "rb655_lightsaber_blue " .. color.b )		
			LocalPlayer():ConCommand( "rb655_lightsaber_dual_red " .. color.r )
			LocalPlayer():ConCommand( "rb655_lightsaber_dual_green " .. color.g )
			LocalPlayer():ConCommand( "rb655_lightsaber_dual_blue " .. color.b )		
		end
		
		local priminner = vgui.Create( "DButton", infoframe )
		priminner:SetSize( mw*0.49*0.66, mh*0.07 )
		priminner:SetPos( mw*0.49*0.33/2, mh*0.86 )
		priminner:SetText( "" )
		priminner.Activated = GetConVar( "rb655_lightsaber_dark" ):GetBool()
		priminner.DoClick = function( pan )
			priminner.Activated = !priminner.Activated
			local val = 0
			if priminner.Activated then
				val = 1
			end
			LocalPlayer():ConCommand( "rb655_lightsaber_dark " .. val )		
			LocalPlayer():ConCommand( "rb655_lightsaber_dual_dark " .. val )
			surface.PlaySound( "buttons/lightswitch2.wav" ) 
		end
		priminner.Paint = function( pan, ww, hh )
			local col = ( pan.Activated and Color( 0, 100, 155, 255 ) ) or Color( 88, 88, 88, 255 )
			draw.RoundedBox( 5, 0, 0, ww, hh, col )
			draw.SimpleText( language.GetPhrase( "wos_l_info_dark" ), "TreBuchet24", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )		
		end

		local seccolor = vgui.Create( "DColorMixer", infoframe )
		seccolor:SetSize( mw*0.49, mh*0.75 )
		seccolor:SetPos( mw*0.51, mh*0.08 )
		seccolor:SetPalette( true ) 	
		seccolor:SetAlphaBar( false )
		seccolor:SetWangs( false )			
		seccolor:SetColor( Color( GetConVar( "rb655_lightsaber_dual_red_single" ):GetInt(), GetConVar( "rb655_lightsaber_dual_green_single" ):GetInt(), GetConVar( "rb655_lightsaber_dual_blue_single" ):GetInt(), 255 ) )	--Set the default color
		function seccolor:ValueChanged()
			local color = self:GetColor()
			LocalPlayer():ConCommand( "rb655_lightsaber_dual_red_single " .. color.r )
			LocalPlayer():ConCommand( "rb655_lightsaber_dual_green_single " .. color.g )
			LocalPlayer():ConCommand( "rb655_lightsaber_dual_blue_single " .. color.b )		
		end	
		
		local secinner = vgui.Create( "DButton", infoframe )
		secinner:SetSize( mw*0.49*0.66, mh*0.07 )
		secinner:SetPos( mw*0.51 + mw*0.49*0.33/2, mh*0.86 )
		secinner:SetText( "" )
		secinner.Activated = GetConVar( "rb655_lightsaber_dual_dark_single" ):GetBool()
		secinner.DoClick = function( pan )
			secinner.Activated = !secinner.Activated
			local val = 0
			if secinner.Activated then
				val = 1
			end
			LocalPlayer():ConCommand( "rb655_lightsaber_dual_dark_single " .. val )
			surface.PlaySound( "buttons/lightswitch2.wav" ) 
		end
		secinner.Paint = function( pan, ww, hh )
			local col = ( pan.Activated and Color( 0, 100, 155, 255 ) ) or Color( 88, 88, 88, 255 )
			draw.RoundedBox( 5, 0, 0, ww, hh, col )
			draw.SimpleText( language.GetPhrase( "wos_l_info_dark" ), "TreBuchet24", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )		
		end
	else
		local infoframe = vgui.Create( "DPanel", self.ContentPanel )
		infoframe:SetSize( mw, mh )
		infoframe.Paint = function( pan, ww, hh ) 
			draw.SimpleText( language.GetPhrase( "wos_l_info_igniter" ), "TreBuchet24", ww*0.25, hh*0.03, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			draw.SimpleText( language.GetPhrase( "wos_l_info_humsound" ), "TreBuchet24", ww*0.25, hh*0.35, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			draw.SimpleText( language.GetPhrase( "wos_l_info_swingsound" ), "TreBuchet24", ww*0.25, hh*0.67, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		end		
		
		local ignitions = vgui.Create( "DComboBox", infoframe )
		ignitions:SetPos( mw*0.55, mh*0.03 )
		ignitions:SetSize( mw*0.2, mh*0.05 )
		ignitions.Values = {}
		for name, data in pairs( list.Get( "rb655_LightsaberIgniteSounds" ) ) do
			ignitions.Values[ name ] = data
			ignitions:AddChoice( name )
			if GetConVar( "rb655_lightsaber_onsound" ):GetString() == data[ "rb655_lightsaber_onsound" ] then
				ignitions:SetValue( name )
			end
		end
		ignitions.OnSelect = function( pan, id, val )
			LocalPlayer():ConCommand( "rb655_lightsaber_onsound " .. pan.Values[val][ "rb655_lightsaber_onsound" ] )		
			LocalPlayer():ConCommand( "rb655_lightsaber_dual_onsound " .. pan.Values[val][ "rb655_lightsaber_onsound" ] )	
			LocalPlayer():ConCommand( "rb655_lightsaber_offsound " .. pan.Values[val][ "rb655_lightsaber_offsound" ] )		
			LocalPlayer():ConCommand( "rb655_lightsaber_dual_offsound " .. pan.Values[val][ "rb655_lightsaber_offsound" ] )				
		end

		local hums = vgui.Create( "DComboBox", infoframe )
		hums:SetPos( mw*0.55, mh*0.35 )
		hums:SetSize( mw*0.2, mh*0.05 )
		hums.Values = {}
		for name, data in pairs( list.Get( "rb655_LightsaberHumSounds" ) ) do
			hums.Values[ name ] = data
			hums:AddChoice( name )
			if GetConVar( "rb655_lightsaber_humsound" ):GetString() == data[ "rb655_lightsaber_humsound" ] then
				hums:SetValue( name )
			end
		end
		hums.OnSelect = function( pan, id, val )
			LocalPlayer():ConCommand( "rb655_lightsaber_humsound " .. pan.Values[val][ "rb655_lightsaber_humsound" ] )		
			LocalPlayer():ConCommand( "rb655_lightsaber_dual_humsound " .. pan.Values[val][ "rb655_lightsaber_humsound" ] )				
		end 
		
		local swings = vgui.Create( "DComboBox", infoframe )
		swings:SetPos( mw*0.55, mh*0.67 )
		swings:SetSize( mw*0.2, mh*0.05 )
		swings.Values = {}
		for name, data in pairs( list.Get( "rb655_LightsaberSwingSounds" ) ) do
			swings.Values[ name ] = data
			swings:AddChoice( name )
			if GetConVar( "rb655_lightsaber_swingsound" ):GetString() == data[ "rb655_lightsaber_swingsound" ] then
				swings:SetValue( name )
			end
		end
		swings.OnSelect = function( pan, id, val )
			LocalPlayer():ConCommand( "rb655_lightsaber_swingsound " .. pan.Values[val][ "rb655_lightsaber_swingsound" ] )		
			LocalPlayer():ConCommand( "rb655_lightsaber_dual_swingsound " .. pan.Values[val][ "rb655_lightsaber_swingsound" ] )				
		end 
		
	end
	
end 