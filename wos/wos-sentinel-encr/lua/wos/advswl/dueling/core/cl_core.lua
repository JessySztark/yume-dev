--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2020
	
	Contact: www.wiltostech.com
		
----------------------------------------]]--

wOS = wOS or {}
wOS.ALCS = wOS.ALCS or {}
wOS.ALCS.Dueling = wOS.ALCS.Dueling or {}

local w,h = ScrW(), ScrH()
local Tex_white = surface.GetTextureID( "vgui/white" )

surface.CreateFont( "wOS.MegaDuelFont", { font = "Roboto Cn", size = h*(48/1200), weight = 1000, antialias = true } )
surface.CreateFont( "wOS.MainDuelFont", { font = "Roboto Cn", size = h*(32/1200), weight = 1000, antialias = true } )
surface.CreateFont( "wOS.MinorDuelFont", { font = "Roboto Cn", size = h*(24/1200), weight = 1000, antialias = true } )
surface.CreateFont( "wOS.InfoDuelFont", { font = "Roboto Cn", size = h*(18/1200), weight = 1000, antialias = true } )

surface.CreateFont( "wOS.3D2D.MainDuel", { font = "Roboto Cn", size = 100, weight = 1000, antialias = true } )
surface.CreateFont( "wOS.3D2D.MinorDuel", { font = "Roboto Cn", size = 80, weight = 800, antialias = true } )
surface.CreateFont( "wOS.3D2D.InfoDuel", { font = "Roboto Cn", size = 60, weight = 500, antialias = true } )

local BGColor = Color( 35, 36, 38, 255 )
local BarColor = Color( 44, 45, 49, 255 )
local ButtonColor = Color( 44, 186, 105, 235 )

local mw, mh = w*0.15, h*0.4

local bw, bh = mw, mh*0.1
local butw, buth = bw*0.4, bh*0.80
local mat_orb = Material("sprites/rollermine_shock")

