--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2020
	
	Contact: www.wiltostech.com
		----------------------------------------]]--









































































if wOS.ALCS.Config.Skills.MenuSchema != WOS_ALCS.SKILLMENU.CLASSIC then return end

wOS = wOS or {}
wOS.ALCS = wOS.ALCS or {}
wOS.ALCS.Skills = wOS.ALCS.Skills or {}

local w,h = ScrW(), ScrH()	
local PLAYER = LocalPlayer()																																																																																																																												
local SkillColor = Color( 0, 0, 0, 155 )

local blur = Material 'pp/blurscreen'
local function blurpanel (panel, amount )
    local x, y = panel:LocalToScreen(0, 0)
    surface.SetDrawColor(255, 255, 255)
    surface.SetMaterial(blur)
    for i = 1, 3 do
        blur:SetFloat('$blur', (i / 3) * (amount or 6))
        blur:Recompute()
        render.UpdateScreenEffectTexture()
        surface.DrawTexturedRect(x * -1, y * -1, ScrW(), ScrH())
    end
end

surface.CreateFont( "wOS.SkillTreeMain", {
	font = "Roboto Cn",
	extended = false,
	size = 32*(h/1200),
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

surface.CreateFont( "wOS.SkillHelpFont", {
	font = "Roboto Cn",
	extended = false,
	size = 28*(h/1200),
	weight = 600,
	blursize = 0,
	scanlines = 1,
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

local HELP_TEXT = [[Ceci est votre menu de développement de personnage, alimenté par les technologies wiltOS. Ici, vous pouvez intégrer un ensemble de compétences particulier à mesure que vous acquérez de l'expérience sur le terrain.

Vous remarquerez la progression de votre personnage en bas du menu. Au fur et à mesure que vous progressez, vous obtiendrez des points de compétence à dépenser dans un arbre respectif.

Choisissez un arbre de compétences sur le côté gauche de l'écran pour voir les compétences. Survolez une icône de compétence pour en savoir plus.

Les compétences peuvent affecter diverses choses, y compris votre sabre laser personnel, alors assurez-vous de les lire attentivement.

Certaines compétences dans un arbre nécessitent des compétences préalables pour être acquises. Vous pouvez voir les compétences préalables en suivant la ligne blanche entre elles.

Les lignes rouges entre les compétences signifient que posséder l'une vous exclura de l'autre. Alors choisissez judicieusement.
]]

function wOS.ALCS.Skills:OpenClassicTreeMenu()

	if self.ClassicMenu then
		self.ClassicMenu:Remove()
		self.ClassicMenu = nil
	end
	
	gui.EnableScreenClicker( true )

	self.ClassicMenu = vgui.Create( "DFrame" )
	self.ClassicMenu:SetDraggable( true )
	self.ClassicMenu:ShowCloseButton( false )
	self.ClassicMenu:SetTitle( "" )
	local sx, sy = wOS.ALCS.Skills.Menu:GetSize()
	self.ClassicMenu:SetSize( sx, sy )
	local px, py = wOS.ALCS.Skills.Menu:GetPos()
	self.ClassicMenu:SetPos( px, py )
	self.ClassicMenu.Paint = function( pan, ww, hh )
		draw.RoundedBox( 0, 0, 0, ww*0.985, hh*0.02, Color( 255, 255, 255, 155 ) )
		draw.RoundedBox( 0, ww*0.985, 0, ww*0.015, hh*0.02, Color( 255, 0, 0 ) )
	end	

	local mw, mh = self.ClassicMenu:GetSize()

	local button = vgui.Create( "DButton", self.ClassicMenu )
	button:SetSize( mw*0.015, mh*0.02 )
	button:SetPos( mw*0.985, 0 )
	button:SetText( "" )
	button.DoClick = function()
		wOS.ALCS.Skills:CleanAllMenus()
		self.ClassicMenu:Remove()
		self.ClassicMenu = nil
	end	
	button.Paint = nil

	local p_think = self.ClassicMenu.Think
	self.ClassicMenu.Think = function( pan )
		p_think( pan )
		if not vgui.CursorVisible() then
			gui.EnableScreenClicker( true )
		end
		if not LocalPlayer():Alive() then
			button:DoClick()
			return
		end
	end

	SkillColor = Color( 25, 25, 25, 155 )

	self.DataTab = vgui.Create( "DPanel", self.ClassicMenu )
	self.DataTab:SetPos( 0, mh*0.02 )
	self.DataTab:SetSize( mw, mh*0.98 )
	self.DataTab.Color = SkillColor
	self.DataTab.Paint = function( pan, ww, hh )
		blurpanel( pan )
		draw.RoundedBox( 3, 0, 0, ww, hh, Color( 25, 25, 25, 245 ) )
	end
	
	gui.EnableScreenClicker( true )
	
	local padx, pady = mw*0.01, mw*0.01
	local bpady = mh*0.01
	local basew, baseh = mw*0.25, mh 
	local cw, ch = ( basew - 1.5*padx ), baseh - 2*pady
	local sw, sh = mw - cw - 3*padx, ch
	local skw, skh = sw - 2*padx, sh*0.65
	
	self.DataTab.Think = function( pan )
		pan.Color.r = ( pan.Color.r == SkillColor.r and SkillColor.r ) or Lerp( 0.1, pan.Color.r, SkillColor.r )
		pan.Color.g = ( pan.Color.g == SkillColor.g and SkillColor.g ) or Lerp( 0.1, pan.Color.g, SkillColor.g )
		pan.Color.b = ( pan.Color.b == SkillColor.b and SkillColor.b ) or Lerp( 0.1, pan.Color.b, SkillColor.b )
		pan.Color.a = ( pan.Color.a == SkillColor.a and SkillColor.a ) or Lerp( 0.1, pan.Color.a, SkillColor.a )
		
		local button = vgui.GetHoveredPanel() 
		if not button then self.SkillInfoPanel:SetVisible( false ) return end
		if button.Data then
			if button.Data.Tree then
				self.SkillInfoPanel:SetVisible( true )
				self.SkillInfoPanel.Data = button.Data		
			end
		else
			self.SkillInfoPanel:SetVisible( false )
		end
	end
	
	local categories = vgui.Create( "DScrollPanel", self.DataTab )
	categories:SetSize( cw, ch*0.93 )
	categories:SetPos( padx, pady )
	categories.Paint = function( pan, ww, hh )	
		surface.SetDrawColor( color_white )
		surface.DrawOutlinedRect( 0, 0, ww, hh )
	end
	categories.VBar.Paint = function() end
	categories.VBar.btnUp.Paint = function() end
	categories.VBar.btnDown.Paint = function() end
	categories.VBar.btnGrip.Paint = function() end
	
	local skilltrees = {}
	skilltrees[ "Help Menu" ] = { BackgroundColor = Color( 25, 25, 25, 155 ), Name = "Aide", Description = "Apprenez à choisir votre destin", Help = "" }
	for name, data in pairs( wOS.SkillTrees ) do
		if data.UserGroups then
			if not table.HasValue( data.UserGroups, LocalPlayer():GetUserGroup() ) then continue end
		end
		skilltrees[ name ] = data
	end
	
	local icon = 128*(h/1200)
	
	local main_frame = vgui.Create( "DPanel", self.DataTab )
	main_frame:SetPos( padx*2 + cw, pady )
	main_frame:SetSize( sw, sh )
	main_frame.CurrentTree = "Help Menu"
	main_frame.Paint = function( pan, ww, hh )
		surface.SetDrawColor( color_white )	
		
		draw.NoTexture()
		surface.SetDrawColor( color_white )
		surface.SetMaterial( wOS.TreeIcons[ pan.CurrentTree ].MainIcon )
		surface.DrawTexturedRect( ( ww - icon )*0.5, pady, icon, icon )
		
		local tx, ty = draw.SimpleText( skilltrees[ pan.CurrentTree ].Name, "wOS.SkillTreeMain", ww/2, pady + icon + bpady, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
		local txx, tyy = draw.SimpleText( skilltrees[ pan.CurrentTree ].Description, "wOS.TitleFont", ww/2, pady + icon + 2*bpady + ty, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )		
		surface.DrawLine( ww*0.25, 2*pady + icon + 2*bpady + ty + tyy, ww*0.75, 2*pady + icon + 2*bpady + ty + tyy )
		surface.DrawOutlinedRect( 0, 0, ww, hh )
		local level = LocalPlayer():GetNW2Int( "wOS.SkillLevel", 0 )
		local xp = LocalPlayer():GetNW2Int( "wOS.SkillExperience", 0 )
		local reqxp = wOS.ALCS.Config.Skills.XPScaleFormula( level )
		local lastxp = 0
		if level > 0 then
			lastxp = wOS.ALCS.Config.Skills.XPScaleFormula( level - 1 )
		end
		local rat = ( xp - lastxp )/( reqxp - lastxp )
		if level == wOS.ALCS.Config.Skills.SkillMaxLevel then
			rat = 1
		end
		surface.DrawOutlinedRect( ww*0.33, hh*0.965, ww*0.33, hh*0.02 )
		surface.DrawRect( ww*0.33, hh*0.965, ww*0.33*rat, hh*0.02 )
		draw.SimpleText( ( level == wOS.ALCS.Config.Skills.SkillMaxLevel and "MAX" ) or lastxp, "wOS.DescriptionFont", ww*0.325, hh*0.974, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
		draw.SimpleText( ( level == wOS.ALCS.Config.Skills.SkillMaxLevel and "LEVEL" ) or reqxp, "wOS.DescriptionFont", ww*0.665, hh*0.974, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )		
		draw.SimpleText( xp, "wOS.DescriptionFont", ww*0.5, hh*0.974, Color( 0, 128, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )		
		draw.SimpleText( "Niveau de combats : " .. level, "wOS.TitleFont", padx, hh - pady, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )		
		draw.SimpleText( "Points de talents : " .. LocalPlayer():GetNW2Int( "wOS.SkillPoints", 0 ), "wOS.TitleFont", ww - padx, hh - pady, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM )		
	end
	
	local skills_window = vgui.Create( "DPanel", main_frame )
	skills_window:SetSize( skw, skh )
	skills_window:SetPos( padx, sh*0.3 )
	skills_window.Paint = function( pan, ww, hh )
		draw.RoundedBox( 0, 0, 0, ww, hh, Color( 25, 25, 25, 155 ) )
		if pan.Buttons then
			for tier, bdata in pairs( pan.Buttons ) do
				for skill, button in pairs( bdata ) do
					local data = button.Data
					if table.Count( data.Requirements ) > 0 then
						local sx, sy = button:GetCenter()
						for treq, rdata in pairs( data.Requirements ) do
							for _, sreq in pairs( rdata ) do
								local dx, dy = pan.Buttons[ treq ][ sreq ]:GetCenter()
								surface.SetDrawColor( color_white )
								surface.DrawLine( sx, sy, dx, dy )
							end
						end
					end

					if data.LockOuts and table.Count( data.LockOuts ) > 0 then
						local sx, sy = button:GetCenter()
						for treq, rdata in pairs( data.LockOuts ) do
							for _, sreq in pairs( rdata ) do
								local dx, dy = pan.Buttons[ treq ][ sreq ]:GetCenter()
								surface.SetDrawColor( Color( 255, 0, 0 ) )
								surface.DrawLine( sx, sy, dx, dy )
							end
						end
					end
				end
			end
		end
	end
	
	local offsety = pady

	for name, data in pairs( skilltrees ) do

		if not wOS.SkillTreeWhitelists[ name ] then
			if data.UserGroups then
				if not table.HasValue( data.UserGroups, LocalPlayer():GetUserGroup() ) then continue end
			end
			if data.JobRestricted then
				local found = false
				for _, job in pairs( data.JobRestricted ) do
					if _G[ job ] == LocalPlayer():Team() then 
						found = true
						break 
					end
				end
				if not found then continue end
			end
		end

		local button = vgui.Create( "DButton", categories )
		button:SetSize( cw - 2*pady, ch/10 )
		button:SetPos( pady, offsety )
		button:SetText( "" )
		button.Data = data
		button.Paint = function( pan, ww, hh )
			draw.RoundedBox( 0, 0, 0, ww, hh, Color( 175, 175, 175, 255 ) )
			draw.SimpleText( button.Data.Name, "wOS.TitleFont", hh, hh*0.33, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			draw.SimpleText( button.Data.Description, "wOS.DescriptionFont", hh, hh*0.66, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			local image = wOS.TreeIcons[ button.Data.Name ].MainIcon
			if image then
				surface.SetMaterial( image )
				surface.SetDrawColor( Color(255, 255, 255, 255) );
				surface.DrawTexturedRect( hh*0.025, hh*0.025, hh*0.95, hh*0.95 )
			end
		end
		button.DoClick = function()
			main_frame.CurrentTree = name
			SkillColor = data.BackgroundColor
			main_frame:RefreshTree()
		end
		
		offsety = offsety + mh*0.1 + bpady		
		
	end
	
	main_frame.RefreshTree = function( pan )
	
		skills_window:Clear()
		skills_window.Buttons = false
		local lw, lh = skills_window:GetSize()
		local name = pan.CurrentTree
		
		if name == "Help Menu" then 
			local infotext = vgui.Create( "RichText", skills_window )
			infotext:SetSize( lw, lh )
			infotext:SetVerticalScrollbarEnabled( false ) 
			infotext.Paint = function()
				infotext.m_FontName = "wOS.SkillHelpFont"
				infotext:SetFontInternal( "wOS.SkillHelpFont" )	
				infotext:SetBGColor(Color(0,0,0,0))		
				infotext.Paint = nil
			end
			infotext:AppendText( HELP_TEXT )
			return 
		end
		skills_window.Buttons = {}
		local data = skilltrees[ name ]
		local icon = 64*(h/1200)
		local spady = ( lh - 4*pady*( data.MaxTiers + 1 ) )/data.MaxTiers
		local offsety = pady
		for i = 1, data.MaxTiers do
			local tier = data.MaxTiers - i + 1
			local skilltable = data.Tier[ tier ]
			local spadx = ( lw - icon*( #skilltable ) - 2*padx )/#skilltable
			local offsetx = lw/2 - ( #skilltable - 1 )*spadx/2 - icon/2
			skills_window.Buttons[ tier ] = {}
			for skill, skilldata in pairs( skilltable ) do
				skills_window.Buttons[ tier ][ skill ] = vgui.Create( "DImageButton", skills_window )
				skills_window.Buttons[ tier ][ skill ]:SetSize( icon, icon )
				skills_window.Buttons[ tier ][ skill ]:SetPos( offsetx, offsety )
				skills_window.Buttons[ tier ][ skill ].Data = skilldata
				skills_window.Buttons[ tier ][ skill ].Data.Tier = tier
				skills_window.Buttons[ tier ][ skill ].Data.Skill = skill	
				skills_window.Buttons[ tier ][ skill ].Data.Tree = name				
				skills_window.Buttons[ tier ][ skill ]:SetImage( skills_window.Buttons[ tier ][ skill ].Data.Icon )
				skills_window.Buttons[ tier ][ skill ].GetCenter = function( pan )
					local x, y = pan:GetPos()
					return x + pan:GetWide()/2, y + pan:GetTall()/2
				end
				local _buttonpaint = skills_window.Buttons[ tier ][ skill ].Paint
				skills_window.Buttons[ tier ][ skill ].Paint = function( pan, ww, hh )
					if not wOS:HasSkillEquipped( name, tier, skill ) or not wOS:CanEquipSkill( name, tier, skill ) then
						draw.RoundedBox( 5, 0, 0, ww, hh, Color( 35, 35, 35, 155 ) )
					else
						draw.RoundedBox( 5, 0, 0, ww, hh, Color( 0, 128, 255, 55 ) )					
					end
				end
				skills_window.Buttons[ tier ][ skill ].DoClick = function()
					if wOS:HasSkillEquipped( name, tier, skill ) or !wOS:CanEquipSkill( name, tier, skill ) then return end
					net.Start( "wOS.SkillTree.ChooseSkill" )
						net.WriteString( name )
						net.WriteInt( tier, 32 )
						net.WriteInt( skill, 32 )
					net.SendToServer()
				end
				offsetx = offsetx + spadx
			end
			offsety = offsety + 4*pady + spady
		end
		
	end		
		
	
	main_frame:RefreshTree()
	
	self.SkillInfoPanel = vgui.Create( "DPanel" )
	self.SkillInfoPanel:SetSize( mw*0.26, mh*0.08 )
	self.SkillInfoPanel:SetPos( w, h )
	self.SkillInfoPanel.Data = false
	self.SkillInfoPanel:SetVisible( false )
	self.SkillInfoPanel.Paint = function( pan, ww, hh )	
		if not ww or not hh then return end
		draw.RoundedBox( 3, 0, 0, ww, hh, Color( 25, 25, 25, 255 ) )
		surface.SetDrawColor( color_white )
		surface.DrawOutlinedRect( ww*0.01, hh*0.01, ww*0.98, hh*0.98 )
		if self.SkillInfoPanel.Data then
			draw.SimpleText( pan.Data.Name, "wOS.TitleFont", ww*0.04, hh*0.25, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			draw.SimpleText( pan.Data.Description, "wOS.DescriptionFont", ww*0.04, hh*0.5, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			if not wOS:HasSkillEquipped( pan.Data.Tree, pan.Data.Tier, pan.Data.Skill ) then
				if wOS:CanEquipSkill( pan.Data.Tree, pan.Data.Tier, pan.Data.Skill ) then
					draw.SimpleText( "Requires " .. pan.Data.PointsRequired .. " skill point(s)", "wOS.DescriptionFont", ww*0.04, hh*0.75, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
				else
					draw.SimpleText( "UNAVAILABLE", "wOS.DescriptionFont", ww*0.04, hh*0.75, Color( 255, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
				end
			else
				draw.SimpleText( "EQUIPPED", "wOS.DescriptionFont", ww*0.04, hh*0.75, Color( 0, 128, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )			
			end
		end
		
	end
	self.SkillInfoPanel.Think = function( pan )
		pan:SetPos( gui.MouseX() + 15, gui.MouseY() + 15 )
	end

	local reset = vgui.Create( "DButton", self.ClassicMenu )
	reset:SetPos( padx, ch*0.93 + 2*pady )
	reset:SetSize( cw, ch*0.07 - pady )
	reset:SetText( "" )
	reset.Paint = function( pan, ww, hh )
		surface.SetDrawColor( color_white )
		surface.DrawOutlinedRect( 0, 0, ww, hh )
		local color = color_white
		if pan:IsHovered() then
			color = Color( 0, 155, 255, 255 )
		end
		draw.SimpleText( "GO BACK", "wOS.SkillTreeMain", ww/2, hh/2, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	reset.DoClick = function()
		wOS.ALCS.Skills.SkillInfoPanel:Remove()
		wOS.ALCS.Skills.SkillInfoPanel = nil
		wOS.ALCS.Skills.Menu:SetVisible( true )
		self.ClassicMenu:Remove()
		self.ClassicMenu = nil
	end
	
end