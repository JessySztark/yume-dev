--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2020
	
	Contact: www.wiltostech.com
		----------------------------------------]]--








































































wOS = wOS or {}
wOS.ALCS = wOS.ALCS or {}

local w,h = ScrW(), ScrH()																																																																																																																													

surface.CreateFont( "wOS.TitleFont", {
	font = "Roboto Cn",
	extended = false,
	size = 24*(h/1200),
	weight = 1000,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

surface.CreateFont( "wOS.DescriptionFont",{
	font = "Roboto Cn",
	extended = false,
	size = 18*(h/1200),
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

concommand.Add( "wos_togglefirstperson", function( ply, cmd, args )
	if ( !IsValid( ply:GetActiveWeapon() ) || !ply:GetActiveWeapon().IsLightsaber ) then return end
	local wep = ply:GetActiveWeapon()
	if not wep.FirstPerson then 
		wep.FirstPerson = true 
		return 
	else
		wep.FirstPerson = false
	end
end )					

wOS.ShouldDrawLightsaberLight = CreateConVar( "wos_alcs_drawsaberlight", "1", FCVAR_ARCHIVE )

function wOS.ALCS:OpenForceMenu()

	if self.ForceMenu then return end	
	
	local wep = LocalPlayer():GetActiveWeapon()
	if not IsValid( wep ) then return end
	if not wep.IsLightsaber then return end
	local powers = wep:GetActiveForcePowers()
	if table.Count( powers ) < 1 then return end
	
	gui.EnableScreenClicker( true )
	self.ForceMenu = vgui.Create( "DPanel" )
	self.ForceMenu:SetSize( w*0.33, h*0.5 )
	self.ForceMenu:SetPos( w*0.5 - w*0.33/2, h*0.25 )
	self.ForceMenu.Paint = function( pan, ww, hh )
		if not vgui.CursorVisible() then gui.EnableScreenClicker( true ) end
		draw.RoundedBox( 3, 0, 0, ww, hh, Color( 25, 25, 25, 245 ) )
		draw.SimpleText( "Force Select Menu", "wOS.TitleFont", ww/2, hh*0.05, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )	
	end 
	
	local fw, fh = self.ForceMenu:GetSize()
	
	local mw, mh = fw*0.9, fh*0.8
	
	local formlist = vgui.Create("DScrollPanel", self.ForceMenu )
	formlist:SetPos( fw*0.05, fh*0.1 )
	formlist:SetSize( mw, mh )
	formlist.Paint = function( pan, ww, hh ) 
	end
	formlist.VBar.Paint = function() end
	formlist.VBar.btnUp.Paint = function() end
	formlist.VBar.btnDown.Paint = function() end
	formlist.VBar.btnGrip.Paint = function() end
	
	local offsety = 0
	local pady = mh*0.01
	
	local button = vgui.Create( "DButton", self.ForceMenu )
	button:SetSize( fw*0.05, fw*0.05 )
	button:SetPos( fw*0.94, fw*0.01 )
	button:SetText( "" )
	button.Paint = function( pan, ww, hh )
		surface.SetDrawColor( Color( 255, 0, 0, 255 ) )
		surface.DrawLine( 0, 0, ww, hh )
		surface.DrawLine( 0, hh, ww, 0 )
	end
	button.DoClick = function()
		self.ForceMenu:Remove()
		self.ForceMenu = nil
		gui.EnableScreenClicker( false )
	end	
	
	local button1 = vgui.Create( "DButton", self.ForceMenu )
	button1:SetSize( fw, fh*0.1 )
	button1:SetPos( 0, fh*0.9 )
	button1:SetText( "" )
	button1.Paint = function( pan, ww, hh )
		if pan:IsHovered() then
			draw.SimpleText( "Powered by wiltOS Technologies", "wOS.TitleFont", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )		
		else
			draw.SimpleText( "Powered by wiltOS Technologies", "wOS.TitleFont", ww/2, hh/2, Color( 75, 75, 75, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
	end
	button1.DoClick = function()
		gui.OpenURL( "www.wiltostech.com" )
	end	
	
	for key, data in pairs( powers ) do
		local button = vgui.Create( "DButton", formlist )
		button:SetSize( mw, mh*0.1 )
		button:SetPos( 0, offsety )
		button:SetText( "" )
		button.Data = data
		button.Paint = function( pan, ww, hh )
			draw.RoundedBox( 0, 0, 0, ww, hh, Color( 175, 175, 175, 255 ) )
			draw.SimpleText( button.Data.name, "wOS.TitleFont", hh, hh*0.025, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			draw.SimpleText( button.Data.description, "wOS.DescriptionFont", hh, hh*0.65, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			local image = wOS.ForceIcons[ button.Data.name ]
			if image then
				surface.SetMaterial( image )
				surface.SetDrawColor( Color(255, 255, 255, 255) );
				surface.DrawTexturedRect( hh*0.025, hh*0.025, hh*0.95, hh*0.95 )
			end
		end
		button.DoClick = function()
			self.ForceMenu:Remove()
			self.ForceMenu = nil
			net.Start( "wOS.ALCS.SendForceSelect" )
			net.WriteInt( key, 32 )
			net.SendToServer()
			gui.EnableScreenClicker( false )
		end
		
		offsety = offsety + mh*0.1 + pady
		
	end
	
end

function wOS:OpenDevestatorMenu()

	if self.DevestatorMenu then return end	
	
	local wep = LocalPlayer():GetActiveWeapon()
	if not IsValid( wep ) then return end
	if not wep.IsLightsaber then return end
	local powers = wep:GetActiveDevestators()
	if table.Count( powers ) < 1 then return end
	
	gui.EnableScreenClicker( true )
	self.DevestatorMenu = vgui.Create( "DPanel" )
	self.DevestatorMenu:SetSize( w*0.33, h*0.5 )
	self.DevestatorMenu:SetPos( w*0.5 - w*0.33/2, h*0.25 )
	self.DevestatorMenu.Paint = function( pan, ww, hh )
		if not vgui.CursorVisible() then gui.EnableScreenClicker( true ) end
		draw.RoundedBox( 3, 0, 0, ww, hh, Color( 25, 25, 25, 245 ) )
		draw.SimpleText( "Devestators Menu", "wOS.TitleFont", ww/2, hh*0.05, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )	
	end 
	
	local fw, fh = self.DevestatorMenu:GetSize()
	
	local mw, mh = fw*0.9, fh*0.8
	
	local formlist = vgui.Create("DScrollPanel", self.DevestatorMenu )
	formlist:SetPos( fw*0.05, fh*0.1 )
	formlist:SetSize( mw, mh )
	formlist.Paint = function( pan, ww, hh ) 
	end
	formlist.VBar.Paint = function() end
	formlist.VBar.btnUp.Paint = function() end
	formlist.VBar.btnDown.Paint = function() end
	formlist.VBar.btnGrip.Paint = function() end
	
	local offsety = 0
	local pady = mh*0.01
	
	local button = vgui.Create( "DButton", self.DevestatorMenu )
	button:SetSize( fw*0.05, fw*0.05 )
	button:SetPos( fw*0.94, fw*0.01 )
	button:SetText( "" )
	button.Paint = function( pan, ww, hh )
		surface.SetDrawColor( Color( 255, 0, 0, 255 ) )
		surface.DrawLine( 0, 0, ww, hh )
		surface.DrawLine( 0, hh, ww, 0 )
	end
	button.DoClick = function()
		self.DevestatorMenu:Remove()
		self.DevestatorMenu = nil
		gui.EnableScreenClicker( false )
	end	
	
	local button1 = vgui.Create( "DButton", self.DevestatorMenu )
	button1:SetSize( fw, fh*0.1 )
	button1:SetPos( 0, fh*0.9 )
	button1:SetText( "" )
	button1.Paint = function( pan, ww, hh )
		if pan:IsHovered() then
			draw.SimpleText( "Powered by wiltOS Technologies", "wOS.TitleFont", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )		
		else
			draw.SimpleText( "Powered by wiltOS Technologies", "wOS.TitleFont", ww/2, hh/2, Color( 75, 75, 75, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
	end
	button1.DoClick = function()
		gui.OpenURL( "www.wiltostech.com" )
	end	
	
	for key, data in pairs( powers ) do
		local button = vgui.Create( "DButton", formlist )
		button:SetSize( mw, mh*0.1 )
		button:SetPos( 0, offsety )
		button:SetText( "" )
		button.Data = data
		button.Paint = function( pan, ww, hh )
			draw.RoundedBox( 0, 0, 0, ww, hh, Color( 175, 175, 175, 255 ) )
			draw.SimpleText( button.Data.name, "wOS.TitleFont", hh, hh*0.025, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			draw.SimpleText( button.Data.description, "wOS.DescriptionFont", hh, hh*0.65, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			local image = wOS.DevestatorIcons[ button.Data.name ]
			if image then
				surface.SetMaterial( image )
				surface.SetDrawColor( Color(255, 255, 255, 255) );
				surface.DrawTexturedRect( hh*0.025, hh*0.025, hh*0.95, hh*0.95 )
			end
		end
		button.DoClick = function()
			self.DevestatorMenu:Remove()
			self.DevestatorMenu = nil
			net.Start( "wOS.ALCS.SendDevestatorSelect" )
			net.WriteInt( key, 32 )
			net.SendToServer()
			gui.EnableScreenClicker( false )
		end
		
		offsety = offsety + mh*0.1 + pady
		
	end
	
end

function wOS.ALCS:OpenDraggableForceMenu()

	if self.ForceMenu then return end	
	
	local wep = LocalPlayer():GetActiveWeapon()
	if not IsValid( wep ) then return end
	if not wep.IsLightsaber then return end
	
	local powers = {}
	for _, force in pairs( wep.ForcePowerList ) do
		if not wep.AvailablePowers[ force ] then continue end
		powers[ #powers + 1 ] = wep.AvailablePowers[ force ]
	end
	if table.Count( powers ) < 1 then return end
	local slots = {}
	gui.EnableScreenClicker( true )
	self.ForceMenu = vgui.Create( "DPanel" )
	self.ForceMenu:SetSize( w*0.33, h*0.5 )
	self.ForceMenu:SetPos( w*0.5 - w*0.33/2, h*0.25 )
	self.ForceMenu.Paint = function( pan, ww, hh )
		if not vgui.CursorVisible() then gui.EnableScreenClicker( true ) end
		draw.RoundedBox( 3, 0, 0, ww, hh, Color( 25, 25, 25, 245 ) )
		draw.SimpleText( "Force Select Menu", "wOS.TitleFont", ww/2, hh*0.05, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )	
	end 
	
	local fw, fh = self.ForceMenu:GetSize()
	
	local mw, mh = fw*0.9, fh*0.8
	
	local formlist = vgui.Create("DScrollPanel", self.ForceMenu )
	formlist:SetPos( fw*0.05, fh*0.1 )
	formlist:SetSize( mw, mh )
	formlist.Paint = function( pan, ww, hh ) 
	end
	formlist.VBar.Paint = function() end
	formlist.VBar.btnUp.Paint = function() end
	formlist.VBar.btnDown.Paint = function() end
	formlist.VBar.btnGrip.Paint = function() end
	
	local offsety = 0
	local pady = mh*0.01
	
	local button = vgui.Create( "DButton", self.ForceMenu )
	button:SetSize( fw*0.05, fw*0.05 )
	button:SetPos( fw*0.94, fw*0.01 )
	button:SetText( "" )
	button.Paint = function( pan, ww, hh )
		surface.SetDrawColor( Color( 255, 0, 0, 255 ) )
		surface.DrawLine( 0, 0, ww, hh )
		surface.DrawLine( 0, hh, ww, 0 )
	end
	button.DoClick = function()
		self.ForceMenu:Remove()
		self.ForceMenu = nil
		self.ForceSlots:Remove()
		self.ForceSlots = nil
		gui.EnableScreenClicker( false )
		
		net.Start( "wOS.ALCS.HybridForceSelect" )
			for i=1, wOS.ALCS.Config.MaximumForceSlots do
				net.WriteUInt( i, 10 )
				net.WriteString( slots[i].Selected or "" )
			end
		net.SendToServer()
	end	
	
	local button1 = vgui.Create( "DButton", self.ForceMenu )
	button1:SetSize( fw, fh*0.1 )
	button1:SetPos( 0, fh*0.9 )
	button1:SetText( "" )
	button1.Paint = function( pan, ww, hh )
		if pan:IsHovered() then
			draw.SimpleText( "Powered by wiltOS Technologies", "wOS.TitleFont", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )		
		else
			draw.SimpleText( "Powered by wiltOS Technologies", "wOS.TitleFont", ww/2, hh/2, Color( 75, 75, 75, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
	end
	button1.DoClick = function()
		gui.OpenURL( "www.wiltostech.com" )
	end	
	
	local function dragdropfunc( pan, panels, dropped, _, _ )
		if not dropped then return end
		pan.Selected = panels[1].Data.name
	end
	
	for key, data in pairs( powers ) do
		local button = vgui.Create( "DButton", formlist )
		button:SetSize( mw, mh*0.1 )
		button:SetPos( 0, offsety )
		button:SetText( "" )
		button.Data = data
		button.Paint = function( pan, ww, hh )
			draw.RoundedBox( 0, 0, 0, ww, hh, Color( 175, 175, 175, 255 ) )
			draw.SimpleText( button.Data.name, "wOS.TitleFont", hh, hh*0.025, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			draw.SimpleText( button.Data.description, "wOS.DescriptionFont", hh, hh*0.65, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			local image = wOS.ForceIcons[ button.Data.name ]
			if image then
				surface.SetMaterial( image )
				surface.SetDrawColor( Color(255, 255, 255, 255) );
				surface.DrawTexturedRect( hh*0.025, hh*0.025, hh*0.95, hh*0.95 )
			end
		end
		
		button:Droppable( "wOS.ALCS.ForcePowerSlot" )
		offsety = offsety + mh*0.1 + pady
	end
	
	self.ForceSlots = vgui.Create( "DPanel" )
	self.ForceSlots:SetSize( w*0.5, h*0.1 )
	self.ForceSlots:SetPos( w*0.25, h*0.9 )
	self.ForceSlots.Paint = function( pan, ww, hh )
		surface.SetDrawColor( Color( 35, 35, 35, 155 ) )
		surface.DrawRect( 0, 0, ww, hh )
		surface.SetDrawColor( color_white )
		surface.DrawOutlinedRect( 0, 0, ww, hh )
	end

	local width = self.ForceSlots:GetWide()/wOS.ALCS.Config.MaximumForceSlots

	for i=1, wOS.ALCS.Config.MaximumForceSlots do
		local forceslot = vgui.Create( "DPanel", self.ForceSlots )
		forceslot:SetSize( width, self.ForceSlots:GetTall() )
		forceslot:Dock( LEFT )
		forceslot.Slot = i
		forceslot.Paint = function( pan, ww, hh )
			surface.SetDrawColor( color_white )
			surface.DrawOutlinedRect( 0, 0, ww, hh )
			draw.SimpleText( "Slot " .. i, "wOS.SkillTreeMain", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			if pan.Selected then
				local image = wOS.ForceIcons[ pan.Selected ]
				if image then
					local box = hh*0.75
					surface.SetMaterial( image )
					surface.SetDrawColor( Color(255, 255, 255, 255) );
					surface.DrawTexturedRect( ww/2 - box/2, hh/2 - box/2, box, box )
				end
			end
		end
		forceslot.OnMousePressed = function( pan, key ) 
			if key == MOUSE_RIGHT then
				pan.Selected = nil
			end
		end
		if wep.ForcePowers[ i ] then
			local dat = wep.ForcePowers[ i ]
			forceslot.Selected = dat.name
		end
		forceslot:Receiver( "wOS.ALCS.ForcePowerSlot", dragdropfunc, {} )
		slots[i] = forceslot
	end

end

function wOS.ALCS:CutCircle( x, y, radius )

			if not sw then sw = 0 end
			if not sh then sh = 0 end
			radius = radius*0.93
			local seg = 25
			local cir = {}

			table.insert( cir, { x = x, y = y, u = 0.5, v = 0.5 } )
			for i = 0, seg do
				local a = math.rad( ( i / seg ) * -360 )
				table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
			end

			local a = math.rad( 0 ) -- This is need for non absolute segment counts
			table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )

			
			render.ClearStencil() --Clear stencil
			render.SetStencilEnable( true ) --Enable stencil
			render.SetStencilWriteMask(1)
			render.SetStencilTestMask(1)
			render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NEVER);
			render.SetStencilFailOperation(STENCILOPERATION_DECR);
			render.SetStencilZFailOperation(STENCILOPERATION_DECR );
			render.SetStencilPassOperation( STENCILOPERATION_DECR ) 
			render.SetStencilReferenceValue( 1 )
			render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_EQUAL )
			surface.SetDrawColor( Color( 255, 255, 255, 255 ) )
			surface.DrawPoly( cir )

end

function wOS.ALCS:DrawCircle( x, y, radius )

	if not sw then sw = 0 end
	if not sh then sh = 0 end
	local seg = 360
	local cir = {}

	table.insert( cir, { x = x, y = y, u = 0.5, v = 0.5 } )
	for i = 0, seg do
		local a = math.rad( ( i / seg ) * -360 )
		table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
	end

	local a = math.rad( 0 ) -- This is need for non absolute segment counts
	table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )

	surface.DrawPoly( cir )
			
end

function wOS.ALCS:ShouldDisableCam()

	local call = hook.Call( "wOS.ALCS.ShouldDisableCam" )
	if call then return true end

	if wOS.CraftingMenu then
		if wOS.CraftingMenu:IsVisible() then return true end
	end
	
	return false

end

hook.Add( "InputMouseApply", "wOS.ALCS.StopMeditateTurn", function( cmd )
	local wep = LocalPlayer():GetActiveWeapon()
	if not IsValid( wep ) then return end
	if not wep.IsLightsaber then return end
	if wep:GetMeditateMode() < 1 then return end
	
	cmd:SetMouseX( 0 )
	cmd:SetMouseY( 0 )
	cmd:SetMouseWheel( 0 )

	return true
end )