function wOS.ALCS.Dueling:OpenDuelingMenu() 

	if wOS.ALCS.Dueling.StationMenu then
		wOS.ALCS.Dueling.StationMenu:Remove()
		wOS.ALCS.Dueling.StationMenu = nil
	end
	
	gui.EnableScreenClicker( true )
	self.StationMenu = vgui.Create( "DPanel" )
	self.StationMenu:SetSize( w*0.33, h*0.5 )
	self.StationMenu:SetPos( w*0.5 - w*0.33/2, h*0.25 )

	local fw, fh = self.StationMenu:GetSize()
	
	local mw, mh = fw*0.9, fh*0.8
	
	local formlist = vgui.Create("DScrollPanel", self.StationMenu )
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
	
	local buttonc = vgui.Create( "DButton", self.StationMenu )
	buttonc:SetSize( fw*0.05, fw*0.05 )
	buttonc:SetPos( fw*0.94, fw*0.01 )
	buttonc:SetText( "" )
	buttonc.Paint = function( pan, ww, hh )
		surface.SetDrawColor( Color( 255, 0, 0, 255 ) )
		surface.DrawLine( 0, 0, ww, hh )
		surface.DrawLine( 0, hh, ww, 0 )
	end
	buttonc.DoClick = function()
		self.StationMenu:Remove()
		self.StationMenu = nil
		gui.EnableScreenClicker( false )
	end	
	
	local button1 = vgui.Create( "DButton", self.StationMenu )
	button1:SetSize( fw, fh*0.1 )
	button1:SetPos( 0, fh*0.9 )
	button1:SetText( "" )
	button1.Paint = function( pan, ww, hh )
		if pan:IsHovered() then
			draw.SimpleText( "Refresh Roster", "wOS.TitleFont", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )		
		else
			draw.SimpleText( "Refresh Roster", "wOS.TitleFont", ww/2, hh/2, Color( 75, 75, 75, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
	end
	button1.DoClick = function()
		 wOS.ALCS.Dueling:OpenDuelingMenu()
	end	
	
	local roster = {}
	if not wOS.ALCS.Config.Dueling.StationDistance then
		roster = player.GetAll()
	else
		local maxdist = wOS.ALCS.Config.Dueling.StationDistance^2
		for _, ply in ipairs( player.GetAll() ) do
			if not IsValid( ply ) then continue end
			if !ply:Alive() then continue end
			if ply == LocalPlayer() then continue end
			if ply:GetPos():DistToSqr( LocalPlayer():GetPos() ) > maxdist then continue end
			table.insert( roster, ply )
		end
	end

	for _, ply in ipairs( roster ) do
		if ply == LocalPlayer() then continue end
		local button = vgui.Create( "DButton", formlist )
		button:SetSize( mw, mh*0.1 )
		button:SetPos( 0, offsety )
		button:SetText( "" )
		button.Data = data
		button.User = ply
		button.Paint = function( pan, ww, hh )
			draw.RoundedBox( 0, 0, 0, ww, hh, Color( 175, 175, 175, 255 ) )
			draw.SimpleText( button.User:GetName(), "wOS.TitleFont", hh, hh*0.5, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )			
		end
		button.DoClick = function( pan )
			net.Start( "properties" )
				net.WriteString( "challenge to duel" )
				net.WriteEntity( pan.User )
			net.SendToServer()
			buttonc:DoClick()
		end
		offsety = offsety + mh*0.1 + pady
	end

	self.StationMenu.Paint = function( pan, ww, hh )
		if not vgui.CursorVisible() then gui.EnableScreenClicker( true ) end
		draw.RoundedBox( 3, 0, 0, ww, hh, Color( 25, 25, 25, 245 ) )
		draw.SimpleText( "Duel Station Roster", "wOS.TitleFont", ww/2, hh*0.05, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )	
		if #roster < 1 then
			draw.SimpleText( "NO DUELISTS IN YOUR AREA", "wOS.TitleFont", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )	
		end
	end 
	

end

function wOS.ALCS.Dueling:OpenConfigurationMenu()

	local wep = LocalPlayer():GetActiveWeapon()
	if not IsValid( wep ) then return end
	if wep:GetClass() != "wos_alcs_duelplacer" then return end
	if self.ConfigPanel then return end
	
	local ent = wep:GetSelected()
	if not IsValid( ent ) then return end
	
	gui.EnableScreenClicker( true )
	self.ConfigPanel = vgui.Create( "DFrame" )
	self.ConfigPanel:SetSize( 400, 200)
	self.ConfigPanel:SetTitle( "Duel Dome Config" )
	self.ConfigPanel.Title = ent:GetTitle()
	self.ConfigPanel.Radius = ent:GetRadius()
	self.ConfigPanel:Center()
	local posx, posy = ScrW()*0.2*0.05, ScrH()*0.2*0.13

	local TextEntry = vgui.Create( "DTextEntry", self.ConfigPanel )
	TextEntry:SetPos( 100, 50 )
	TextEntry:SetSize( 200, 50 )
	TextEntry:SetText( self.ConfigPanel.Title )
	TextEntry.OnEnter = function( pan )
		self.ConfigPanel.Title = pan:GetValue()
	end
	
	local TextEntry2 = vgui.Create( "DTextEntry", self.ConfigPanel )
	TextEntry2:SetPos( 100, 125 )
	TextEntry2:SetSize( 200, 50 )
	TextEntry2:SetText( self.ConfigPanel.Radius )
	TextEntry2.OnEnter = function( pan )
	end
	TextEntry2:SetNumeric( true )
	
	self.ConfigPanel.OnClose = function( pan )
		if IsValid( ent ) then
			net.Start( "wOS.ALCS.Dueling.ChangeDome" )
				net.WriteString( TextEntry:GetValue() )
				net.WriteFloat( tonumber( TextEntry2:GetValue() ) )
			net.SendToServer()
			gui.EnableScreenClicker( false )
		end
		self.ConfigPanel:Remove()
		self.ConfigPanel = nil
	end
	
	self.ConfigPanel:MakePopup()

end

function wOS.ALCS.Dueling:CreateChallengeMenu( data )

	if self.MainFrame then
		self.MainFrame:Remove()
		self.MainFrame = nil
		gui.EnableScreenClicker( false )
		return
	end
	
	if not data then return end
	
	local arenas = ents.FindByClass( "wos_duel_dome" )
	local page = 1
	
	local settings = {}
	
	settings.CreditWager = 0
	settings.FightingSpirit = false
	settings.BladesOnly = false
	settings.SpecificWeapon = ""
	settings.TimeLimit = 120
	
	self.MainFrame = vgui.Create( "DPanel" )
	self.MainFrame:SetSize( w, h )
	self.MainFrame.Think = function( pan )
		gui.EnableScreenClicker( true )
	end
	self.MainFrame.Item = wOS.ALCS.Dueling.Spirits[ data.DuelSpirit ] or wOS.ALCS.Dueling.Spirits[ "Spirit of the Duelist" ]
	
	local viewport = vgui.Create( "DPanel", self.MainFrame )
	viewport:SetSize( w*0.4, h*0.3 )
	viewport:SetPos( w*0.05, h*0.6 )
	viewport.Dome = arenas[1]
	viewport.Paint = function( pan, ww, hh )
	
		local x, y = pan:GetPos()
		local ent = pan.Dome
		if not IsValid( ent ) then return end
		local rx, ry = math.sin( CurTime()%360*0.5 ), math.cos( CurTime()%360*0.5 )
		local radius = ent:GetRadius()
		local pos = ent:GetPos()
		local origin = pos - Vector( radius*rx, radius*ry, 0 ) + ent:GetUp()*radius*0.4
		render.RenderView({
			origin = origin,
			angles = ( pos - origin ):Angle(),
			x = x, y = y,
			w = ww, h = hh
		})	
		
		if pan.Dome:GetStarted() then
			draw.RoundedBox( 0, 0, 0, ww, hh, Color( 0, 0, 0, 200 ) )
			draw.SimpleText( "UNAVAILABLE", "wOS.MainDuelFont", ww/2, hh/2, Color( 255, 0, 0 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
		
		surface.SetDrawColor( color_white )
		surface.DrawOutlinedRect( 0, 0, ww, hh )
		
	end
	
	local posx, posy = viewport:GetPos()
	local sw, sh = viewport:GetSize()
	
	local button_left = vgui.Create( "DImageButton", self.MainFrame )
	button_left:SetSize( sw*0.1, sh*0.1 )
	button_left:SetPos( posx, posy + sh/2 - sh*0.05 )
	button_left:SetImage( "wos/crafting/gui/left.png" )
	button_left.DoClick = function( pan )
		if page <= 1 then return end
		surface.PlaySound( "buttons/lightswitch2.wav" )
		page = math.max( page - 1, 1 )
		if not arenas[page] then return end
		viewport.Dome = arenas[page]
	end
	
	local button_right = vgui.Create( "DImageButton", self.MainFrame )
	button_right:SetSize( sw*0.1, sh*0.1 )
	button_right:SetPos( posx + sw - sw*0.1, posy + sh/2 - sh*0.05 )
	button_right:SetImage( "wos/crafting/gui/right.png" )
	button_right.DoClick = function( pan )
		if page >= #arenas then return end
		surface.PlaySound( "buttons/lightswitch2.wav" )
		page = math.min( page + 1, #arenas )
		if not arenas[page] then return end
		viewport.Dome = arenas[page]
	end
	
	local challengebutt = vgui.Create( "DButton", self.MainFrame )
	challengebutt:SetSize( sw*0.25, sh*0.1 )
	challengebutt:SetPos( w*0.75 - sw*0.125, posy + sh - sh*0.18 )
	challengebutt:SetText( "" )
	challengebutt.DoClick = function( pan )
		settings.Dome = viewport.Dome
		net.Start( "wOS.ALCS.Dueling.DuelRequest" )
			net.WriteEntity( data.Defender )
			net.WriteTable( settings )
		net.SendToServer()
		wOS.ALCS.Dueling:CreateChallengeMenu()
	end
	challengebutt.Paint = function( pan, ww, hh )
		local col = color_white
		if pan:IsHovered() then
			col = Color( 0, 125, 175 )
		end
		draw.SimpleText( "CHALLENGE", "wOS.MegaDuelFont", ww/2, hh/2, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	
	local cancelbutt = vgui.Create( "DButton", self.MainFrame )
	cancelbutt:SetSize( sw*0.15, sh*0.1 )
	cancelbutt:SetPos( w*0.75 - sw*0.075, posy + sh - sh*0.05 )
	cancelbutt:SetText( "" )
	cancelbutt.DoClick = function( pan )
		wOS.ALCS.Dueling:CreateChallengeMenu()
	end
	cancelbutt.Paint = function( pan, ww, hh )
		local col = color_white
		if pan:IsHovered() then
			col = Color( 175, 0, 0 )
		end
		draw.SimpleText( "CANCEL", "wOS.MainDuelFont", ww/2, hh/2, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	
	local modelpanel = vgui.Create( "DModelPanel", self.MainFrame )
	modelpanel:SetPos( w*0.55, posy + sh - sh*0.25 - w*0.4 )
	modelpanel:SetSize( w*0.4, w*0.4 )
	modelpanel:SetModel( data.Defender:GetModel() )
	if self.MainFrame.Item then
		modelpanel.Entity:SetSequence( self.MainFrame.Item.Sequence )
	end
	modelpanel.LayoutEntity = function( pan, Entity )
		pan:RunAnimation()
		if Entity:GetCycle() >= 0.99 then
			Entity:SetCycle( 0 )
		end
		Entity:SetAngles( Angle( 0, 90, 0 ) )
	end
	
	local mposx, mposy = modelpanel:GetPos()
	local mw, mh = modelpanel:GetSize()
	
	local fsbutt = vgui.Create( "DButton", self.MainFrame )
	fsbutt:SetSize( sw*0.1, sh*0.1 )
	fsbutt:SetPos( w*0.5 - sw*0.15, h*0.1 - sh*0.05 )
	fsbutt:SetText( "" )
	fsbutt.DoClick = function( pan )
		settings.FightingSpirit = !settings.FightingSpirit
	end
	fsbutt.Paint = function( pan, ww, hh )
		local col = color_white
		if pan:IsHovered() then
			col = Color( 0, 125, 175 )
		end
		draw.SimpleText( "[    ]", "wOS.MegaDuelFont", ww/2, hh/2, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		if settings.FightingSpirit then
			draw.SimpleText( "X", "wOS.MegaDuelFont", ww/2, hh/2, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )		
		end
	end
	
	local hsbutt = vgui.Create( "DButton", self.MainFrame )
	hsbutt:SetSize( sw*0.1, sh*0.1 )
	hsbutt:SetPos( w*0.5 - sw*0.15, h*0.175 - sh*0.05 )
	hsbutt:SetText( "" )
	hsbutt.DoClick = function( pan )
		settings.BladesOnly = !settings.BladesOnly 
	end
	hsbutt.Paint = function( pan, ww, hh )
		local col = color_white
		if pan:IsHovered() then
			col = Color( 0, 125, 175 )
		end
		draw.SimpleText( "[    ]", "wOS.MegaDuelFont", ww/2, hh/2, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		if settings.BladesOnly then
			draw.SimpleText( "X", "wOS.MegaDuelFont", ww/2, hh/2, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )		
		end
	end
	
	local inputBox = vgui.Create("DTextEntry", self.MainFrame )
	inputBox:SetSize( sw*0.25, sh*0.1 )
	inputBox:SetPos( w*0.5 - sw*0.3, h*0.25 - sh*0.05 )
	inputBox:SetText( settings.CreditWager )
	inputBox:SetFont( "wOS.MegaDuelFont" )
	inputBox:SetUpdateOnType( true )
	inputBox:SetNumeric( true )
	inputBox.Flash = 0
	inputBox.Colors = {
		Background = Color(65, 64, 69),
		Highlight = Color(58, 99, 144),
		Text = color_white
	}
	inputBox.Colors.Focus = {
		Outline = Color( 0, 125, 175, 255 )
	}
	inputBox.Paint = function( self, ww, hh )
		if inputBox.Flash < CurTime() then
			surface.SetDrawColor( color_white )
		else
			surface.SetDrawColor( Color( 255, 255*math.cos( CurTime()*20 ), 255*math.cos( CurTime()*20 ), 255 ) )
		end
		surface.DrawLine( 0, hh*0.98, ww, hh*0.98 )
		self:DrawTextEntryText(self.Colors.Text, self.Colors.Highlight, self.Colors.Text)
		if (self:HasFocus()) then
			surface.SetDrawColor(self.Colors.Focus.Outline)
			surface.DrawLine( 0, hh*0.98, ww, hh*0.98 )
		end
	end
	inputBox.OnValueChange = function( pan, val )
		local num = tonumber( val )
		if not num then return end
		if num < 0 then return end
		settings.CreditWager = num
	end
	inputBox:MakePopup()
	
	local inputBox2 = vgui.Create("DTextEntry", self.MainFrame )
	inputBox2:SetSize( sw*0.25, sh*0.1 )
	inputBox2:SetPos( w*0.5 - sw*0.3, h*0.325 - sh*0.05 )
	inputBox2:SetText( settings.TimeLimit )
	inputBox2:SetFont( "wOS.MegaDuelFont" )
	inputBox2:SetUpdateOnType( true )
	inputBox2:SetNumeric( true )
	inputBox2.Flash = 0
	inputBox2.Colors = {
		Background = Color(65, 64, 69),
		Highlight = Color(58, 99, 144),
		Text = color_white
	}
	inputBox2.Colors.Focus = {
		Outline = Color( 0, 125, 175, 255 )
	}
	inputBox2.Paint = function( self, ww, hh )
		if inputBox2.Flash < CurTime() then
			surface.SetDrawColor( color_white )
		else
			surface.SetDrawColor( Color( 255, 255*math.cos( CurTime()*20 ), 255*math.cos( CurTime()*20 ), 255 ) )
		end
		surface.DrawLine( 0, hh*0.98, ww, hh*0.98 )
		self:DrawTextEntryText(self.Colors.Text, self.Colors.Highlight, self.Colors.Text)
		if (self:HasFocus()) then
			surface.SetDrawColor(self.Colors.Focus.Outline)
			surface.DrawLine( 0, hh*0.98, ww, hh*0.98 )
		end
	end
	inputBox2.OnValueChange = function( pan, val )
		local num = tonumber( val )
		if not num then return end
		if num < 0 then return end
		settings.TimeLimit = num
	end
	inputBox2:MakePopup()
	
	self.MainFrame.Paint = function( pan, ww, hh )
		draw.RoundedBox( 0, 0, 0, ww, hh, color_black )
		
		local padx = ww*0.03
		
		local tx, ty = draw.SimpleText( "FIGHTING SPIRIT", "wOS.MegaDuelFont", posx, hh*0.1, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )		
		local lasty = hh*0.1 + ty
		
		local ftext = "FIGHTING SPIRIT IS DISABLED! NO BONUSES OR ENERGY GAINED"
		if settings.FightingSpirit then
			ftext = "FIGHTING SPIRIT IS ENABLED! BONUS EXPERIENCE AND SPIRIT DRAIN WILL APPLY"
		end
		tx, ty = draw.SimpleText( ftext, "wOS.InfoDuelFont", posx, lasty, ( settings.FightingSpirit and Color( 255, 0, 0 ) ) or Color( 0, 255, 0 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		
		tx, ty = draw.SimpleText( "HONOR BOUND", "wOS.MegaDuelFont", posx, hh*0.175, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )		
		lasty = hh*0.175 + ty
		
		local ftext = "HONOR BOUND IS DISABLED! FORCE POWERS AND DEVESTATORS MAY BE USED"
		if settings.BladesOnly then
			ftext = "HONOR BOUND IS ENABLED! NOTHING MORE THAN YOUR WEAPON MAY BE USED"
		end
		tx, ty = draw.SimpleText( ftext, "wOS.InfoDuelFont", posx, lasty, ( settings.BladesOnly and Color( 255, 0, 0 ) ) or Color( 0, 255, 0 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )

		tx, ty = draw.SimpleText( "CREDIT WAGER", "wOS.MegaDuelFont", posx, hh*0.25, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )		
		lasty = hh*0.25 + ty
		tx, ty = draw.SimpleText( "HOW MUCH CREDITS ARE YOU WILLING TO LOSE?", "wOS.InfoDuelFont", posx, lasty, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		
		tx, ty = draw.SimpleText( "DUEL TIME", "wOS.MegaDuelFont", posx, hh*0.325, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )		
		lasty = hh*0.325 + ty
		tx, ty = draw.SimpleText( "HOW LONG BEFORE THE DUEL ENDS IN STALEMATE? ( IN SECONDS )", "wOS.InfoDuelFont", posx, lasty, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )

		
		lasty = lasty + ty			
		
		draw.SimpleText( "CHOOSE YOUR ARENA", "wOS.MainDuelFont", posx + sw/2, posy - hh*0.015, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		if viewport.Dome then
			draw.SimpleText( string.upper( viewport.Dome:GetTitle() ), "wOS.MainDuelFont", posx + sw/2, posy + sh + hh*0.015, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )		
			draw.SimpleText( "RADIUS: " .. viewport.Dome:GetRadius() .. " UNITS", "wOS.InfoDuelFont", posx + sw/2, posy + sh + hh*0.033, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		else
			draw.SimpleText( "NO ARENAS AVAILABLE", "wOS.MainDuelFont", posx + sw/2, posy + sh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )		
		end
		
		surface.SetDrawColor( color_white )
		surface.DrawLine( ww/2, h*0.08, ww/2, hh*0.92 )
		
		draw.SimpleText( "Combat Level: " .. data.CombatLevel, "wOS.MegaDuelFont", mposx, mposy + mh - mh*0.12, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )	
		draw.SimpleText( "Proficiency Level: " .. data.Proficiency, "wOS.MainDuelFont", mposx, mposy + mh - mh*0.07, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )	

		tx, ty = draw.SimpleText( data.Defender:Nick(), "wOS.MegaDuelFont", mposx + mw/2, hh*0.1, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
		lasty = hh*0.1 + ty
		local item = pan.Item
		if not item then return end
		
		tx, ty = draw.SimpleText( item.DuelTitle, "wOS.MainDuelFont", mposx + mw/2, lasty, item.RarityColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
		lasty = lasty + ty		
		tx, ty = draw.SimpleText( "[ " .. item.Name .. " ]", "wOS.MinorDuelFont", mposx + mw/2, lasty, item.RarityColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )	
		lasty = lasty + ty	
		tx, ty = draw.SimpleText( "WON: " .. data.DuelWins .. "      |      LOST: " .. data.DuelLosses, "wOS.MegaDuelFont", mposx + mw/2, lasty + mh*0.03, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
		
	end
	
end

function wOS.ALCS.Dueling:CreateDefendMenu( data, settings )

	if self.DMainFrame then
		self.DMainFrame:Remove()
		self.DMainFrame = nil
		gui.EnableScreenClicker( false )
		return
	end
	
	if not data then return end
	
	self.DMainFrame = vgui.Create( "DPanel" )
	self.DMainFrame:SetSize( w, h )
	self.DMainFrame.Think = function( pan )
		gui.EnableScreenClicker( true )
	end
	self.DMainFrame.Item = wOS.ALCS.Dueling.Spirits[ data.DuelSpirit ] or wOS.ALCS.Dueling.Spirits[ "Spirit of the Duelist" ]
	
	local viewport = vgui.Create( "DPanel", self.DMainFrame )
	viewport:SetSize( w*0.4, h*0.3 )
	viewport:SetPos( w*0.05, h*0.6 )
	viewport.Dome = settings.Dome
	viewport.Paint = function( pan, ww, hh )
	
		local x, y = pan:GetPos()
		local ent = pan.Dome
		if not IsValid( ent ) then return end
		local rx, ry = math.sin( CurTime()%360*0.5 ), math.cos( CurTime()%360*0.5 )
		local radius = ent:GetRadius()
		local pos = ent:GetPos()
		local origin = pos - Vector( radius*rx, radius*ry, 0 ) + ent:GetUp()*radius*0.4
		render.RenderView({
			origin = origin,
			angles = ( pos - origin ):Angle(),
			x = x, y = y,
			w = ww, h = hh
		})	
		
		surface.SetDrawColor( color_white )
		surface.DrawOutlinedRect( 0, 0, ww, hh )
		
	end
	
	local posx, posy = viewport:GetPos()
	local sw, sh = viewport:GetSize()

	local challengebutt = vgui.Create( "DButton", self.DMainFrame )
	challengebutt:SetSize( sw*0.5, sh*0.1 )
	challengebutt:SetPos( w*0.75 - sw*0.25, posy + sh - sh*0.18 )
	challengebutt:SetText( "" )
	challengebutt.DoClick = function( pan )
		if not IsValid( self.ChallengeQueue ) then return end
		if not self.ChallengeQueue.List[1] then return end
		net.Start( "wOS.ALCS.Dueling.DuelAccept" )
			net.WriteEntity( data.Challenger )
			net.WriteTable( settings )
		net.SendToServer()
		wOS.ALCS.Dueling:CreateDefendMenu()
	end
	challengebutt.Paint = function( pan, ww, hh )
		local col = color_white
		if pan:IsHovered() then
			col = Color( 0, 125, 175 )
		end
		draw.SimpleText( "ACCEPT CHALLENGE", "wOS.MegaDuelFont", ww/2, hh/2, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	
	local cancelbutt = vgui.Create( "DButton", self.DMainFrame )
	cancelbutt:SetSize( sw*0.15, sh*0.1 )
	cancelbutt:SetPos( w*0.75 - sw*0.075, posy + sh - sh*0.05 )
	cancelbutt:SetText( "" )
	cancelbutt.DoClick = function( pan )
		wOS.ALCS.Dueling:CreateDefendMenu()
	end
	cancelbutt.Paint = function( pan, ww, hh )
		local col = color_white
		if pan:IsHovered() then
			col = Color( 175, 0, 0 )
		end
		draw.SimpleText( "REJECT", "wOS.MainDuelFont", ww/2, hh/2, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	
	local modelpanel = vgui.Create( "DModelPanel", self.DMainFrame )
	modelpanel:SetPos( w*0.55, posy + sh - sh*0.25 - w*0.4 )
	modelpanel:SetSize( w*0.4, w*0.4 )
	modelpanel:SetModel( data.Challenger:GetModel() )
	modelpanel.Entity:SetSequence( self.DMainFrame.Item.Sequence )
	modelpanel.LayoutEntity = function( pan, Entity )
		pan:RunAnimation()
		if Entity:GetCycle() >= 0.99 then
			Entity:SetCycle( 0 )
		end
		Entity:SetAngles( Angle( 0, 90, 0 ) )
	end
	
	local mposx, mposy = modelpanel:GetPos()
	local mw, mh = modelpanel:GetSize()
	
	local fsbutt = vgui.Create( "DLabel", self.DMainFrame )
	fsbutt:SetSize( sw*0.1, sh*0.1 )
	fsbutt:SetPos( w*0.5 - sw*0.15, h*0.1 - sh*0.05 )
	fsbutt:SetText( "" )
	fsbutt.Paint = function( pan, ww, hh )
		local col = color_white
		draw.SimpleText( "[    ]", "wOS.MegaDuelFont", ww/2, hh/2, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		if settings.FightingSpirit then
			draw.SimpleText( "X", "wOS.MegaDuelFont", ww/2, hh/2, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )		
		end
	end
	
	local hsbutt = vgui.Create( "DLabel", self.DMainFrame )
	hsbutt:SetSize( sw*0.1, sh*0.1 )
	hsbutt:SetPos( w*0.5 - sw*0.15, h*0.175 - sh*0.05 )
	hsbutt:SetText( "" )
	hsbutt.Paint = function( pan, ww, hh )
		local col = color_white
		draw.SimpleText( "[    ]", "wOS.MegaDuelFont", ww/2, hh/2, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		if settings.BladesOnly then
			draw.SimpleText( "X", "wOS.MegaDuelFont", ww/2, hh/2, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )		
		end
	end
	
	local hsbutt = vgui.Create( "DLabel", self.DMainFrame )
	hsbutt:SetSize( sw*0.4, sh*0.1 )
	hsbutt:SetPos( w*0.5 - sw*0.45, h*0.25 - sh*0.05 )
	hsbutt:SetText( "" )
	hsbutt.Paint = function( pan, ww, hh )
		draw.SimpleText( settings.CreditWager, "wOS.MegaDuelFont", ww, hh/2, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
	end
	
	local hsbutt = vgui.Create( "DLabel", self.DMainFrame )
	hsbutt:SetSize( sw*0.4, sh*0.1 )
	hsbutt:SetPos( w*0.5 - sw*0.45, h*0.325 - sh*0.05 )
	hsbutt:SetText( "" )
	hsbutt.Paint = function( pan, ww, hh )
		draw.SimpleText( settings.TimeLimit, "wOS.MegaDuelFont", ww, hh/2, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
	end
	
	self.DMainFrame.Paint = function( pan, ww, hh )
		draw.RoundedBox( 0, 0, 0, ww, hh, color_black )
		
		local padx = ww*0.03
		
		local tx, ty = draw.SimpleText( "FIGHTING SPIRIT", "wOS.MegaDuelFont", posx, hh*0.1, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )		
		local lasty = hh*0.1 + ty
		
		local ftext = "FIGHTING SPIRIT IS DISABLED! NO BONUSES OR ENERGY GAINED"
		if settings.FightingSpirit then
			ftext = "FIGHTING SPIRIT IS ENABLED! BONUS EXPERIENCE AND SPIRIT DRAIN WILL APPLY"
		end
		tx, ty = draw.SimpleText( ftext, "wOS.InfoDuelFont", posx, lasty, ( settings.FightingSpirit and Color( 255, 0, 0 ) ) or Color( 0, 255, 0 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		
		tx, ty = draw.SimpleText( "HONOR BOUND", "wOS.MegaDuelFont", posx, hh*0.175, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )		
		lasty = hh*0.175 + ty
		
		local ftext = "HONOR BOUND IS DISABLED! FORCE POWERS AND DEVESTATORS MAY BE USED"
		if settings.BladesOnly then
			ftext = "HONOR BOUND IS ENABLED! NOTHING MORE THAN YOUR WEAPON MAY BE USED"
		end
		tx, ty = draw.SimpleText( ftext, "wOS.InfoDuelFont", posx, lasty, ( settings.BladesOnly and Color( 255, 0, 0 ) ) or Color( 0, 255, 0 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )

		tx, ty = draw.SimpleText( "CREDIT WAGER", "wOS.MegaDuelFont", posx, hh*0.25, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )		
		lasty = hh*0.25 + ty
		tx, ty = draw.SimpleText( "YOU WILL BE GAMBLING THIS MANY CREDITS", "wOS.InfoDuelFont", posx, lasty, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		
		tx, ty = draw.SimpleText( "DUEL TIME", "wOS.MegaDuelFont", posx, hh*0.325, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )		
		lasty = hh*0.325 + ty
		tx, ty = draw.SimpleText( "THE DUEL WILL LAST THIS MANY SECONDS", "wOS.InfoDuelFont", posx, lasty, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )

		
		lasty = lasty + ty			
		
		draw.SimpleText( "SELECTED ARENA", "wOS.MainDuelFont", posx + sw/2, posy - hh*0.015, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		if viewport.Dome then
			draw.SimpleText( string.upper( viewport.Dome:GetTitle() ), "wOS.MainDuelFont", posx + sw/2, posy + sh + hh*0.015, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )		
			draw.SimpleText( "RADIUS: " .. viewport.Dome:GetRadius() .. " UNITS", "wOS.InfoDuelFont", posx + sw/2, posy + sh + hh*0.033, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		else
			draw.SimpleText( "ARENA CAM UNAVAILABLE", "wOS.MainDuelFont", posx + sw/2, posy + sh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )		
		end
		
		surface.SetDrawColor( color_white )
		surface.DrawLine( ww/2, h*0.08, ww/2, hh*0.92 )
		
		draw.SimpleText( "Combat Level: " .. data.CombatLevel, "wOS.MegaDuelFont", mposx, mposy + mh - mh*0.12, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )	
		draw.SimpleText( "Proficiency Level: " .. data.Proficiency, "wOS.MainDuelFont", mposx, mposy + mh - mh*0.07, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )	

		tx, ty = draw.SimpleText( data.Challenger:Nick(), "wOS.MegaDuelFont", mposx + mw/2, hh*0.1, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
		lasty = hh*0.1 + ty
		local item = pan.Item
		if not item then return end
		
		tx, ty = draw.SimpleText( item.DuelTitle, "wOS.MainDuelFont", mposx + mw/2, lasty, item.RarityColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
		lasty = lasty + ty		
		tx, ty = draw.SimpleText( "[ " .. item.Name .. " ]", "wOS.MinorDuelFont", mposx + mw/2, lasty, item.RarityColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )	
		lasty = lasty + ty	
		tx, ty = draw.SimpleText( "WON: " .. data.DuelWins .. "      |      LOST: " .. data.DuelLosses, "wOS.MegaDuelFont", mposx + mw/2, lasty + mh*0.03, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
		
	end
	
end

function wOS.ALCS.Dueling:AddChallenge( data, settings )

	local item = wOS.ALCS.Dueling.Spirits[ data.DuelSpirit ] or wOS.ALCS.Dueling.Spirits[ "Spirit of the Duelist" ]

	if IsValid( self.ChallengeQueue ) then
		table.insert( self.ChallengeQueue.List, { data = data, settings = settings, time = CurTime() } )
		surface.PlaySound( item.ChallengeSound )	
		return
	end

	self.ChallengeQueue = vgui.Create( "DFrame" )

	self.ChallengeQueue:SetSize( w*0.23, h*0.18 )
	self.ChallengeQueue:SetTitle( "" )
	self.ChallengeQueue:ShowCloseButton( false )
	self.ChallengeQueue:SetDraggable( false )
	self.ChallengeQueue:SetPos( 0, h/2 - h*0.09 )
	function self.ChallengeQueue:NextChallenge()
		if not self.List[1] then return end
		for i=1, #self.List do
			self.List[i] = self.List[i+1]
		end
		if not self.List[1] then return end
		self.List[1].time = CurTime()
	end
	self.ChallengeQueue.List = {}
	table.insert( self.ChallengeQueue.List, { data = data, settings = settings, time = CurTime() } )
	
	self.ChallengeQueue.Think = function( pan )
		if self.DMainFrame then
			pan:MoveToBack()
			return
		elseif vgui.CursorVisible() or g_ContextMenu:IsVisible() then
			gui.EnableScreenClicker( true )
			pan:MoveToFront()
		end
		if not pan.List[1] or LocalPlayer():GetNWEntity( "wOS.DuelDome", NULL ):IsValid() then
			self.ChallengeQueue = nil
			pan:Remove()
			gui.EnableScreenClicker( false )
			return
		end
		if pan.List[1].time + wOS.ALCS.Config.Dueling.DuelExpirationTime <= CurTime() then
			pan:NextChallenge()
		end
	end

	local mw, mh = self.ChallengeQueue:GetSize()
	local bw, bh = mw, mh*0.2
	local butw, buth = bw*0.4, bh*0.80

	self.ChallengeQueue.Paint = function( pan, ww, hh )
		local challenge = pan.List[1]
		if not challenge then return end
		draw.RoundedBox( 0, 0, 0, ww, hh, Color( 0, 0, 0, 175 ) ) 
		draw.SimpleText( challenge.data.Challenger:Nick(), "wOS.MainDuelFont", ww/2, hh*0.3, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		draw.SimpleText( "CHALLENGES YOU", "wOS.MainDuelFont", ww/2, hh*0.5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		
		local rat = math.max( 0, ( challenge.time + wOS.ALCS.Config.Dueling.DuelExpirationTime - CurTime() ) )/wOS.ALCS.Config.Dueling.DuelExpirationTime
		draw.RoundedBox( 0, 0, 0, ww*rat, hh*0.1, Color( 255, 255, 255, 175 ) ) 
		
		if #pan.List > 1 then
			local lim = #pan.List - 1
			local ext = ( lim > 1 and "S" ) or ""
			draw.SimpleText( "[ " .. lim .. " OTHER CHALLENGE" .. ext .. " ]", "wOS.InfoDuelFont", ww/2, hh*0.7, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
		
	end
	
	local lowerbar = vgui.Create( "DPanel", self.ChallengeQueue )
	lowerbar:SetSize( bw, bh )
	lowerbar:SetPos( 0, mh - bh )
	lowerbar.Paint = function( panel, ppw, pph )
	  draw.RoundedBox( 0, 0, 0, ppw, pph, Color( 0, 0, 0, 175 ) ) 	
	end
	
	local button = vgui.Create( "DButton", lowerbar )
	button:SetSize( butw, buth )
	button:SetPos( bw*0.05, bh*0.1 )	
	button:SetTextColor( color_white )
	button:SetFont( "wOS.MainDuelFont" )
	button:SetText( "DECLINE" )
	button.Paint = function( panel, pppw, ppph )
	  draw.RoundedBox( 0, 0, 0, pppw, ppph, Color( 175, 0, 0 ) ) 	
	end
	button.DoClick = function( pan )	
		self.ChallengeQueue:NextChallenge()
	end
	
	local button1 = vgui.Create( "DButton", lowerbar )
	button1:SetSize( butw, buth )
	button1:SetPos( bw*0.55, bh*0.1 )
	button1:SetTextColor( color_white )
	button1:SetFont( "wOS.MainDuelFont" )
	button1:SetText( "VIEW INFO" )
	button1.Paint = function( panel, pppw, ppph )
	  draw.RoundedBox( 0, 0, 0, pppw, ppph, Color( 0, 125, 175 ) ) 	
	end
	button1.DoClick = function( pan )
		if not self.ChallengeQueue.List[1] then return end
		wOS.ALCS.Dueling:CreateDefendMenu( self.ChallengeQueue.List[1].data, self.ChallengeQueue.List[1].settings )	
	end
	
	surface.PlaySound( item.ChallengeSound )
	
end

hook.Add( "PostDrawOpaqueRenderables", "wOS.ALCS.Dueling.DuelWireFrames", function()

	if not wOS.ALCS.Dueling.Opponent then return end
	if not wOS.ALCS.Dueling.Opponent.DuelData then return end
	if not wOS.ALCS.Dueling.FadeThrough then return end

	local self = LocalPlayer():GetNWEntity( "wOS.DuelDome", NULL )
	
	if self:IsValid() then
		render.SetColorMaterial( mat_orb )
		render.DrawSphere( self:GetPos(), -1*self:GetRadius(), 75, 75, Color( 0, 125, 175, 175 ) )
		render.DrawSphere( self:GetPos(), self:GetRadius(), 75, 75, Color( 0, 125, 175, 175 ) )
	end
	
end )

hook.Add( "HUDPaint", "wOS.DuelHUD", function()

	if not wOS.ALCS.Dueling.Opponent then return end
	if not wOS.ALCS.Dueling.Opponent.DuelData then return end
	if not wOS.ALCS.Dueling.FadeThrough then return end

	local self = LocalPlayer():GetNWEntity( "wOS.DuelDome", NULL )
	
	if self:IsValid() then
		if not self:GetHasStarted() then return end
		local time = self:GetTimeLimit() - CurTime()
		if not time then return end
		draw.SimpleText( "TIME LEFT: " .. string.FormattedTime( time, "%02i:%02i:%02i" ) , "wOS.MegaDuelFont", w/2, h*0.03, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end

	
end )

local pi = math.pi
hook.Add( "HUDPaint", "wOS.ALCS.Dueling.FadeThrough", function()

	if not wOS.ALCS.Dueling.FadeThrough then return end
	if wOS.ALCS.Dueling.FadeThrough < CurTime() then return end
	
	local tim = math.Clamp( wOS.ALCS.Dueling.FadeThrough - CurTime(), 0, 2 )
	local rat = math.sin( pi*tim*0.5 )
	
	draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 255*rat ) )
	
end )

hook.Add( "PostDrawOpaqueRenderables", "wOS.ALCS.Dueling.TitleCards", function()
	if not wOS.ALCS.Dueling.FadeThrough then return end
	if not wOS.ALCS.Dueling.Opponent then return end
	if not wOS.ALCS.Dueling.Opponent.DuelData then return end
	if not wOS.ALCS.Dueling.IntroSlot then return end
	if not wOS.ALCS.Dueling.IntroTime then return end
	local dome = LocalPlayer():GetNWEntity( "wOS.DuelDome", NULL )
	if !dome:IsValid() then return end
	if wOS.ALCS.Dueling.IntroSlot > 2 then return end
	
	local target = LocalPlayer()
	local data = wOS.ALCS.Dueling.DuelData
	local dat = 1
	if wOS.ALCS.Dueling.IntroSlot > 1 then
		target = wOS.ALCS.Dueling.Opponent
		data = wOS.ALCS.Dueling.Opponent.DuelData
		dat = -1
	end
	 
	local diff = ( dome:GetPos() - target:GetPos() )
	local dir = diff:GetNormalized()
	local dang = diff:Angle()
	
	local scale = 0.1
	local item = wOS.ALCS.Dueling.Spirits[ data.DuelSpirit ] or wOS.ALCS.Dueling.Spirits[ "Spirit of the Duelist" ]
	if not item then return end
	
     cam.Start3D2D(target:GetPos() + Vector( 0, 0, 60 ) + dang:Right()*50*dat, dang + Angle( 0, 90, 80 ), scale )
          draw.DrawText( target:Nick(), "wOS.3D2D.MainDuel", 0, 0, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
		  draw.DrawText( item.DuelTitle, "wOS.3D2D.MinorDuel", 0, 900*scale, item.RarityColor or color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
		  draw.DrawText( item.TagLine, "wOS.3D2D.InfoDuel", 0, 1600*scale, item.RarityColor or color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
     cam.End3D2D()
	 
end )

local slot = 0
hook.Add( "CalcView", "wOS.ALCS.Dueling.IntroCam", function( ply, pos, ang )
	if ( !IsValid( ply ) or !ply:Alive() or ply:InVehicle() or ply:GetViewEntity() != ply ) then return end
	
	if not wOS.ALCS.Dueling.FadeThrough then return end
	if not wOS.ALCS.Dueling.Opponent then return end
	if not wOS.ALCS.Dueling.Opponent.DuelData then return end
	if not wOS.ALCS.Dueling.IntroSlot then return end
	if not wOS.ALCS.Dueling.IntroTime then return end
	local dome = LocalPlayer():GetNWEntity( "wOS.DuelDome", NULL )
	if !dome:IsValid() then return end
	if wOS.ALCS.Dueling.IntroSlot > 2 then return end
	
	if wOS.ALCS.Dueling.IntroTime <= CurTime() + 1 and slot != wOS.ALCS.Dueling.IntroSlot then
		wOS.ALCS.Dueling.FadeThrough = CurTime() + 2
		slot = wOS.ALCS.Dueling.IntroSlot
	end
	if wOS.ALCS.Dueling.IntroTime < CurTime() then
		wOS.ALCS.Dueling.IntroSlot = wOS.ALCS.Dueling.IntroSlot + 1
		wOS.ALCS.Dueling.IntroTime = CurTime() + 6
		return
	end
	
	local target = LocalPlayer()
	local data = wOS.ALCS.Dueling.DuelData
	if wOS.ALCS.Dueling.IntroSlot > 1 then
		target = wOS.ALCS.Dueling.Opponent
		data = wOS.ALCS.Dueling.Opponent.DuelData
	end
	
	local rat = math.max( wOS.ALCS.Dueling.IntroTime - CurTime(), 0 )
	local diff = ( dome:GetPos() - target:GetPos() )
	local dang = diff:Angle()
	local dir = diff:GetNormalized()
	local origin = target:GetPos() + Vector( 0, 0, 60 )
	local pos = origin + dir*40 + dang:Forward()*5 + dang:Forward()*rat*10
	local ang = origin - pos
	 
	return {
		origin = pos,
		angles = ang,
		drawviewer = true
	}

end )

hook.Add( "wOS.ALCS.ShouldDisableCam", "wOS.ALCS.Dueling.Prevent3rdPerson", function()

	if not wOS.ALCS.Dueling.FadeThrough then return end
	if not wOS.ALCS.Dueling.Opponent then return end
	if not wOS.ALCS.Dueling.Opponent.DuelData then return end
	if not wOS.ALCS.Dueling.IntroSlot then return end
	if not wOS.ALCS.Dueling.IntroTime then return end
	if wOS.ALCS.Dueling.IntroSlot > 2 then return end

	return true
	
end )	
