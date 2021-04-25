--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2020
	
	Contact: www.wiltostech.com
		----------------------------------------]]--








































































wOS = wOS or {}
wOS.ALCS = wOS.ALCS or {}

local w,h = ScrW(), ScrH()																																																																																																																													

surface.CreateFont( "wOS.ALCS.Form.TitleFont", {
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

function wOS.ALCS:OpenFormMenu( dual )

	if self.FormMenu then return end
	
	local wep = LocalPlayer():GetActiveWeapon()
	if not IsValid( wep ) then return end
	if not wep.IsLightsaber then return end
	
	
	local forms = {}
	local group = LocalPlayer():GetUserGroup()
	local dual = wep:GetDualMode()
	
	if not wep.UseSkills then
		if wep.UseForms then
			for fr, _ in pairs( wep.UseForms ) do
				table.insert( forms, fr )
			end
		else
			if table.HasValue( wOS.ALCS.Config.AllAccessForms, group ) then
				if dual then
					for form, _ in pairs( wOS.DualForms ) do
						table.insert( forms, form )
					end		
				else
					for form, _ in pairs( wOS.Forms ) do
						table.insert( forms, form )
					end
				end	
			else
				if dual then
					for form, _ in pairs( wOS.DualForms ) do
						if wOS.DualForms[ form ][ group ] then
							table.insert( forms, form )
						end
					end		
				else
					for form, _ in pairs( wOS.Forms ) do
						if wOS.Forms[ form ][ group ] then
							table.insert( forms, form )
						end
					end
				end
			end
		end
	else
		local dat = ( dual and wOS.DualForms ) or wOS.Forms
		if wep.Forms then
			for _, form in pairs( wep.Forms ) do
				if dat[ form ] then
					table.insert( forms, form )
				end
			end
		end
	end
	
	if table.Count( forms ) < 1 then return end
	
	gui.EnableScreenClicker( true )
	self.FormMenu = vgui.Create( "DPanel" )
	self.FormMenu:SetSize( w*0.33, h*0.5 )
	self.FormMenu:SetPos( w*0.5 - w*0.33/2, h*0.25 )
	self.FormMenu.Paint = function( pan, ww, hh )
		if not vgui.CursorVisible() then gui.EnableScreenClicker( true ) end
		draw.RoundedBox( 3, 0, 0, ww, hh, Color( 25, 25, 25, 245 ) )
		draw.SimpleText( "Form Select Menu", "wOS.ALCS.Form.TitleFont", ww/2, hh*0.05, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )	
	end 
	
	local fw, fh = self.FormMenu:GetSize()
	
	local mw, mh = fw*0.9, fh*0.8
	
	local formlist = vgui.Create("DScrollPanel", self.FormMenu )
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
	
	local button = vgui.Create( "DButton", self.FormMenu )
	button:SetSize( fw*0.05, fw*0.05 )
	button:SetPos( fw*0.94, fw*0.01 )
	button:SetText( "" )
	button.Paint = function( pan, ww, hh )
		surface.SetDrawColor( Color( 255, 0, 0, 255 ) )
		surface.DrawLine( 0, 0, ww, hh )
		surface.DrawLine( 0, hh, ww, 0 )
	end
	button.DoClick = function()
		self.FormMenu:Remove()
		self.FormMenu = nil
		gui.EnableScreenClicker( false )
	end	
	
	local button1 = vgui.Create( "DButton", self.FormMenu )
	button1:SetSize( fw, fh*0.1 )
	button1:SetPos( 0, fh*0.9 )
	button1:SetText( "" )
	button1.Paint = function( pan, ww, hh )
		if pan:IsHovered() then
			draw.SimpleText( "Powered by wiltOS Technologies", "wOS.ALCS.Form.TitleFont", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )		
		else
			draw.SimpleText( "Powered by wiltOS Technologies", "wOS.ALCS.Form.TitleFont", ww/2, hh/2, Color( 75, 75, 75, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
	end
	button1.DoClick = function()
		gui.OpenURL( "www.wiltostech.com" )
	end	
	
	
	for _, form in pairs( forms ) do
		local button = vgui.Create( "DButton", formlist )
		button:SetSize( mw, mh*0.1 )
		button:SetPos( 0, offsety )
		button:SetText( "" )
		button.Form = form
		button.Paint = function( pan, ww, hh )
			draw.RoundedBox( 0, 0, 0, ww, hh, Color( 175, 175, 175, 255 ) )
			draw.SimpleText( button.Form, "wOS.ALCS.Form.TitleFont", ww*0.05, hh/2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		end
		button.DoClick = function()
			self.FormMenu:Remove()
			self.FormMenu = nil
			net.Start( "wOS.ALCS.SendFormSelect" )
			net.WriteString( button.Form )
			net.SendToServer()
			gui.EnableScreenClicker( false )
		end
		
		offsety = offsety + mh*0.1 + pady
		
	end
	
end