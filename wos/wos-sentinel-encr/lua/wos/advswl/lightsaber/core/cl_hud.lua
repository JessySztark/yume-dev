--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2020
	
	Contact: www.wiltostech.com
		----------------------------------------]]--








































































wOS = wOS or {}
wOS.ALCS = wOS.ALCS or {}
wOS.ALCS.LightsaberBase = wOS.ALCS.LightsaberBase or {}

local default_huds = {}
default_huds[1] = function( self )
	local icon = 52*(ScrW()/1920)
	local gap = 5*(ScrW()/1920)

	local bar = 4
	local bar2 = 16
	local rd = 7
	
	if ( self.ForceSelectEnabled ) then
		icon = 128*(ScrW()/1920)
		bar = 8
		bar2 = 20
		rd = 10
	end

	local ForcePowers = self.ForcePowers

	if ( #ForcePowers < 1 ) then return end
	
	self.Vars.ForceBar = math.min( self:GetMaxForce(), Lerp( 0.1, self.Vars.ForceBar, math.floor( self:GetForce() ) ) )
	self.Vars.DevBar = math.min( self:GetMaxStamina(), Lerp( 0.1, self.Vars.DevBar, math.floor( self:GetDevEnergy() ) ) )

	local w = #ForcePowers * icon + ( #ForcePowers - 1 ) * gap

	local h = bar2
	local x = math.floor( ScrW() / 2 - w / 2 )
	local y = ScrH() - gap - bar2
	
	draw.RoundedBox( rd, x, y, w, h, Color( 0, 0, 0, 128 ) )
	
	local barW = math.ceil( w * ( self.Vars.ForceBar / self:GetMaxForce() ) )
	if ( self:GetForce() <= 1 && barW <= 1 ) then barW = 0 end
	draw.RoundedBox( rd, x, y, barW, h, Color( 0, 128, 255, 255 ) )
	
	local barW2 = math.ceil( w * ( self.Vars.DevBar / 100 ) )
	if ( self:GetDevEnergy() <= 1 && barW2 <= 1 ) then barW2 = 0 end
    surface.SetMaterial( self.Vars.grad )
    surface.SetDrawColor( Color( 225, 0, 225, 175 - 175*math.abs( math.sin( CurTime() ) ) ) )
    surface.DrawTexturedRect( x, y, barW2, h )
	draw.SimpleText( math.floor( self:GetForce() ) .. "%", "SelectedForceHUD", x + w / 2, y + h / 2, Color( 255, 255, 255 ), 1, 1 )
	

	if wOS.ALCS.Config.EnableStamina then
		------------------------------------- STAMINA BAR --------------------------------
		local stam = self:GetStamina()
		self.Vars.StaminaBar = (self.Vars.StaminaBar == stam and stam) or Lerp(0.1, self.Vars.StaminaBar, stam )
		x = math.floor( ScrW()/2 - w / 2 )
		y = ScrH() - 2*gap - 2*bar2

		draw.RoundedBox( rd, x, y, w, h, Color( 0, 0, 0, 128 ) )
		
		barW = math.ceil( w * ( self.Vars.StaminaBar / self:GetMaxStamina() ) )
		if ( self:GetStamina() <= 1 && barW <= 1 ) then barW = 0 end
		draw.RoundedBox( rd, x, y, barW, h, Color( 155, 155, 155, 255 ) )

		draw.SimpleText( "STAMINA: " .. math.floor( self:GetStamina() ) .. "%", "SelectedForceHUD", x + w / 2, y + h / 2, Color( 255, 255, 255 ), 1, 1 )
	end
	
	local y = y - icon - gap
	local h = icon

	for id, t in pairs( ForcePowers ) do
		local should_cooldown = false
		local image = wOS.ForceIcons[ self.ForcePowers[ id ].name ]
		local x = x + ( id - 1 ) * ( h + gap )
		local x2 = math.floor( x + icon / 2 )
		local ogy = y + 0
		if ( self:GetForceType() == id ) then
			wOS.ALCS:CutCircle( x + h/2, y + h/2, h*0.55 )
				local cdn = self:GetForceCooldown()
				local cd = self.ForcePowers[ id ].cooldown or 1
				local div = ( cd > 0 and cd ) or 1
				local rat = math.Clamp( cdn/div, 0, 1 )
				draw.RoundedBox( 0, x, y, h, h, Color( 0, 255 - 128*math.abs( math.cos( 8*CurTime() ) ), 255, 255 ) )
			render.SetStencilEnable( false )
			should_cooldown = true
		end
		
		wOS.ALCS:CutCircle( x + h/2, y + h/2, h/2 )

		if image then
			surface.SetMaterial( image )
			surface.DrawTexturedRect( x, y, h, h )
		else
			surface.SetDrawColor( Color( 0, 0, 0, 128 ) )
			surface.DrawRect( x, y, w, h )
		end
		
		render.SetStencilEnable( false )

		if should_cooldown then
			wOS.ALCS:CutCircle( x + h/2, y + h/2, h/2 )
				local y = y + ( icon - bar )
				local cdn = self:GetForceCooldown()
				local cd = self.ForcePowers[ id ].cooldown or 1
				local div = ( cd > 0 and cd ) or 1
				local rat = math.Clamp( cdn/div, 0, 1 )
				draw.RoundedBox( 0, x, y - h + h*( 1 - rat), h, h*rat, Color( 255, 0, 0, 100 ) )
			render.SetStencilEnable( false )
		end

		draw.SimpleText( t.icon || "", "SelectedForceType", x2, math.floor( y + icon / 2 ), Color( 255, 255, 255 ), 1, 1 )
		if ( self.ForceSelectEnabled ) then
			draw.SimpleText( "Slot " .. ( input.LookupBinding( "slot" .. id ) || "<NOT BOUND>" ):upper(), "SelectedForceHUD", x + h/2, y - 3*gap, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
	end
	
	if ( self.ForceSelectEnabled ) and #self.ForcePowers > 0 then

		surface.SetFont( "SelectedForceHUD" )
		local tW, tH = surface.GetTextSize( self.ForcePowers[ self:GetForceType() ].description || "" )

		/*local x = x + w + gap
		local y = y*/
		local x = ScrW() / 2 + gap// - tW / 2
		local y = y - tH - gap * 8

		self.Vars:DrawHUDBox( x, y, tW + gap * 2, tH + gap * 2 )

		for id, txt in pairs( string.Explode( "\n", self.ForcePowers[ self:GetForceType() ].description || "" ) ) do
			draw.SimpleText( txt, "SelectedForceHUD", x + gap, y + ( id - 1 ) * ScreenScale( 6 ) + gap, Color( 255, 255, 255 ) )
		end

		surface.SetFont( "SelectedForceType" )
		local txt = self.ForcePowers[ self:GetForceType() ].name or ""
		local tW2, tH2 = surface.GetTextSize( txt )

		local x = ScrW() / 2 + gap// - tW / 2
		local y = y - tH - gap * 8

		self.Vars:DrawHUDBox( x, y, tW2 + 10, tH2 )
		draw.SimpleText( txt, "SelectedForceType", x + gap, y, Color( 255, 255, 255 ) )
		
	end
end

default_huds[2] = function( self )
	local icon = 52*(ScrW()/1920)
	local gap = 5*(ScrW()/1920)
	local bar = 4
	local bar2 = 16
	if ( self.ForceSelectEnabled ) then
		icon = 128*(ScrW()/1920)
		bar = 8
		bar2 = 24
	end
	local ForcePowers = self:GetActiveForcePowers()
	if ( #ForcePowers < 1 ) then return end

	----------------------------------- Force Bar -----------------------------------

	self.Vars.ForceBar = math.min( self:GetMaxForce(), Lerp( 0.1, self.Vars.ForceBar, math.floor( self:GetForce() ) ) )
	self.Vars.DevBar = math.min( self:GetMaxStamina(), Lerp( 0.1, self.Vars.DevBar, math.floor( self:GetDevEnergy() ) ) )

	local w = #ForcePowers * icon + ( #ForcePowers - 1 ) * gap

	local h = bar2
	local x = math.floor( ScrW() / 2 - w / 2 )
	local y = ScrH() - gap - bar2

	self.Vars:DrawHUDBox( x, y, w, h )

	local barW = math.ceil( w * ( self.Vars.ForceBar / self:GetMaxForce() ) )
	if ( self:GetForce() <= 1 && barW <= 1 ) then barW = 0 end
	draw.RoundedBox( 0, x, y, barW, h, Color( 0, 128, 255, 255 ) )
	
	local barW2 = math.ceil( w * ( self.Vars.DevBar / 100 ) )
	if ( self:GetDevEnergy() <= 1 && barW2 <= 1 ) then barW2 = 0 end
	draw.RoundedBox( 0, x, y, barW2, h, Color( 225, 0, 225, 125 ) )

	draw.SimpleText( math.floor( self:GetForce() ) .. "%", "SelectedForceHUD", x + w / 2, y + h / 2, Color( 255, 255, 255 ), 1, 1 )
	if wOS.ALCS.Config.EnableStamina then
		------------------------------------- STAMINA BAR --------------------------------
		local stam = self:GetStamina()
		self.Vars.StaminaBar = (self.Vars.StaminaBar == stam and stam) or Lerp(0.1, self.Vars.StaminaBar, stam )
		x = math.floor( ScrW()/2 - w / 2 )
		y = ScrH() - gap - bar2 - bar2

		self.Vars:DrawHUDBox( x, y, w, h )

		barW = math.ceil( w * ( self.Vars.StaminaBar / self:GetMaxStamina() ) )
		if ( self:GetStamina() <= 1 && barW <= 1 ) then barW = 0 end
		draw.RoundedBox( 0, x, y, barW, h, Color( 155, 155, 155, 255 ) )

		draw.SimpleText( "STAMINA: " .. math.floor( self:GetStamina() ) .. "%", "SelectedForceHUD", x + w / 2, y + h / 2, Color( 255, 255, 255 ), 1, 1 )
	end

		y = y - icon - gap
		h = icon

		for id, t in pairs( ForcePowers ) do
			local x = x + ( id - 1 ) * ( h + gap )
			local x2 = math.floor( x + icon / 2 )

			local image = wOS.ForceIcons[ self.ForcePowers[ id ].name ]
			self.Vars:DrawHUDBox( x, y, h, h, self:GetForceType() == id )
			if !wOS.ALCS.Config.DisableForceIcons then
				if image then
					surface.SetMaterial( image )
					surface.SetDrawColor( Color(255, 255, 255, 255) );
					surface.DrawTexturedRect( x, y, h, h )
				end
			end
			draw.SimpleText( t.icon or "", "SelectedForceType", x2, math.floor( y + icon / 2 ), Color( 255, 255, 255 ), 1, 1 )
			if ( self.ForceSelectEnabled ) then
				draw.SimpleText( ( input.LookupBinding( "slot" .. id ) or "<NOT BOUND>" ):upper(), "SelectedForceHUD", x + gap, y + gap, Color( 255, 255, 255 ) )
			end
			if ( self:GetForceType() == id ) then
			
				local cdn = self:GetForceCooldown()
				local cd = self.ForcePowers[ id ].cooldown or 1
				local div = ( cd > 0 and cd ) or 1
				local rat = math.Clamp( cdn/div, 0, 1 )
				draw.RoundedBox( 0, x, y + h*( 1 - rat), h, h*rat, Color( 255, 0, 0, 100 ) )
				
				local y = y + ( icon - bar )
				surface.SetDrawColor( 0, 128, 255, 255 )
				draw.NoTexture()
				surface.DrawPoly( {
					{ x = x2 - bar, y = y },
					{ x = x2, y = y - bar },
					{ x = x2 + bar, y = y }
				} )
				draw.RoundedBox( 0, x, y, h, bar, Color( 0, 128, 255, 255 ) )
			end
		end
	
	local selectedForcePower = self:GetActiveForcePowerType( self:GetForceType() )

	if ( selectedForcePower && self.ForceSelectEnabled ) then

		surface.SetFont( "SelectedForceHUD" )
		local tW, tH = surface.GetTextSize( selectedForcePower.description or "" )

		--[[local x = x + w + gap
		local y = y]]
		local x = ScrW() / 2 + gap-- - tW / 2
		local y = y - tH - gap * 3

		self.Vars:DrawHUDBox( x, y, tW + gap * 2, tH + gap * 2 )

		for id, txt in pairs( string.Explode( "\n", selectedForcePower.description or "" ) ) do
			draw.SimpleText( txt, "SelectedForceHUD", x + gap, y + ( id - 1 ) * ScreenScale( 6 ) + gap, Color( 255, 255, 255 ) )
		end

	end
	
	if ( !self.ForceSelectEnabled ) then
		surface.SetFont( "SelectedForceHUD" )
		local txt = "Press " .. ( input.LookupBinding( "impulse 100" ) or "<NOT BOUND>" ):upper() .. " to toggle Force selection"
		local tW, tH = surface.GetTextSize( txt )

		local x = x + w / 2
		local y = y - tH - gap

		self.Vars:DrawHUDBox( x - tW / 2 - 5, y, tW + 10, tH )
		draw.SimpleText( txt, "SelectedForceHUD", x, y, Color( 255, 255, 255 ), 1 )

		local isGood = hook.Call( "PlayerBindPress", nil, LocalPlayer(), "this_bind_doesnt_exist", true )
		if ( isGood == true ) then
			local txt = "Some addon is breaking the PlayerBindPress hook. Send a screenshot of this error to the mod page!"
			for name, func in pairs( hook.GetTable()[ "PlayerBindPress" ] ) do txt = txt .. "\n" .. tostring( name ) end
			local tW, tH = surface.GetTextSize( txt )

			y = y - tH - gap

			local id = 1
			self.Vars:DrawHUDBox( x - tW / 2 - 5, y, tW + 10, tH )
			draw.SimpleText( string.Explode( "\n", txt )[ 1 ], "SelectedForceHUD", x, y + 0, Color( 255, 230, 230 ), 1 )

			for str, func in pairs( hook.GetTable()[ "PlayerBindPress" ] ) do
				local clr = Color( 255, 255, 128 )
				if ( ( isstring( str ) && func( LocalPlayer(), "this_bind_doesnt_exist", true ) == true ) or ( !isstring( str ) && func( str, LocalPlayer(), "this_bind_doesnt_exist", true ) == true ) ) then
					clr = Color( 255, 128, 128 )
				end
				if ( !isstring( str ) ) then str = tostring( str ) end
				if ( str == "" ) then str = "<empty string hook>" end
				local _, lineH = surface.GetTextSize( str )
				draw.SimpleText( str, "SelectedForceHUD", x, y + id * lineH, clr, 1 )
				id = id + 1
			end
		end
	end

	if ( selectedForcePower && self.ForceSelectEnabled ) then
		surface.SetFont( "SelectedForceType" )
		local txt = selectedForcePower.name or ""
		local tW2, tH2 = surface.GetTextSize( txt )

		local x = x + w / 2 - tW2 - gap * 2 --+ w / 2
		local y = y + gap - tH2 - gap * 2

		self.Vars:DrawHUDBox( x, y, tW2 + 10, tH2 )
		draw.SimpleText( txt, "SelectedForceType", x + gap, y, Color( 255, 255, 255 ) )
	end
end

default_huds[3] = function( self )
	local icon = 52*(ScrW()/1920)
	local gap = 5*(ScrW()/1920)

	local bar = 4
	local bar2 = 16

	local ForcePowers = self:GetActiveForcePowers()

	if ( #ForcePowers < 1 ) then return end

	self.Vars.ForceBar = math.min( self:GetMaxForce(), Lerp( 0.1, self.Vars.ForceBar, math.floor( self:GetForce() ) ) )
	self.Vars.DevBar = math.min( self:GetMaxStamina(), Lerp( 0.1, self.Vars.DevBar, math.floor( self:GetDevEnergy() ) ) )

	local w = 9* icon + 8 * gap
	local h = bar2
	local x = math.floor( ScrW() / 2 - w / 2 )
	local y = ScrH() - gap - bar2

	self.Vars:DrawHUDBox( x, y, w, h )

	local barW = math.ceil( w * ( self.Vars.ForceBar / self:GetMaxForce() ) )
	if ( self:GetForce() <= 1 && barW <= 1 ) then barW = 0 end
	draw.RoundedBox( 0, x, y, barW, h, Color( 0, 128, 255, 255 ) )
	
	local barW2 = math.ceil( w * ( self.Vars.DevBar / 100 ) )
	if ( self:GetDevEnergy() <= 1 && barW2 <= 1 ) then barW2 = 0 end
	draw.RoundedBox( 0, x, y, barW2, h, Color( 225, 0, 225, 125 ) )

	draw.SimpleText( math.floor( self:GetForce() ) .. "%", "SelectedForceHUD", x + w / 2, y + h / 2, Color( 255, 255, 255 ), 1, 1 )
	if wOS.ALCS.Config.EnableStamina then
	
		local stam = self:GetStamina()
		self.Vars.StaminaBar = (self.Vars.StaminaBar == stam and stam) or Lerp(0.1, self.Vars.StaminaBar, stam )
		x = math.floor( ScrW()/2 - w / 2 )
		y = ScrH() - gap - bar2 - bar2

		self.Vars:DrawHUDBox( x, y, w, h )

		barW = math.ceil( w * ( self.Vars.StaminaBar / self:GetMaxStamina() ) )
		if ( self:GetStamina() <= 1 && barW <= 1 ) then barW = 0 end
		draw.RoundedBox( 0, x, y, barW, h, Color( 155, 155, 155, 255 ) )

		draw.SimpleText( "STAMINA: " .. math.floor( self:GetStamina() ) .. "%", "SelectedForceHUD", x + w / 2, y + h / 2, Color( 255, 255, 255 ), 1, 1 )
	end

	local selectedForcePower = self:GetActiveForcePowerType( self:GetForceType() )

	surface.SetFont( "SelectedForceType" )
	local txt = selectedForcePower.name or ""
	local tW2, tH2 = surface.GetTextSize( txt )

	local x = x + w / 2 - tW2/2 - 5
	local y = y - tH2 - gap * 5 
	
	self.Vars:DrawHUDBox( x, y, tW2 + 10, tH2 )
	draw.SimpleText( txt, "SelectedForceType", x + gap, y, Color( 255, 255, 255 ) )
	
	local cdn = self:GetForceCooldown()
	local cd = selectedForcePower.cooldown or 1
	local div = ( cd > 0 and cd ) or 1
	local rat = math.Clamp( cdn/div, 0, 1 )

	draw.RoundedBox( 0, x, y, ( tW2 + 10 )*rat, tH2, Color( 255, 0, 0, 100 ) )

end

default_huds[4] = function( self )

	local ForcePowers = self.ForcePowers
	if ( #ForcePowers < 1 ) or wOS.ALCS.ForceMenu then return end
	local icon = 52*(ScrW()/1920)
	local gap = 5*(ScrW()/1920)

	local bar = 4
	local bar2 = 16
	local rd = 7
	
	if ( self.ForceSelectEnabled ) then
		icon = 128*(ScrW()/1920)
		bar = 8
		bar2 = 20
		rd = 10
	end

	local ForcePowers = self.ForcePowers

	if ( #ForcePowers < 1 ) then return end

	self.Vars.ForceBar = math.min( self:GetMaxForce(), Lerp( 0.1, self.Vars.ForceBar, math.floor( self:GetForce() ) ) )
	self.Vars.DevBar = math.min( 100, Lerp( 0.1, self.Vars.DevBar, math.floor( self:GetDevEnergy() ) ) )

	local w = #ForcePowers * icon + ( #ForcePowers - 1 ) * gap

	local h = bar2
	local x = math.floor( ScrW() / 2 - w / 2 )
	local y = ScrH() - gap - bar2
	
	draw.RoundedBox( rd, x, y, w, h, Color( 0, 0, 0, 128 ) )
	
	local barW = math.ceil( w * ( self.Vars.ForceBar / self:GetMaxForce() ) )
	if ( self:GetForce() <= 1 && barW <= 1 ) then barW = 0 end
	draw.RoundedBox( rd, x, y, barW, h, Color( 0, 128, 255, 255 ) )
	
	local barW2 = math.ceil( w * ( self.Vars.DevBar / 100 ) )
	if ( self:GetDevEnergy() <= 1 && barW2 <= 1 ) then barW2 = 0 end
    surface.SetMaterial( self.Vars.grad )
    surface.SetDrawColor( Color( 225, 0, 225, 175 - 175*math.abs( math.sin( CurTime() ) ) ) )
    surface.DrawTexturedRect( x, y, barW2, h )
	draw.SimpleText( math.floor( self:GetForce() ) .. "%", "SelectedForceHUD", x + w / 2, y + h / 2, Color( 255, 255, 255 ), 1, 1 )
	

	if wOS.ALCS.Config.EnableStamina then
		------------------------------------- STAMINA BAR --------------------------------
		local stam = self:GetStamina()
		self.Vars.StaminaBar = (self.Vars.StaminaBar == stam and stam) or Lerp(0.1, self.Vars.StaminaBar, stam )
		x = math.floor( ScrW()/2 - w / 2 )
		y = ScrH() - 2*gap - 2*bar2

		draw.RoundedBox( rd, x, y, w, h, Color( 0, 0, 0, 128 ) )
		
		barW = math.ceil( w * ( self.Vars.StaminaBar / self:GetMaxStamina() ) )
		if ( self:GetStamina() <= 1 && barW <= 1 ) then barW = 0 end
		draw.RoundedBox( rd, x, y, barW, h, Color( 155, 155, 155, 255 ) )

		draw.SimpleText( "STAMINA: " .. math.floor( self:GetStamina() ) .. "%", "SelectedForceHUD", x + w / 2, y + h / 2, Color( 255, 255, 255 ), 1, 1 )
	end
	
	local y = y - icon - gap
	local h = icon

	for id, t in pairs( ForcePowers ) do
		local should_cooldown = false
		local image = wOS.ForceIcons[ self.ForcePowers[ id ].name ]
		local x = x + ( id - 1 ) * ( h + gap )
		local x2 = math.floor( x + icon / 2 )
		local ogy = y + 0
		if ( self:GetForceType() == id ) then
			wOS.ALCS:CutCircle( x + h/2, y + h/2, h*0.55 )
				local cdn = self:GetForceCooldown()
				local cd = self.ForcePowers[ id ].cooldown or 1
				local div = ( cd > 0 and cd ) or 1
				local rat = math.Clamp( cdn/div, 0, 1 )
				draw.RoundedBox( 0, x, y, h, h, Color( 0, 255 - 128*math.abs( math.cos( 8*CurTime() ) ), 255, 255 ) )
			render.SetStencilEnable( false )
			should_cooldown = true
		end
		
		wOS.ALCS:CutCircle( x + h/2, y + h/2, h/2 )

		if image then
			surface.SetMaterial( image )
			surface.DrawTexturedRect( x, y, h, h )
		else
			surface.SetDrawColor( Color( 0, 0, 0, 128 ) )
			surface.DrawRect( x, y, w, h )
		end
		
		render.SetStencilEnable( false )

		if should_cooldown then
			wOS.ALCS:CutCircle( x + h/2, y + h/2, h/2 )
				local y = y + ( icon - bar )
				local cdn = self:GetForceCooldown()
				local cd = self.ForcePowers[ id ].cooldown or 1
				local div = ( cd > 0 and cd ) or 1
				local rat = math.Clamp( cdn/div, 0, 1 )
				draw.RoundedBox( 0, x, y - h + h*( 1 - rat), h, h*rat, Color( 255, 0, 0, 100 ) )
			render.SetStencilEnable( false )
		end

		draw.SimpleText( t.icon || "", "SelectedForceType", x2, math.floor( y + icon / 2 ), Color( 255, 255, 255 ), 1, 1 )
		if ( self.ForceSelectEnabled ) then
			draw.SimpleText( "Slot " .. ( input.LookupBinding( "slot" .. id ) || "<NOT BOUND>" ):upper(), "SelectedForceHUD", x + h/2, y - 3*gap, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
	end
	
	if ( self.ForceSelectEnabled ) and #self.ForcePowers > 0 then

		surface.SetFont( "SelectedForceHUD" )
		local dat = self.ForcePowers[ self:GetForceType() ]
		if dat then
			local tW, tH = surface.GetTextSize( dat.description || "" )

			/*local x = x + w + gap
			local y = y*/
			local x = ScrW() / 2 + gap// - tW / 2
			local y = y - tH - gap * 8

			self.Vars:DrawHUDBox( x, y, tW + gap * 2, tH + gap * 2 )

			for id, txt in pairs( string.Explode( "\n", dat.description || "" ) ) do
				draw.SimpleText( txt, "SelectedForceHUD", x + gap, y + ( id - 1 ) * ScreenScale( 6 ) + gap, Color( 255, 255, 255 ) )
			end

			surface.SetFont( "SelectedForceType" )
			local txt = dat.name or ""
			local tW2, tH2 = surface.GetTextSize( txt )

			local x = ScrW() / 2 + gap// - tW / 2
			local y = y - tH - gap * 8

			self.Vars:DrawHUDBox( x, y, tW2 + 10, tH2 )
			draw.SimpleText( txt, "SelectedForceType", x + gap, y, Color( 255, 255, 255 ) )
		end
	end
	
end

function wOS.ALCS.LightsaberBase:HandleHUD( wep )

	local overwrite = hook.Call( "wOS.ALCS.DrawLightsaberHUD", nil, wep )
	if overwrite then return end
	
	local hud = ( wOS.ALCS.Config.LightsaberHUD <= table.Count( WOS_ALCS.HUD ) and wOS.ALCS.Config.LightsaberHUD ) or WOS_ALCS.HUD.NEWAGE
	local func = default_huds[hud]
	if func then
		default_huds[hud]( wep )
	end
	
	wOS.ALCS.LightsaberBase:HandleTarget( wep )
	
end

function wOS.ALCS.LightsaberBase:HandleTarget( wep )
	local powerdata = wep.ForcePowers[ wep:GetForceType() ]
	if not powerdata then return end
	
	local ply = wep.Owner
	
	if not powerdata.target then return end
	
	if not ply:KeyDown( IN_USE ) then return end
	
	local targets = wep:GetTargetEntity( powerdata.dist or 512, powerdata.target )
	for _, target in ipairs( targets ) do
		if not target:IsValid() then return end
		local maxs = target:OBBMaxs()
		local p = target:GetPos()
		p.z = p.z + maxs.z

		local pos = p:ToScreen()
		local x, y = pos.x, pos.y
		local size = 16

		surface.SetDrawColor( 220 + math.cos( CurTime()*10 )*35, 0, 0, 255 )
		draw.NoTexture()
		surface.DrawPoly( {
			{ x = x - size, y = y - size },
			{ x = x + size, y = y - size },
			{ x = x, y = y }
		} )		
	end

end