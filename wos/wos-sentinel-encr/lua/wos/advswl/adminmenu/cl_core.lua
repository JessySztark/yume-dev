--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2020
	
	Contact: www.wiltostech.com
		----------------------------------------]]--








































































wOS = wOS or {}
wOS.ALCS = wOS.ALCS or {}
wOS.ALCS.Admin = wOS.ALCS.Admin or {}
wOS.ALCS.Admin.BufferInfo = wOS.ALCS.Admin.BufferInfo or {}

local w,h = ScrW(), ScrH()	
local PLAYER = LocalPlayer()
																									
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

surface.CreateFont( "wOS.AdminMain", {
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

surface.CreateFont( "wOS.AdminFont", {
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

surface.CreateFont( "wOS.ALCS.DescFont",{
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

function wOS.ALCS.Admin:OpenAdminMenu()

	if self.AdminMenu then 
		if self.AdminMenu:IsVisible() then
			self.AdminMenu:Remove()
			self.AdminMenu = nil
			gui.EnableScreenClicker( false )
			return
		end
	end
	
	gui.EnableScreenClicker( true )
	wOS.ALCS.Admin.BufferInfo = {}	
	
	local mw, mh = w*0.5, h*0.5
	
	local padx, pady = mw*0.01, mw*0.01
	local bpady = mh*0.01
	local basew, baseh = mw*0.25, mh 
	local cw, ch = ( basew - 1.5*padx ), baseh - 2*pady
	
	self.AdminMenu = vgui.Create( "DPanel" )
	self.AdminMenu:SetSize( mw, mh )
	self.AdminMenu:Center()
	self.AdminMenu.Color = { r = 25, g = 25, b = 25, a = 155 }
	self.AdminMenu.Paint = function( pan, ww, hh )
		if not vgui.CursorVisible() then gui.EnableScreenClicker( true ) end
		blurpanel( pan )
		draw.RoundedBox( 3, 0, 0, ww, hh, Color( 25, 25, 25, 245 ) )
		surface.SetDrawColor( color_white )
		surface.DrawOutlinedRect( padx, pady, ww*0.25, hh - 2*pady )
		surface.DrawOutlinedRect( ww*0.25 + 2*padx, pady, ww*0.75 - 3*padx, hh - 2*pady )
	end
	
	local PlayerKeys = {}
	local SelectedPlayer = nil
	local PlayerList = vgui.Create( "DListView", self.AdminMenu )
	PlayerList:SetMultiSelect( false )
	PlayerList:AddColumn( "Player" )
	PlayerList:AddColumn( "Steam64" )
	PlayerList:SetPos( mw*0.25 + 3*padx, 2*pady )
	PlayerList:SetSize( mw*0.33, mh - 4*pady )
	PlayerList.PlayerKeys = {}
	PlayerList.RePopulateList = function( pan )
		SelectedPlayer = nil
		pan:Clear()
		PlayerKeys = {}
		local i = 1
		for _, ply in pairs( player.GetAll() ) do
			PlayerKeys[ i ] = ply
			PlayerList:AddLine( ply:Nick(), ply:SteamID64() )
			i = i + 1
		end
	end
	
	self.DataTab = vgui.Create( "DPanel", self.AdminMenu )
	self.DataTab:SetPos( mw*0.58 + 4*padx, 2*pady )
	self.DataTab:SetSize( mw*0.33, mh - 4*pady )
	self.DataTab.Paint = function() end
	self.DataTab.SelectedTab = "OpenSkillLevelMenu"
	
	PlayerList.SelectedPlayer = nil
	PlayerList.OnRowSelected = function( lst, index, pnl )
		SelectedPlayer = PlayerKeys[ index ]
		wOS.ALCS.Admin.BufferInfo = {}
		if not self[ self.DataTab.SelectedTab ] then return end
		self[ self.DataTab.SelectedTab ]( self, SelectedPlayer )
	end
	PlayerList.Think = function( pan )
		if ( !SelectedPlayer or !SelectedPlayer:IsValid() ) and self[ self.DataTab.SelectedTab ] then
			self.DataTab:Clear()
		end
	end
	PlayerList.RePopulateList( PlayerList )

	local AScrollPan = vgui.Create( "DScrollPanel", self.AdminMenu )
	AScrollPan:SetSize( mw*0.25, mh - 2*pady )
	AScrollPan:SetPos( 2*padx, pady )
	AScrollPan.Paint = function( pan, ww, hh ) end

	local sbar = AScrollPan:GetVBar()
	function sbar:Paint( w, h ) end
	function sbar.btnUp:Paint( w, h ) end
	function sbar.btnDown:Paint( w, h ) end
	function sbar.btnGrip:Paint( w, h ) end
	
	local button = vgui.Create( "DButton", self.AdminMenu )
	button:SetSize( mw*0.025, mw*0.025 )
	button:SetPos( mw*0.96, mw*0.015 )
	button:SetText( "" )
	button.Paint = function( pan, ww, hh )
		surface.SetDrawColor( Color( 255, 0, 0, 255 ) )
		surface.DrawLine( 0, 0, ww, hh )
		surface.DrawLine( 0, hh, ww, 0 )
	end
	button.DoClick = function( pan )
		self:OpenAdminMenu()
		gui.EnableScreenClicker( false )
	end	
	
	local base = 2*pady
	local aw, ah = AScrollPan:GetSize()

	local SkillTab = vgui.Create( "DButton", AScrollPan )
	SkillTab:SetPos( padx, base )
	SkillTab:SetSize( aw - 4*padx, mh*0.07 )
	SkillTab:SetText( "" )
	SkillTab.Paint = function( pan, ww, hh )
		local col = Color( 155, 155, 155, 155 )
		if pan:IsDown() then
			col = Color( 0, 55, 155, 155 )
		elseif self.DataTab.SelectedTab == "OpenSkillLevelMenu" then
			col = Color( 55, 110, 210, 155 )
		end
		draw.RoundedBox( 5, 0, 0, ww, hh, col  )
		draw.SimpleText( "Skills Menu", "wOS.AdminFont", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	SkillTab.DoClick = function()
		self.DataTab.SelectedTab = "OpenSkillLevelMenu"
		PlayerList.RePopulateList( PlayerList )
	end
	base = base + 2*pady + mh*0.07
	
	local SkillWLTab = vgui.Create( "DButton", AScrollPan )
	SkillWLTab:SetPos( padx, base )
	SkillWLTab:SetSize( aw - 4*padx, mh*0.07 )
	SkillWLTab:SetText( "" )
	SkillWLTab.Paint = function( pan, ww, hh )
		local col = Color( 155, 155, 155, 155 )
		if pan:IsDown() then
			col = Color( 0, 55, 155, 155 )
		elseif self.DataTab.SelectedTab == "OpenSkillWLMenu" then
			col = Color( 55, 110, 210, 155 )
		end
		draw.RoundedBox( 5, 0, 0, ww, hh, col  )		
		draw.SimpleText( "Whitelist Menu", "wOS.AdminFont", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	SkillWLTab.DoClick = function()
		self.DataTab.SelectedTab = "OpenSkillWLMenu"
		PlayerList.RePopulateList( PlayerList )
	end
	base = base + 2*pady + mh*0.07

	local ProfTab = vgui.Create( "DButton", AScrollPan )
	ProfTab:SetPos( padx, base )
	ProfTab:SetSize( aw - 4*padx, mh*0.07 )
	ProfTab:SetText( "" )
	ProfTab.Paint = function( pan, ww, hh )
		local col = Color( 155, 155, 155, 155 )
		if pan:IsDown() then
			col = Color( 0, 55, 155, 155 )
		elseif self.DataTab.SelectedTab == "OpenProfMenu" then
			col = Color( 55, 110, 210, 155 )
		end
		draw.RoundedBox( 5, 0, 0, ww, hh, col  )		
		draw.SimpleText( "Proficiency Menu", "wOS.AdminFont", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	ProfTab.DoClick = function()
		self.DataTab.SelectedTab = "OpenProfMenu"
		PlayerList.RePopulateList( PlayerList )
	end
	base = base + 2*pady + mh*0.07
	
	local CInvTab = vgui.Create( "DButton", AScrollPan )
	CInvTab:SetPos( padx, base )
	CInvTab:SetSize( aw - 4*padx, mh*0.07 )
	CInvTab:SetText( "" )
	CInvTab.Paint = function( pan, ww, hh )
		local col = Color( 155, 155, 155, 155 )
		if pan:IsDown() then
			col = Color( 0, 55, 155, 155 )
		elseif self.DataTab.SelectedTab == "OpenCraftInvMenu" then
			col = Color( 55, 110, 210, 155 )
		end
		draw.RoundedBox( 5, 0, 0, ww, hh, col  )
		draw.SimpleText( "Inventory Menu", "wOS.AdminFont", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	CInvTab.DoClick = function()
		self.DataTab.SelectedTab = "OpenCraftInvMenu"
		PlayerList.RePopulateList( PlayerList )
	end
	base = base + 2*pady + mh*0.07	
	
	local CMatTab = vgui.Create( "DButton", AScrollPan )
	CMatTab:SetPos( padx, base )
	CMatTab:SetSize( aw - 4*padx, mh*0.07 )
	CMatTab:SetText( "" )
	CMatTab.Paint = function( pan, ww, hh )
		local col = Color( 155, 155, 155, 155 )
		if pan:IsDown() then
			col = Color( 0, 55, 155, 155 )
		elseif self.DataTab.SelectedTab == "OpenCraftMatMenu" then
			col = Color( 55, 110, 210, 155 )
		end
		draw.RoundedBox( 5, 0, 0, ww, hh, col  )
		draw.SimpleText( "Material Menu", "wOS.AdminFont", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	CMatTab.DoClick = function()
		self.DataTab.SelectedTab = "OpenCraftMatMenu"
		PlayerList.RePopulateList( PlayerList )
	end
	base = base + 2*pady + mh*0.07	
	
	local SpawnTab = vgui.Create( "DButton", AScrollPan )
	SpawnTab:SetPos( padx, base )
	SpawnTab:SetSize( aw - 4*padx, mh*0.07 )
	SpawnTab:SetText( "" )
	SpawnTab.Paint = function( pan, ww, hh )
		local col = Color( 155, 155, 155, 155 )
		if pan:IsDown() then
			col = Color( 0, 55, 155, 155 )
		elseif self.DataTab.SelectedTab == "ItemSpawnMenu" then
			col = Color( 55, 110, 210, 155 )
		end
		draw.RoundedBox( 5, 0, 0, ww, hh, col  )
		draw.SimpleText( "Item Spawn Menu", "wOS.AdminFont", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	SpawnTab.DoClick = function()
		self.DataTab.SelectedTab = "ItemSpawnMenu"
		PlayerList.RePopulateList( PlayerList )
		self:OpenSpawnMenu()
	end
	base = base + 2*pady + mh*0.07	
	
	local StoreTab = vgui.Create( "DButton", AScrollPan )
	StoreTab:SetPos( padx, base )
	StoreTab:SetSize( aw - 4*padx, mh*0.07 )
	StoreTab:SetText( "" )
	StoreTab.Paint = function( pan, ww, hh )
		local col = Color( 155, 155, 155, 155 )
		if pan:IsDown() then
			col = Color( 0, 55, 155, 155 )
		elseif self.DataTab.SelectedTab == "OpenStorageMenu" then
			col = Color( 55, 110, 210, 155 )
		end
		draw.RoundedBox( 5, 0, 0, ww, hh, col  )
		draw.SimpleText( "Storage Menu", "wOS.AdminFont", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	StoreTab.DoClick = function()
		self.DataTab.SelectedTab = "OpenStorageMenu"
		PlayerList.RePopulateList( PlayerList )
	end
	base = base + 2*pady + mh*0.07	
	
	local PrestigeTab = vgui.Create( "DButton", AScrollPan )
	PrestigeTab:SetPos( padx, base )
	PrestigeTab:SetSize( aw - 4*padx, mh*0.07 )
	PrestigeTab:SetText( "" )
	PrestigeTab.Paint = function( pan, ww, hh )
		local col = Color( 155, 155, 155, 155 )
		if pan:IsDown() then
			col = Color( 0, 55, 155, 155 )
		elseif self.DataTab.SelectedTab == "OpenPrestigeMenu" then
			col = Color( 55, 110, 210, 155 )
		end
		draw.RoundedBox( 5, 0, 0, ww, hh, col  )
		draw.SimpleText( "Prestige Menu", "wOS.AdminFont", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	PrestigeTab.DoClick = function()
		self.DataTab.SelectedTab = "OpenPrestigeMenu"
		PlayerList.RePopulateList( PlayerList )
	end
	base = base + 2*pady + mh*0.07	

	local SpiritTab = vgui.Create( "DButton", AScrollPan )
	SpiritTab:SetPos( padx, base )
	SpiritTab:SetSize( aw - 4*padx, mh*0.07 )
	SpiritTab:SetText( "" )
	SpiritTab.Paint = function( pan, ww, hh )
		local col = Color( 155, 155, 155, 155 )
		if pan:IsDown() then
			col = Color( 0, 55, 155, 155 )
		elseif self.DataTab.SelectedTab == "OpenSpiritMenu" then
			col = Color( 55, 110, 210, 155 )
		end
		draw.RoundedBox( 5, 0, 0, ww, hh, col  )
		draw.SimpleText( "Spirit Menu", "wOS.AdminFont", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	SpiritTab.DoClick = function()
		self.DataTab.SelectedTab = "OpenSpiritMenu"
		PlayerList.RePopulateList( PlayerList )
	end
	base = base + 2*pady + mh*0.07	

	local SpiritTab = vgui.Create( "DButton", AScrollPan )
	SpiritTab:SetPos( padx, base )
	SpiritTab:SetSize( aw - 4*padx, mh*0.07 )
	SpiritTab:SetText( "" )
	SpiritTab.Paint = function( pan, ww, hh )
		local col = Color( 155, 155, 155, 155 )
		if pan:IsDown() then
			col = Color( 0, 55, 155, 155 )
		elseif self.DataTab.SelectedTab == "OpenArtMenu" then
			col = Color( 55, 110, 210, 155 )
		end
		draw.RoundedBox( 5, 0, 0, ww, hh, col  )
		draw.SimpleText( "Artifact Menu", "wOS.AdminFont", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	SpiritTab.DoClick = function()
		self.DataTab.SelectedTab = "OpenArtMenu"
		PlayerList.RePopulateList( PlayerList )
	end
	base = base + 2*pady + mh*0.07	

	local ExecWLTab = vgui.Create( "DButton", AScrollPan )
	ExecWLTab:SetPos( padx, base )
	ExecWLTab:SetSize( aw - 4*padx, mh*0.07 )
	ExecWLTab:SetText( "" )
	ExecWLTab.Paint = function( pan, ww, hh )
		local col = Color( 155, 155, 155, 155 )
		if pan:IsDown() then
			col = Color( 0, 55, 155, 155 )
		elseif self.DataTab.SelectedTab == "OpenExecWLMenu" then
			col = Color( 55, 110, 210, 155 )
		end
		draw.RoundedBox( 5, 0, 0, ww, hh, col  )		
		draw.SimpleText( "Executions Menu", "wOS.AdminFont", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	ExecWLTab.DoClick = function()
		self.DataTab.SelectedTab = "OpenExecWLMenu"
		PlayerList.RePopulateList( PlayerList )
	end
	base = base + 2*pady + mh*0.07
	
end

function wOS.ALCS.Admin:OpenSkillLevelMenu( ply )
	self.DataTab:Clear()
	local mw, mh = w*0.5, h*0.5
	local padx, pady = mw*0.01, mw*0.01
	local bpady = mh*0.01
	local basew, baseh = mw*0.25, mh 
	local cw, ch = ( basew - 1.5*padx ), baseh - 2*pady
	local ww, hh = self.DataTab:GetSize()
	local posx, posy = self.DataTab:GetPos()
	local possx, possy = self.AdminMenu:GetPos()
	posx = possx + posx
	posy = possy + posy
	local LevelText = vgui.Create( "DLabel", self.DataTab )
	LevelText:SetPos( padx, pady )
	LevelText:SetSize( ww, hh*0.05 )
	LevelText:SetText( "Combat Level: " .. ply:GetSkillLevel() )
	LevelText:SetFont( "wOS.AdminMain" )
	
	local XPText = vgui.Create( "DLabel", self.DataTab )
	XPText:SetPos( padx, 2*pady + hh*0.05 )
	XPText:SetSize( ww, hh*0.05 )
	XPText:SetText( "Experience: " .. ply:GetSkillXP() )
	XPText:SetFont( "wOS.AdminMain" )
	
	local SkText = vgui.Create( "DLabel", self.DataTab )
	SkText:SetPos( padx, 3*pady + hh*0.1 )
	SkText:SetSize( ww, hh*0.05 )
	SkText:SetText( "Skill Points: " .. ply:GetSkillPoints() )
	SkText:SetFont( "wOS.AdminMain" )
	
	local SLevel = vgui.Create( "DButton", self.DataTab )
	SLevel:SetPos( ww*0.6 + 2*padx, 4*pady + hh*0.15 )
	SLevel:SetSize( ww*0.4 - 3*padx, hh*0.05 )
	SLevel:SetText( "" )
	SLevel.Paint = function( pan, ww, hh )
		draw.RoundedBox( 5, 0, 0, ww, hh,  ( pan:IsDown() and Color( 0, 155, 255, 155 ) ) or Color( 155, 155, 155, 155 ) )
		draw.SimpleText( "SET LEVEL", "wOS.ALCS.DescFont", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	local LevelEntry = vgui.Create( "DTextEntry",self.DataTab )
	LevelEntry:MakePopup()
	LevelEntry:SetPos( posx + padx, posy + 4*pady + hh*0.15 )
	LevelEntry:SetSize( ww*0.6, hh*0.05 )
	LevelEntry:SetText( ply:GetSkillLevel() )
	LevelEntry:SetNumeric( true )
	SLevel.DoClick = function()
		net.Start( "wOS.SkillTree.SetLevel" )
			net.WriteString( ply:SteamID64() )
			net.WriteInt( tonumber( LevelEntry:GetValue() ), 32 )
		net.SendToServer()
	end
	
	local SXP = vgui.Create( "DButton", self.DataTab )
	SXP:SetPos( ww*0.6 + 2*padx, 5*pady + hh*0.2 )
	SXP:SetSize( ww*0.4 - 3*padx, hh*0.05 )
	SXP:SetText( "" )
	SXP.Paint = function( pan, ww, hh )
		draw.RoundedBox( 5, 0, 0, ww, hh, ( pan:IsDown() and Color( 0, 55, 155, 155 ) ) or Color( 155, 155, 155, 155 ) )
		draw.SimpleText( "SET XP", "wOS.ALCS.DescFont", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	local XPEntry = vgui.Create( "DTextEntry",self.DataTab )
	XPEntry:MakePopup()
	XPEntry:SetPos( posx + padx, posy + 5*pady + hh*0.2 )
	XPEntry:SetSize( ww*0.6, hh*0.05 )
	XPEntry:SetText( ply:GetSkillXP() )
	XPEntry:SetNumeric( true )
	SXP.DoClick = function()
		net.Start( "wOS.SkillTree.SetXP" )
			net.WriteString( ply:SteamID64() )
			net.WriteInt( tonumber( XPEntry:GetValue() ), 32 )
		net.SendToServer()
	end
	local SKS = vgui.Create( "DButton", self.DataTab )
	SKS:SetPos( ww*0.6 + 2*padx, 6*pady + hh*0.25 )
	SKS:SetSize( ww*0.4 - 3*padx, hh*0.05 )
	SKS:SetText( "" )
	SKS.Paint = function( pan, ww, hh )
		draw.RoundedBox( 5, 0, 0, ww, hh, ( pan:IsDown() and Color( 0, 55, 155, 155 ) ) or Color( 155, 155, 155, 155 ) )
		draw.SimpleText( "SET POINTS", "wOS.ALCS.DescFont", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	local SkillEntry = vgui.Create( "DTextEntry",self.DataTab )
	SkillEntry:MakePopup()
	SkillEntry:SetPos( posx + padx, posy + 6*pady + hh*0.25 )
	SkillEntry:SetSize( ww*0.6, hh*0.05 )
	SkillEntry:SetText( ply:GetSkillPoints() )
	SkillEntry:SetNumeric( true )
	SKS.DoClick = function()
		net.Start( "wOS.SkillTree.SetSkillPoints" )
			net.WriteString( ply:SteamID64() )
			net.WriteInt( tonumber( SkillEntry:GetValue() ), 32 )
		net.SendToServer()
	end
	local AddL = vgui.Create( "DButton", self.DataTab )
	AddL:SetPos( ww*0.6 + 2*padx, 7*pady + hh*0.3 )
	AddL:SetSize( ww*0.4 - 3*padx, hh*0.05 )
	AddL:SetText( "" )
	AddL.Paint = function( pan, ww, hh )
		draw.RoundedBox( 5, 0, 0, ww, hh, ( pan:IsDown() and Color( 0, 55, 155, 155 ) ) or Color( 155, 155, 155, 155 ) )
		draw.SimpleText( "ADD LEVEL", "wOS.ALCS.DescFont", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	local AddLevelEntry = vgui.Create( "DTextEntry",self.DataTab )
	AddLevelEntry:MakePopup()
	AddLevelEntry:SetPos( posx + padx, posy + 7*pady + hh*0.3 )
	AddLevelEntry:SetSize( ww*0.6, hh*0.05 )
	AddLevelEntry:SetText( 0 )
	AddLevelEntry:SetNumeric( true )
	AddL.DoClick = function()
		net.Start( "wOS.SkillTree.AddLevel" )
			net.WriteString( ply:SteamID64() )
			net.WriteInt( tonumber( AddLevelEntry:GetValue() ), 32 )
		net.SendToServer()
	end
	local AddX = vgui.Create( "DButton", self.DataTab )
	AddX:SetPos( ww*0.6 + 2*padx, 8*pady + hh*0.35 )
	AddX:SetSize( ww*0.4 - 3*padx, hh*0.05 )
	AddX:SetText( "" )
	AddX.Paint = function( pan, ww, hh )
		draw.RoundedBox( 5, 0, 0, ww, hh, ( pan:IsDown() and Color( 0, 55, 155, 155 ) ) or Color( 155, 155, 155, 155 ) )
		draw.SimpleText( "ADD XP", "wOS.ALCS.DescFont", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	local AddXPEntry = vgui.Create( "DTextEntry",self.DataTab )
	AddXPEntry:MakePopup()
	AddXPEntry:SetPos( posx + padx, posy + 8*pady + hh*0.35 )
	AddXPEntry:SetSize( ww*0.6, hh*0.05 )
	AddXPEntry:SetText( 0 )
	AddXPEntry:SetNumeric( true )
	AddX.DoClick = function()
		net.Start( "wOS.SkillTree.AddXP" )
			net.WriteString( ply:SteamID64() )
			net.WriteInt( tonumber( AddXPEntry:GetValue() ), 32 )
		net.SendToServer()
	end
	local AddSK = vgui.Create( "DButton", self.DataTab )
	AddSK:SetPos( ww*0.6 + 2*padx, 9*pady + hh*0.4 )
	AddSK:SetSize( ww*0.4 - 3*padx, hh*0.05 )
	AddSK:SetText( "" )
	AddSK.Paint = function( pan, ww, hh )
		draw.RoundedBox( 5, 0, 0, ww, hh, ( pan:IsDown() and Color( 0, 55, 155, 155 ) ) or Color( 155, 155, 155, 155 ) )
		draw.SimpleText( "ADD POINTS", "wOS.ALCS.DescFont", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	local AddSkillEntry = vgui.Create( "DTextEntry",self.DataTab )
	AddSkillEntry:MakePopup()
	AddSkillEntry:SetPos( posx + padx, posy + 9*pady + hh*0.4 )
	AddSkillEntry:SetSize( ww*0.6, hh*0.05 )
	AddSkillEntry:SetText( 0 )
	AddSkillEntry:SetNumeric( true )
	AddSK.DoClick = function()
		net.Start( "wOS.SkillTree.AddSkillPoints" )
			net.WriteString( ply:SteamID64() )
			net.WriteInt( tonumber( AddSkillEntry:GetValue() ), 32 )
		net.SendToServer()
	end
	
	local ResetAll = vgui.Create( "DButton", self.DataTab )
	ResetAll:SetPos( padx, 10*pady + hh*0.45 )
	ResetAll:SetSize( ww - 2*padx, hh*0.05 )
	ResetAll:SetText( "" )
	ResetAll.Paint = function( pan, ww, hh )
		draw.RoundedBox( 5, 0, 0, ww, hh, ( pan:IsDown() and Color( 0, 55, 155, 155 ) ) or Color( 155, 155, 155, 155 ) )
		draw.SimpleText( "RESET ALL", "wOS.ALCS.DescFont", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	ResetAll.DoClick = function()
		net.Start( "wOS.SkillTree.ResetPlayerSkills" )
			net.WriteString( ply:SteamID64() )
		net.SendToServer()
	end			
end

function wOS.ALCS.Admin:OpenSkillWLMenu( ply )

	net.Start( "wOS.SkillTree.AdminRequestSkillWL" )
		net.WriteString( ply:SteamID64() )
	net.SendToServer()
	self.DataTab:Clear()
	
	local mw, mh = w*0.5, h*0.5
	local padx, pady = mw*0.01, mw*0.01
	local bpady = mh*0.01
	local basew, baseh = mw*0.25, mh 
	local cw, ch = ( basew - 1.5*padx ), baseh - 2*pady
	local ww, hh = self.DataTab:GetSize()
	local posx, posy = self.DataTab:GetPos()
	local possx, possy = self.AdminMenu:GetPos()
	posx = possx + posx
	posy = possy + posy
	
	local AddL = vgui.Create( "DButton", self.DataTab )
	AddL:SetPos( ww*0.6 + 2*padx, pady)
	AddL:SetSize( ww*0.4 - 3*padx, hh*0.05 )
	AddL:SetText( "" )
	AddL.Paint = function( pan, ww, hh )
		draw.RoundedBox( 5, 0, 0, ww, hh, ( pan:IsDown() and Color( 0, 55, 155, 155 ) ) or Color( 155, 155, 155, 155 ) )
		draw.SimpleText( "ADD TREE", "wOS.ALCS.DescFont", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	local AddLevelEntry = vgui.Create( "DComboBox",self.DataTab )
	AddLevelEntry:SetPos( padx, pady )
	AddLevelEntry:SetSize( ww*0.6, hh*0.05 )
	AddLevelEntry:SetValue( "" )
	for tree, dat in pairs( wOS.SkillTrees ) do
		AddLevelEntry:AddChoice( tree )
	end
	AddL.DoClick = function()
		local tree = AddLevelEntry:GetSelected()
		if not tree or #tree < 1 then return end
		wOS.ALCS.Admin.BufferInfo = {}
		net.Start( "wOS.SkillTree.AddWL" )
			net.WriteString( tree )
			net.WriteString( ply:SteamID64() )
		net.SendToServer()
	end
	
	local SkillList = vgui.Create( "DListView", self.DataTab )
	SkillList:SetMultiSelect( false )
	SkillList:AddColumn( "Skill Tree" )
	SkillList:SetPos( padx , 2*pady + hh*0.05 )
	SkillList:SetSize( ww - 2*padx, hh*0.8 - 2*pady )
	SkillList.Think = function( pan )
		if not self.BufferInfo.Received then
			pan.Refreshed = false
		else
			if not pan.Refreshed then
				SkillList:Clear()
				for tree, _ in pairs( self.BufferInfo.Data ) do
					SkillList:AddLine( tree )
				end
				pan.Refreshed = true
			end
		end
	end
	
	local RemoveWL = vgui.Create( "DButton", self.DataTab )
	RemoveWL:SetPos( padx, hh*0.85 + pady )
	RemoveWL:SetSize( ww - 2*padx, hh*0.05 )
	RemoveWL:SetText( "" )
	RemoveWL.Paint = function( pan, ww, hh )
		draw.RoundedBox( 5, 0, 0, ww, hh, ( pan:IsDown() and Color( 0, 55, 155, 155 ) ) or Color( 155, 155, 155, 155 ) )
		draw.SimpleText( "REMOVE SELECTED TREE", "wOS.ALCS.DescFont", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	RemoveWL.DoClick = function()
		local sel = SkillList:GetSelectedLine()
		if not sel or sel < 1 then return end
		local dat = SkillList:GetLine( sel )
		if not dat then return end
		local tree = dat:GetColumnText( 1 )
		if not tree or #tree < 1 then return end
		wOS.ALCS.Admin.BufferInfo = {}
		net.Start( "wOS.SkillTree.RemoveWL" )
			net.WriteString( tree )
			net.WriteString( ply:SteamID64() )
		net.SendToServer()
	end	
	
end

function wOS.ALCS.Admin:OpenCraftInvMenu( ply )

	net.Start( "wOS.Crafting.RequestInventory" )
		net.WriteString( ply:SteamID64() )
	net.SendToServer()
	self.DataTab:Clear()
	
	local mw, mh = w*0.5, h*0.5
	local padx, pady = mw*0.01, mw*0.01
	local bpady = mh*0.01
	local basew, baseh = mw*0.25, mh 
	local cw, ch = ( basew - 1.5*padx ), baseh - 2*pady
	local ww, hh = self.DataTab:GetSize()
	local posx, posy = self.DataTab:GetPos()
	local possx, possy = self.AdminMenu:GetPos()
	posx = possx + posx
	posy = possy + posy
	
	
	local ItemList = vgui.Create( "DListView", self.DataTab )
	ItemList:SetMultiSelect( false )
	ItemList:AddColumn( "Item Name" )
	ItemList:SetPos( padx, pady  )
	ItemList:SetSize( ww - 2*padx, hh*0.4 )
	
	//MANUAL SORTING SORT OF!!!
	//Could probably use a function in table.sort but whatever
	local lst = {}
	for item, dat in pairs( wOS.ItemList ) do
		if dat.Type == WOSTYPE.RAWMATERIAL then continue end
		lst[ #lst + 1 ] = item
	end
	table.sort(lst)
	for _, item in pairs( lst ) do
		ItemList:AddLine( item )
	end	
	
	local AddL = vgui.Create( "DButton", self.DataTab )
	AddL:SetPos( padx, 2*pady + hh*0.4 )
	AddL:SetSize( ww - 2*padx, hh*0.05 )
	AddL:SetText( "" )
	AddL.Paint = function( pan, ww, hh )
		draw.RoundedBox( 5, 0, 0, ww, hh, ( pan:IsDown() and Color( 0, 55, 155, 155 ) ) or Color( 155, 155, 155, 155 ) )
		draw.SimpleText( "ADD SELECTED ITEM", "wOS.ALCS.DescFont", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	AddL.DoClick = function()
		local sel = ItemList:GetSelectedLine()
		if not sel or sel < 1 then return end
		local dat = ItemList:GetLine( sel )
		if not dat then return end
		local item = dat:GetColumnText( 1 )
		if not item or #item < 1 then return end
		wOS.ALCS.Admin.BufferInfo = {}
		net.Start( "wOS.Crafting.AdminAddItem" )
			net.WriteString( item )
			net.WriteString( ply:SteamID64() )
		net.SendToServer()
	end	
	
	local InvenList = vgui.Create( "DListView", self.DataTab )
	InvenList:SetMultiSelect( false )
	InvenList:AddColumn( "Slot" )
	InvenList:AddColumn( "Item" )
	InvenList:AddColumn( "Amount" )
	InvenList:SetPos( padx , 3*pady + hh*0.45 )
	InvenList:SetSize( ww - 2*padx, hh*0.4 - 3*pady )
	InvenList.Think = function( pan )
		if not self.BufferInfo.Received then
			pan.Refreshed = false
		else
			if not pan.Refreshed then
				InvenList:Clear()
				for i=1, wOS.ALCS.Config.Crafting.MaxInventorySlots do
					local dat = self.BufferInfo.Data[i]
					local name = dat
					local amount = 1
					if istable( dat ) then
						name = dat.Name
						amount = dat.Amount or 1
					end
					if name == "Empty" then amount = "N/A" end
					InvenList:AddLine( i, name, amount )
				end
				pan.Refreshed = true
			end
		end
	end
	
	local RemoveItem = vgui.Create( "DButton", self.DataTab )
	RemoveItem:SetPos( padx, hh*0.85 + pady )
	RemoveItem:SetSize( ww - 2*padx, hh*0.05 )
	RemoveItem:SetText( "" )
	RemoveItem.Paint = function( pan, ww, hh )
		draw.RoundedBox( 5, 0, 0, ww, hh, ( pan:IsDown() and Color( 0, 55, 155, 155 ) ) or Color( 155, 155, 155, 155 ) )
		draw.SimpleText( "REMOVE SELECTED ITEM", "wOS.ALCS.DescFont", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	RemoveItem.DoClick = function()
		local sel = InvenList:GetSelectedLine()
		if not sel or sel < 1 then return end
		local dat = InvenList:GetLine( sel )
		if not dat then return end
		local item = dat:GetColumnText( 2 )
		if not item or #item < 1 then return end
		wOS.ALCS.Admin.BufferInfo = {}
		net.Start( "wOS.Crafting.AdminRemoveItem" )
			net.WriteString( item )
			net.WriteString( ply:SteamID64() )
		net.SendToServer()
	end	
	
	local ClearSlot = vgui.Create( "DButton", self.DataTab )
	ClearSlot:SetPos( padx, hh*0.9 + 2*pady )
	ClearSlot:SetSize( ww - 2*padx, hh*0.05 )
	ClearSlot:SetText( "" )
	ClearSlot.Paint = function( pan, ww, hh )
		draw.RoundedBox( 5, 0, 0, ww, hh, ( pan:IsDown() and Color( 0, 55, 155, 155 ) ) or Color( 155, 155, 155, 155 ) )
		draw.SimpleText( "CLEAR SELECTED SLOT", "wOS.ALCS.DescFont", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	ClearSlot.DoClick = function()
		local sel = InvenList:GetSelectedLine()
		if not sel or sel < 1 then return end
		local dat = InvenList:GetLine( sel )
		if not dat then return end
		local slot = dat:GetColumnText( 1 )
		if not slot then return end
		wOS.ALCS.Admin.BufferInfo = {}
		net.Start( "wOS.Crafting.AdminClearSlot" )
			net.WriteInt( slot, 32 )
			net.WriteString( ply:SteamID64() )
		net.SendToServer()
	end	
	
end

function wOS.ALCS.Admin:OpenCraftMatMenu( ply )

	net.Start( "wOS.Crafting.RequestMaterials" )
		net.WriteString( ply:SteamID64() )
	net.SendToServer()
	self.DataTab:Clear()
	
	local mw, mh = w*0.5, h*0.5
	local padx, pady = mw*0.01, mw*0.01
	local bpady = mh*0.01
	local basew, baseh = mw*0.25, mh 
	local cw, ch = ( basew - 1.5*padx ), baseh - 2*pady
	local ww, hh = self.DataTab:GetSize()
	local posx, posy = self.DataTab:GetPos()
	local possx, possy = self.AdminMenu:GetPos()
	posx = possx + posx
	posy = possy + posy
	
	
	local ItemList = vgui.Create( "DListView", self.DataTab )
	ItemList:SetMultiSelect( false )
	ItemList:AddColumn( "Item Name" )
	ItemList:SetPos( padx, pady  )
	ItemList:SetSize( ww - 2*padx, hh*0.4 )
	
	//MANUAL SORTING SORT OF!!!
	//Could probably use a function in table.sort but whatever
	local lst = {}
	for item, dat in pairs( wOS.ItemList ) do
		if dat.Type != WOSTYPE.RAWMATERIAL then continue end
		lst[ #lst + 1 ] = item
	end
	table.sort(lst)
	for _, item in pairs( lst ) do
		ItemList:AddLine( item )
	end	
	
	local MatAmt = vgui.Create( "DTextEntry",self.DataTab )
	MatAmt:MakePopup()
	MatAmt:SetPos( posx + padx + ww*0.4, posy + 2*pady + hh*0.4 )
	MatAmt:SetSize( ww*0.6 - 2*padx, hh*0.05 )
	MatAmt:SetText( 0 )
	MatAmt:SetNumeric( true )
	
	local LevelText = vgui.Create( "DLabel", self.DataTab )
	LevelText:SetPos( padx, 2*pady + hh*0.4  )
	LevelText:SetSize( ww*0.4, hh*0.05 )
	LevelText:SetText( "Amount:" )
	LevelText:SetFont( "wOS.AdminMain" )
	
	local AddL = vgui.Create( "DButton", self.DataTab )
	AddL:SetPos( padx, 3*pady + hh*0.45 )
	AddL:SetSize( ww - 2*padx, hh*0.05 )
	AddL:SetText( "" )
	AddL.Paint = function( pan, ww, hh )
		draw.RoundedBox( 5, 0, 0, ww, hh, ( pan:IsDown() and Color( 0, 55, 155, 155 ) ) or Color( 155, 155, 155, 155 ) )
		draw.SimpleText( "ADD SELECTED ITEM", "wOS.ALCS.DescFont", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	AddL.DoClick = function()
		local sel = ItemList:GetSelectedLine()
		if not sel or sel < 1 then return end
		local dat = ItemList:GetLine( sel )
		if not dat then return end
		local item = dat:GetColumnText( 1 )
		if not item or #item < 1 then return end
		local amt = tonumber( MatAmt:GetValue() )
		if amt <= 0 then amt = 0 end
		wOS.ALCS.Admin.BufferInfo = {}
		net.Start( "wOS.Crafting.AdminModMat" )
			net.WriteString( item )
			net.WriteInt( amt, 32 )
			net.WriteBool( true )
			net.WriteString( ply:SteamID64() )
		net.SendToServer()
	end	
	
	local RemL = vgui.Create( "DButton", self.DataTab )
	RemL:SetPos( padx, 4*pady + hh*0.5 )
	RemL:SetSize( ww - 2*padx, hh*0.05 )
	RemL:SetText( "" )
	RemL.Paint = function( pan, ww, hh )
		draw.RoundedBox( 5, 0, 0, ww, hh, ( pan:IsDown() and Color( 0, 55, 155, 155 ) ) or Color( 155, 155, 155, 155 ) )
		draw.SimpleText( "REMOVE SELECTED ITEM", "wOS.ALCS.DescFont", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	RemL.DoClick = function()
		local sel = ItemList:GetSelectedLine()
		if not sel or sel < 1 then return end
		local dat = ItemList:GetLine( sel )
		if not dat then return end
		local item = dat:GetColumnText( 1 )
		if not item or #item < 1 then return end
		local amt = tonumber( MatAmt:GetValue() )
		if amt <= 0 then amt = 0 end
		wOS.ALCS.Admin.BufferInfo = {}
		net.Start( "wOS.Crafting.AdminModMat" )
			net.WriteString( item )
			net.WriteInt( amt, 32 )
			net.WriteBool( false )
			net.WriteString( ply:SteamID64() )
		net.SendToServer()
	end	
	
	local InvenList = vgui.Create( "DListView", self.DataTab )
	InvenList:SetMultiSelect( false )
	InvenList:AddColumn( "Item" )
	InvenList:AddColumn( "Amount" )
	InvenList:SetPos( padx , 5*pady + hh*0.55 )
	InvenList:SetSize( ww - 2*padx, hh*0.4 - 4*pady )
	InvenList.Think = function( pan )
		if not self.BufferInfo.Received then
			pan.Refreshed = false
		else
			if not pan.Refreshed then
				InvenList:Clear()
				for mat, amt in pairs( self.BufferInfo.Data ) do
					InvenList:AddLine( mat, amt )
				end
				pan.Refreshed = true
			end
		end
	end
	
end

function wOS.ALCS.Admin:OpenProfMenu( ply )
	self.DataTab:Clear()
	local mw, mh = w*0.5, h*0.5
	local padx, pady = mw*0.01, mw*0.01
	local bpady = mh*0.01
	local basew, baseh = mw*0.25, mh 
	local cw, ch = ( basew - 1.5*padx ), baseh - 2*pady
	local ww, hh = self.DataTab:GetSize()
	local posx, posy = self.DataTab:GetPos()
	local possx, possy = self.AdminMenu:GetPos()
	posx = possx + posx
	posy = possy + posy
	local LevelText = vgui.Create( "DLabel", self.DataTab )
	LevelText:SetPos( padx, pady )
	LevelText:SetSize( ww, hh*0.05 )
	LevelText:SetText( "Proficiency Level: " .. ply:GetSaberLevel() )
	LevelText:SetFont( "wOS.AdminMain" )
	
	local XPText = vgui.Create( "DLabel", self.DataTab )
	XPText:SetPos( padx, 2*pady + hh*0.05 )
	XPText:SetSize( ww, hh*0.05 )
	XPText:SetText( "Experience: " .. ply:GetSaberXP() )
	XPText:SetFont( "wOS.AdminMain" )
	
	local SLevel = vgui.Create( "DButton", self.DataTab )
	SLevel:SetPos( ww*0.6 + 2*padx, 4*pady + hh*0.15 )
	SLevel:SetSize( ww*0.4 - 3*padx, hh*0.05 )
	SLevel:SetText( "" )
	SLevel.Paint = function( pan, ww, hh )
		draw.RoundedBox( 5, 0, 0, ww, hh,  ( pan:IsDown() and Color( 0, 155, 255, 155 ) ) or Color( 155, 155, 155, 155 ) )
		draw.SimpleText( "SET LEVEL", "wOS.ALCS.DescFont", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	local LevelEntry = vgui.Create( "DTextEntry",self.DataTab )
	LevelEntry:MakePopup()
	LevelEntry:SetPos( posx + padx, posy + 4*pady + hh*0.15 )
	LevelEntry:SetSize( ww*0.6, hh*0.05 )
	LevelEntry:SetText( ply:GetSaberLevel() )
	LevelEntry:SetNumeric( true )
	SLevel.DoClick = function()
		net.Start( "wOS.Proficiency.SetLevel" )
			net.WriteString( ply:SteamID64() )
			net.WriteInt( tonumber( LevelEntry:GetValue() ), 32 )
		net.SendToServer()
	end
	
	local SXP = vgui.Create( "DButton", self.DataTab )
	SXP:SetPos( ww*0.6 + 2*padx, 5*pady + hh*0.2 )
	SXP:SetSize( ww*0.4 - 3*padx, hh*0.05 )
	SXP:SetText( "" )
	SXP.Paint = function( pan, ww, hh )
		draw.RoundedBox( 5, 0, 0, ww, hh, ( pan:IsDown() and Color( 0, 55, 155, 155 ) ) or Color( 155, 155, 155, 155 ) )
		draw.SimpleText( "SET XP", "wOS.ALCS.DescFont", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	local XPEntry = vgui.Create( "DTextEntry",self.DataTab )
	XPEntry:MakePopup()
	XPEntry:SetPos( posx + padx, posy + 5*pady + hh*0.2 )
	XPEntry:SetSize( ww*0.6, hh*0.05 )
	XPEntry:SetText( ply:GetSaberXP() )
	XPEntry:SetNumeric( true )
	SXP.DoClick = function()
		net.Start( "wOS.Proficiency.SetXP" )
			net.WriteString( ply:SteamID64() )
			net.WriteInt( tonumber( XPEntry:GetValue() ), 32 )
		net.SendToServer()
	end

	local AddL = vgui.Create( "DButton", self.DataTab )
	AddL:SetPos( ww*0.6 + 2*padx, 7*pady + hh*0.3 )
	AddL:SetSize( ww*0.4 - 3*padx, hh*0.05 )
	AddL:SetText( "" )
	AddL.Paint = function( pan, ww, hh )
		draw.RoundedBox( 5, 0, 0, ww, hh, ( pan:IsDown() and Color( 0, 55, 155, 155 ) ) or Color( 155, 155, 155, 155 ) )
		draw.SimpleText( "ADD LEVEL", "wOS.ALCS.DescFont", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	local AddLevelEntry = vgui.Create( "DTextEntry",self.DataTab )
	AddLevelEntry:MakePopup()
	AddLevelEntry:SetPos( posx + padx, posy + 7*pady + hh*0.3 )
	AddLevelEntry:SetSize( ww*0.6, hh*0.05 )
	AddLevelEntry:SetText( 0 )
	AddLevelEntry:SetNumeric( true )
	AddL.DoClick = function()
		net.Start( "wOS.Proficiency.AddLevel" )
			net.WriteString( ply:SteamID64() )
			net.WriteInt( tonumber( AddLevelEntry:GetValue() ), 32 )
		net.SendToServer()
	end
	local AddX = vgui.Create( "DButton", self.DataTab )
	AddX:SetPos( ww*0.6 + 2*padx, 8*pady + hh*0.35 )
	AddX:SetSize( ww*0.4 - 3*padx, hh*0.05 )
	AddX:SetText( "" )
	AddX.Paint = function( pan, ww, hh )
		draw.RoundedBox( 5, 0, 0, ww, hh, ( pan:IsDown() and Color( 0, 55, 155, 155 ) ) or Color( 155, 155, 155, 155 ) )
		draw.SimpleText( "ADD XP", "wOS.ALCS.DescFont", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	local AddXPEntry = vgui.Create( "DTextEntry",self.DataTab )
	AddXPEntry:MakePopup()
	AddXPEntry:SetPos( posx + padx, posy + 8*pady + hh*0.35 )
	AddXPEntry:SetSize( ww*0.6, hh*0.05 )
	AddXPEntry:SetText( 0 )
	AddXPEntry:SetNumeric( true )
	AddX.DoClick = function()
		net.Start( "wOS.Proficiency.AddXP" )
			net.WriteString( ply:SteamID64() )
			net.WriteInt( tonumber( AddXPEntry:GetValue() ), 32 )
		net.SendToServer()
	end

end

function wOS.ALCS.Admin:OpenSpawnMenu()
	self.DataTab:Clear()

	local mw, mh = w*0.5, h*0.5
	local padx, pady = mw*0.01, mw*0.01
	local bpady = mh*0.01
	local basew, baseh = mw*0.25, mh 
	local cw, ch = ( basew - 1.5*padx ), baseh - 2*pady
	local ww, hh = self.DataTab:GetSize()
	local posx, posy = self.DataTab:GetPos()
	local possx, possy = self.AdminMenu:GetPos()
	posx = possx + posx
	posy = possy + posy
	
	local ItemList = vgui.Create( "DListView", self.DataTab )
	ItemList:SetMultiSelect( false )
	ItemList:AddColumn( "Item Name" )
	ItemList:SetPos( padx, pady )
	ItemList:SetSize( ww - 2*padx, hh*0.85 )
	
	//MANUAL SORTING SORT OF!!!
	//Could probably use a function in table.sort but whatever
	local lst = {}
	for item, dat in pairs( wOS.ItemList ) do
		lst[ #lst + 1 ] = item
	end
	table.sort(lst)
	for _, item in pairs( lst ) do
		ItemList:AddLine( item )
	end	
	
	local AddL = vgui.Create( "DButton", self.DataTab )
	AddL:SetPos( padx, 2*pady + hh*0.85 )
	AddL:SetSize( ww - 2*padx, hh*0.05 )
	AddL:SetText( "" )
	AddL.Paint = function( pan, ww, hh )
		draw.RoundedBox( 5, 0, 0, ww, hh, ( pan:IsDown() and Color( 0, 55, 155, 155 ) ) or Color( 155, 155, 155, 155 ) )
		draw.SimpleText( "SPAWN SELECTED ITEM", "wOS.ALCS.DescFont", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	AddL.DoClick = function()
		local sel = ItemList:GetSelectedLine()
		if not sel or sel < 1 then return end
		local dat = ItemList:GetLine( sel )
		if not dat then return end
		local item = dat:GetColumnText( 1 )
		if not item or #item < 1 then return end
		wOS.ALCS.Admin.BufferInfo = {}
		net.Start( "wOS.Crafting.AdminSpawnItem" )
			net.WriteString( item )
		net.SendToServer()
	end	
	
end

function wOS.ALCS.Admin:OpenStorageMenu( ply )
	net.Start( "wOS.Storage.RequestStorage" )
		net.WriteString( ply:SteamID64() )
	net.SendToServer()
	self.DataTab:Clear()
	
	local mw, mh = w*0.5, h*0.5
	local padx, pady = mw*0.01, mw*0.01
	local bpady = mh*0.01
	local basew, baseh = mw*0.25, mh 
	local cw, ch = ( basew - 1.5*padx ), baseh - 2*pady
	local ww, hh = self.DataTab:GetSize()
	local posx, posy = self.DataTab:GetPos()
	local possx, possy = self.AdminMenu:GetPos()
	posx = possx + posx
	posy = possy + posy
	
	
	local ItemList = vgui.Create( "DListView", self.DataTab )
	ItemList:SetMultiSelect( false )
	ItemList:AddColumn( "Item Name" )
	ItemList:SetPos( padx, pady  )
	ItemList:SetSize( ww - 2*padx, hh*0.4 )
	
	//MANUAL SORTING SORT OF!!!
	//Could probably use a function in table.sort but whatever
	local lst = {}
	for item, dat in pairs( wOS.ItemList ) do
		if dat.Type == WOSTYPE.RAWMATERIAL then continue end
		lst[ #lst + 1 ] = item
	end
	table.sort(lst)
	for _, item in pairs( lst ) do
		ItemList:AddLine( item )
	end	
	
	local AddL = vgui.Create( "DButton", self.DataTab )
	AddL:SetPos( padx, 2*pady + hh*0.4 )
	AddL:SetSize( ww - 2*padx, hh*0.05 )
	AddL:SetText( "" )
	AddL.Paint = function( pan, ww, hh )
		draw.RoundedBox( 5, 0, 0, ww, hh, ( pan:IsDown() and Color( 0, 55, 155, 155 ) ) or Color( 155, 155, 155, 155 ) )
		draw.SimpleText( "ADD SELECTED ITEM TO SLOT", "wOS.ALCS.DescFont", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end

	local InvenList = vgui.Create( "DListView", self.DataTab )
	InvenList:SetMultiSelect( false )
	InvenList:AddColumn( "Slot" )
	InvenList:AddColumn( "Item" )
	InvenList:AddColumn( "Amount" )
	InvenList:SetPos( padx , 3*pady + hh*0.45 )
	InvenList:SetSize( ww - 2*padx, hh*0.4 - 3*pady )
	InvenList.Think = function( pan )
		if not self.BufferInfo.Received then
			pan.Refreshed = false
		else
			if not pan.Refreshed then
				InvenList:Clear()
				local slots = self.BufferInfo.Data.MaxSlots or wOS.ALCS.Config.Storage.StartingSpace
				for i=1, slots do
					local dat = self.BufferInfo.Data.Backpack[i]
					local name = dat
					local amount = 1
					if istable( dat ) then
						name = dat.Name
						amount = dat.Amount or 1
					end
					if not name then name = "Empty" end
					if name == "Empty" then amount = "N/A" end
					InvenList:AddLine( i, name, amount )
				end
				pan.Refreshed = true
			end
		end
	end
	
	AddL.DoClick = function()
		local sel = ItemList:GetSelectedLine()
		if not sel or sel < 1 then return end
		local dat = ItemList:GetLine( sel )
		if not dat then return end
		local item = dat:GetColumnText( 1 )
		if not item or #item < 1 then return end
		
		local sel2 = InvenList:GetSelectedLine()
		if not sel2 or sel2 < 1 then return end
		local dat = InvenList:GetLine( sel2 )
		if not dat then return end
		local slot = dat:GetColumnText( 1 )
		if not slot then return end
		
		wOS.ALCS.Admin.BufferInfo = {}
		net.Start( "wOS.Storage.AdminAddItem" )
			net.WriteString( item )
			net.WriteInt( tonumber( slot ), 32 )
			net.WriteString( ply:SteamID64() )
		net.SendToServer()
	end	
	
	
	local RemoveItem = vgui.Create( "DButton", self.DataTab )
	RemoveItem:SetPos( padx, hh*0.85 + pady )
	RemoveItem:SetSize( ww - 2*padx, hh*0.05 )
	RemoveItem:SetText( "" )
	RemoveItem.Paint = function( pan, ww, hh )
		draw.RoundedBox( 5, 0, 0, ww, hh, ( pan:IsDown() and Color( 0, 55, 155, 155 ) ) or Color( 155, 155, 155, 155 ) )
		draw.SimpleText( "REMOVE SELECTED ITEM", "wOS.ALCS.DescFont", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	RemoveItem.DoClick = function()
		local sel = InvenList:GetSelectedLine()
		if not sel or sel < 1 then return end
		local dat = InvenList:GetLine( sel )
		if not dat then return end
		local slot = dat:GetColumnText( 1 )
		if not slot then return end
		wOS.ALCS.Admin.BufferInfo = {}
		net.Start( "wOS.Storage.AdminRemoveItem" )
			net.WriteInt( tonumber( slot ), 32 )
			net.WriteString( ply:SteamID64() )
		net.SendToServer()
	end	
	
	local ClearSlot = vgui.Create( "DButton", self.DataTab )
	ClearSlot:SetPos( padx, hh*0.9 + 2*pady )
	ClearSlot:SetSize( ww - 2*padx, hh*0.05 )
	ClearSlot:SetText( "" )
	ClearSlot.Paint = function( pan, ww, hh )
		draw.RoundedBox( 5, 0, 0, ww, hh, ( pan:IsDown() and Color( 0, 55, 155, 155 ) ) or Color( 155, 155, 155, 155 ) )
		draw.SimpleText( "CLEAR SELECTED SLOT", "wOS.ALCS.DescFont", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	ClearSlot.DoClick = function()
		local sel = InvenList:GetSelectedLine()
		if not sel or sel < 1 then return end
		local dat = InvenList:GetLine( sel )
		if not dat then return end
		local slot = dat:GetColumnText( 1 )
		if not slot then return end
		wOS.ALCS.Admin.BufferInfo = {}
		net.Start( "wOS.Storage.AdminClearSlot" )
			net.WriteInt( tonumber( slot ), 32 )
			net.WriteString( ply:SteamID64() )
		net.SendToServer()
	end	
end

function wOS.ALCS.Admin:OpenPrestigeMenu( ply )

	net.Start( "wOS.Prestige.AdminRequestPrestige" )
		net.WriteString( ply:SteamID64() )
	net.SendToServer()
	self.DataTab:Clear()
	
	local mw, mh = w*0.5, h*0.5
	local padx, pady = mw*0.01, mw*0.01
	local bpady = mh*0.01
	local basew, baseh = mw*0.25, mh 
	local cw, ch = ( basew - 1.5*padx ), baseh - 2*pady
	local ww, hh = self.DataTab:GetSize()
	local posx, posy = self.DataTab:GetPos()
	local possx, possy = self.AdminMenu:GetPos()
	posx = possx + posx
	posy = possy + posy
	
	local AddL = vgui.Create( "DButton", self.DataTab )
	AddL:SetPos( ww*0.6 + 2*padx, pady)
	AddL:SetSize( ww*0.4 - 3*padx, hh*0.05 )
	AddL:SetText( "" )
	AddL.Paint = function( pan, ww, hh )
		draw.RoundedBox( 5, 0, 0, ww, hh, ( pan:IsDown() and Color( 0, 55, 155, 155 ) ) or Color( 155, 155, 155, 155 ) )
		draw.SimpleText( "ADD MASTERY", "wOS.ALCS.DescFont", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	local AddLevelEntry = vgui.Create( "DComboBox",self.DataTab )
	AddLevelEntry:SetPos( padx, pady )
	AddLevelEntry:SetSize( ww*0.6, hh*0.05 )
	AddLevelEntry:SetValue( "" )
	local id_trans = {}
	for slot, dat in pairs( wOS.ALCS.Prestige.MapData.Paths ) do
		AddLevelEntry:AddChoice( dat.Name )
		id_trans[ dat.Name ] = slot
	end
	
	AddL.DoClick = function()
		local tree = AddLevelEntry:GetSelected()
		if not tree or #tree < 1 then return end
		local id = id_trans[ tree ]
		if not id then return end
		wOS.ALCS.Admin.BufferInfo = {}
		net.Start( "wOS.Prestige.AdminAddPrestigeMastery" )
			net.WriteInt( id, 32 )
			net.WriteString( ply:SteamID64() )
		net.SendToServer()
	end
	
	local SkillList = vgui.Create( "DListView", self.DataTab )
	SkillList:SetMultiSelect( false )
	SkillList:AddColumn( "ID" )
	SkillList:AddColumn( "Mastery Name" )
	SkillList:SetPos( padx , 2*pady + hh*0.05 )
	SkillList:SetSize( ww - 2*padx, hh*0.6 - 2*pady )
	SkillList.Think = function( pan )
		if not self.BufferInfo.Received then
			pan.Refreshed = false
		else
			if not pan.Refreshed then
				SkillList:Clear()
				for mastery, _ in pairs( self.BufferInfo.Data.Mastery ) do
					local mdat = wOS.ALCS.Prestige.MapData.Paths[ mastery ]
					if not mdat then continue end
					SkillList:AddLine( mastery, mdat.Name )
				end
				pan.Refreshed = true
			end
		end
	end
	
	local RemoveWL = vgui.Create( "DButton", self.DataTab )
	RemoveWL:SetPos( padx, hh*0.65 + pady )
	RemoveWL:SetSize( ww - 2*padx, hh*0.05 )
	RemoveWL:SetText( "" )
	RemoveWL.Paint = function( pan, ww, hh )
		draw.RoundedBox( 5, 0, 0, ww, hh, ( pan:IsDown() and Color( 0, 55, 155, 155 ) ) or Color( 155, 155, 155, 155 ) )
		draw.SimpleText( "REMOVE SELECTED MASTERY", "wOS.ALCS.DescFont", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	RemoveWL.DoClick = function()
		local sel = SkillList:GetSelectedLine()
		if not sel or sel < 1 then return end
		local dat = SkillList:GetLine( sel )
		if not dat then return end
		local ID = dat:GetColumnText( 1 )
		if not ID then return end
		wOS.ALCS.Admin.BufferInfo = {}
		net.Start( "wOS.Prestige.AdminRemovePrestigeMastery" )
			net.WriteInt( ID, 32 )
			net.WriteString( ply:SteamID64() )
		net.SendToServer()
	end	
	
	local AddX = vgui.Create( "DButton", self.DataTab )
	AddX:SetPos( ww*0.6 + 2*padx, 2*pady + hh*0.7 )
	AddX:SetSize( ww*0.4 - 3*padx, hh*0.05 )
	AddX:SetText( "" )
	AddX.Paint = function( pan, ww, hh )
		draw.RoundedBox( 5, 0, 0, ww, hh, ( pan:IsDown() and Color( 0, 55, 155, 155 ) ) or Color( 155, 155, 155, 155 ) )
		draw.SimpleText( "ADD TOKENS", "wOS.ALCS.DescFont", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	local AddXPEntry = vgui.Create( "DTextEntry",self.DataTab )
	AddXPEntry:MakePopup()
	AddXPEntry:SetPos( posx + padx, posy + 2*pady + hh*0.7 )
	AddXPEntry:SetSize( ww*0.6, hh*0.05 )
	AddXPEntry:SetText( 0 )
	AddXPEntry:SetNumeric( true )
	AddX.DoClick = function()
		wOS.ALCS.Admin.BufferInfo = {}
		net.Start( "wOS.Prestige.AdminSetPrestigeTokens" )
			net.WriteString( ply:SteamID64() )
			net.WriteInt( tonumber( AddXPEntry:GetValue() ), 32 )
		net.SendToServer()
	end
	local AddSK = vgui.Create( "DButton", self.DataTab )
	AddSK:SetPos( ww*0.6 + 2*padx, 3*pady + hh*0.75 )
	AddSK:SetSize( ww*0.4 - 3*padx, hh*0.05 )
	AddSK:SetText( "" )
	AddSK.Paint = function( pan, ww, hh )
		draw.RoundedBox( 5, 0, 0, ww, hh, ( pan:IsDown() and Color( 0, 55, 155, 155 ) ) or Color( 155, 155, 155, 155 ) )
		draw.SimpleText( "ADD LEVEL", "wOS.ALCS.DescFont", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	local AddSkillEntry = vgui.Create( "DTextEntry",self.DataTab )
	AddSkillEntry:MakePopup()
	AddSkillEntry:SetPos( posx + padx, posy + 3*pady + hh*0.75 )
	AddSkillEntry:SetSize( ww*0.6, hh*0.05 )
	AddSkillEntry:SetText( 0 )
	AddSkillEntry:SetNumeric( true )
	AddSK.DoClick = function()
		wOS.ALCS.Admin.BufferInfo = {}
		net.Start( "wOS.Prestige.AdminSetPrestigeLevel" )
			net.WriteString( ply:SteamID64() )
			net.WriteInt( tonumber( AddSkillEntry:GetValue() ), 32 )
		net.SendToServer()
	end
	
end

function wOS.ALCS.Admin:OpenSpiritMenu( ply )

	net.Start( "wOS.Dueling.RequestSpiritData" )
		net.WriteString( ply:SteamID64() )
	net.SendToServer()
	self.DataTab:Clear()
	
	local mw, mh = w*0.5, h*0.5
	local padx, pady = mw*0.01, mw*0.01
	local bpady = mh*0.01
	local basew, baseh = mw*0.25, mh 
	local cw, ch = ( basew - 1.5*padx ), baseh - 2*pady
	local ww, hh = self.DataTab:GetSize()
	local posx, posy = self.DataTab:GetPos()
	local possx, possy = self.AdminMenu:GetPos()
	posx = possx + posx
	posy = possy + posy
	
	
	local SpiritList = vgui.Create( "DListView", self.DataTab )
	SpiritList:SetMultiSelect( false )
	SpiritList:AddColumn( "Spirit Name" )
	SpiritList:SetPos( padx, pady  )
	SpiritList:SetSize( ww - 2*padx, hh*0.4 )
	
	//MANUAL SORTING SORT OF!!!
	//Could probably use a function in table.sort but whatever
	local lst = {}
	for item, dat in pairs( wOS.ALCS.Dueling.Spirits ) do
		lst[ #lst + 1 ] = item
	end

	table.sort(lst)
	for _, item in pairs( lst ) do
		SpiritList:AddLine( item )
	end	
	
	local AddL = vgui.Create( "DButton", self.DataTab )
	AddL:SetPos( padx, 2*pady + hh*0.4 )
	AddL:SetSize( ww - 2*padx, hh*0.05 )
	AddL:SetText( "" )
	AddL.Paint = function( pan, ww, hh )
		draw.RoundedBox( 5, 0, 0, ww, hh, ( pan:IsDown() and Color( 0, 55, 155, 155 ) ) or Color( 155, 155, 155, 155 ) )
		draw.SimpleText( "ADD SELECTED SPIRIT", "wOS.ALCS.DescFont", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	AddL.DoClick = function()
		local sel = SpiritList:GetSelectedLine()
		if not sel or sel < 1 then return end
		local dat = SpiritList:GetLine( sel )
		if not dat then return end
		local item = dat:GetColumnText( 1 )
		if not item or #item < 1 then return end
		wOS.ALCS.Admin.BufferInfo = {}
		net.Start( "wOS.Dueling.AddAdminSpirit" )
			net.WriteString( ply:SteamID64() )
			net.WriteString( item )
		net.SendToServer()
	end	
	
	local SpirInvList = vgui.Create( "DListView", self.DataTab )
	SpirInvList:SetMultiSelect( false )
	SpirInvList:AddColumn( "Spirit" )
	SpirInvList:AddColumn( "Level" )
	SpirInvList:AddColumn( "Energy" )
	SpirInvList:SetPos( padx , 3*pady + hh*0.45 )
	SpirInvList:SetSize( ww - 2*padx, hh*0.3 - 3*pady )
	SpirInvList.Think = function( pan )
		if not self.BufferInfo.Received then
			pan.Refreshed = false
		else
			if not pan.Refreshed then
				SpirInvList:Clear()
				for name, dat in pairs( self.BufferInfo.Data ) do
					if not wOS.ALCS.Dueling.Spirits[ name ] then continue end
					local name = name
					local amount = 1
					SpirInvList:AddLine( name, dat.level, dat.experience )
				end
				pan.Refreshed = true
			end
		end
	end
	
	local RemoveItem = vgui.Create( "DButton", self.DataTab )
	RemoveItem:SetPos( padx, hh*0.75 + pady )
	RemoveItem:SetSize( ww - 2*padx, hh*0.05 )
	RemoveItem:SetText( "" )
	RemoveItem.Paint = function( pan, ww, hh )
		draw.RoundedBox( 5, 0, 0, ww, hh, ( pan:IsDown() and Color( 0, 55, 155, 155 ) ) or Color( 155, 155, 155, 155 ) )
		draw.SimpleText( "REMOVE SELECTED SPIRIT", "wOS.ALCS.DescFont", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	RemoveItem.DoClick = function()
		local sel = SpirInvList:GetSelectedLine()
		if not sel or sel < 1 then return end
		local dat = SpirInvList:GetLine( sel )
		if not dat then return end
		local item = dat:GetColumnText( 1 )
		if not item or #item < 1 then return end
		wOS.ALCS.Admin.BufferInfo = {}
		net.Start( "wOS.Dueling.RemoveAdminSpirit" )
			net.WriteString( ply:SteamID64() )
			net.WriteString( item )
		net.SendToServer()
	end	

	local AddSLevel = vgui.Create( "DButton", self.DataTab )
	AddSLevel:SetPos( ww*0.6 + 2*padx, 2*pady + hh*0.8 )
	AddSLevel:SetSize( ww*0.4 - 3*padx, hh*0.05 )
	AddSLevel:SetText( "" )
	AddSLevel.Paint = function( pan, ww, hh )
		draw.RoundedBox( 5, 0, 0, ww, hh, ( pan:IsDown() and Color( 0, 55, 155, 155 ) ) or Color( 155, 155, 155, 155 ) )
		draw.SimpleText( "SET LEVEL", "wOS.ALCS.DescFont", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	local AddSLevelPEntry = vgui.Create( "DTextEntry",self.DataTab )
	AddSLevelPEntry:MakePopup()
	AddSLevelPEntry:SetPos( posx + padx, posy + 2*pady + hh*0.8 )
	AddSLevelPEntry:SetSize( ww*0.6, hh*0.05 )
	AddSLevelPEntry:SetText( 0 )
	AddSLevelPEntry:SetNumeric( true )
	AddSLevel.DoClick = function()
		local sel = SpirInvList:GetSelectedLine()
		if not sel or sel < 1 then return end
		local dat = SpirInvList:GetLine( sel )
		if not dat then return end
		local item = dat:GetColumnText( 1 )
		if not item or #item < 1 then return end
		wOS.ALCS.Admin.BufferInfo = {}
		net.Start( "wOS.Dueling.SetAdminSpiritLevel" )
			net.WriteString( ply:SteamID64() )
			net.WriteString( item )
			net.WriteInt( tonumber( AddSLevelPEntry:GetValue() ), 32 )
		net.SendToServer()
	end

	local AddSE = vgui.Create( "DButton", self.DataTab )
	AddSE:SetPos( ww*0.6 + 2*padx, 3*pady + hh*0.85 )
	AddSE:SetSize( ww*0.4 - 3*padx, hh*0.05 )
	AddSE:SetText( "" )
	AddSE.Paint = function( pan, ww, hh )
		draw.RoundedBox( 5, 0, 0, ww, hh, ( pan:IsDown() and Color( 0, 55, 155, 155 ) ) or Color( 155, 155, 155, 155 ) )
		draw.SimpleText( "SET ENERGY", "wOS.ALCS.DescFont", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	local AddSEEntry = vgui.Create( "DTextEntry",self.DataTab )
	AddSEEntry:MakePopup()
	AddSEEntry:SetPos( posx + padx, posy + 3*pady + hh*0.85 )
	AddSEEntry:SetSize( ww*0.6, hh*0.05 )
	AddSEEntry:SetText( 0 )
	AddSEEntry:SetNumeric( true )
	AddSE.DoClick = function()
		local sel = SpirInvList:GetSelectedLine()
		if not sel or sel < 1 then return end
		local dat = SpirInvList:GetLine( sel )
		if not dat then return end
		local item = dat:GetColumnText( 1 )
		if not item or #item < 1 then return end
		wOS.ALCS.Admin.BufferInfo = {}
		net.Start( "wOS.Dueling.SetAdminSpiritXP" )
			net.WriteString( ply:SteamID64() )
			net.WriteString( item )
			net.WriteInt( tonumber( AddSEEntry:GetValue() ), 32 )
		net.SendToServer()
	end

end

function wOS.ALCS.Admin:OpenArtMenu( ply )

	net.Start( "wOS.Dueling.AdminRequestArtifacts" )
		net.WriteString( ply:SteamID64() )
	net.SendToServer()

	self.DataTab:Clear()
	
	local mw, mh = w*0.5, h*0.5
	local padx, pady = mw*0.01, mw*0.01
	local bpady = mh*0.01
	local basew, baseh = mw*0.25, mh 
	local cw, ch = ( basew - 1.5*padx ), baseh - 2*pady
	local ww, hh = self.DataTab:GetSize()
	local posx, posy = self.DataTab:GetPos()
	local possx, possy = self.AdminMenu:GetPos()
	posx = possx + posx
	posy = possy + posy
	
	
	local ATTList = vgui.Create( "DListView", self.DataTab )
	ATTList:SetMultiSelect( false )
	ATTList:AddColumn( "Artifact Name" )
	ATTList:SetPos( padx, pady  )
	ATTList:SetSize( ww - 2*padx, hh*0.4 )
	
	//MANUAL SORTING SORT OF!!!
	//Could probably use a function in table.sort but whatever
	local lst = {}
	for item, dat in pairs( wOS.ALCS.Dueling.Artifact.List ) do
		lst[ #lst + 1 ] = item
	end
	table.sort(lst)
	for _, item in pairs( lst ) do
		ATTList:AddLine( item )
	end	
	
	local AddL = vgui.Create( "DButton", self.DataTab )
	AddL:SetPos( padx, 2*pady + hh*0.4 )
	AddL:SetSize( ww - 2*padx, hh*0.05 )
	AddL:SetText( "" )
	AddL.Paint = function( pan, ww, hh )
		draw.RoundedBox( 5, 0, 0, ww, hh, ( pan:IsDown() and Color( 0, 55, 155, 155 ) ) or Color( 155, 155, 155, 155 ) )
		draw.SimpleText( "ADD SELECTED ARTIFACT", "wOS.ALCS.DescFont", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	AddL.DoClick = function()
		local sel = ATTList:GetSelectedLine()
		if not sel or sel < 1 then return end
		local dat = ATTList:GetLine( sel )
		if not dat then return end
		local item = dat:GetColumnText( 1 )
		if not item or #item < 1 then return end
		wOS.ALCS.Admin.BufferInfo = {}
		net.Start( "wOS.Dueling.GiveAdminArtifact" )
			net.WriteString( ply:SteamID64() )
			net.WriteString( item )
		net.SendToServer()
	end	
	
	local ArtList = vgui.Create( "DListView", self.DataTab )
	ArtList:SetMultiSelect( false )
	ArtList:AddColumn( "Artifact" )
	ArtList:AddColumn( "Amount" )
	ArtList:SetPos( padx , 3*pady + hh*0.45 )
	ArtList:SetSize( ww - 2*padx, hh*0.4 - 3*pady )
	ArtList.Think = function( pan )
		if not self.BufferInfo.Received then
			pan.Refreshed = false
		else
			if not pan.Refreshed then
				ArtList:Clear()
				for name, amt in pairs( self.BufferInfo.Data ) do
					if not wOS.ALCS.Dueling.Artifact.List[ name ] then continue end
					local name = name
					local amount = 1
					ArtList:AddLine( name, amt )
				end
				pan.Refreshed = true
			end
		end
	end
	
	local RemoveItem = vgui.Create( "DButton", self.DataTab )
	RemoveItem:SetPos( padx, hh*0.85 + pady )
	RemoveItem:SetSize( ww - 2*padx, hh*0.05 )
	RemoveItem:SetText( "" )
	RemoveItem.Paint = function( pan, ww, hh )
		draw.RoundedBox( 5, 0, 0, ww, hh, ( pan:IsDown() and Color( 0, 55, 155, 155 ) ) or Color( 155, 155, 155, 155 ) )
		draw.SimpleText( "REMOVE SELECTED ITEM", "wOS.ALCS.DescFont", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	RemoveItem.DoClick = function()
		local sel = ArtList:GetSelectedLine()
		if not sel or sel < 1 then return end
		local dat = ArtList:GetLine( sel )
		if not dat then return end
		local item = dat:GetColumnText( 1 )
		if not item or #item < 1 then return end
		wOS.ALCS.Admin.BufferInfo = {}
		net.Start( "wOS.Dueling.RemoveAdminArtifact" )
			net.WriteString( ply:SteamID64() )
			net.WriteString( item )
		net.SendToServer()
	end	
	
	local ClearSlot = vgui.Create( "DButton", self.DataTab )
	ClearSlot:SetPos( padx, hh*0.9 + 2*pady )
	ClearSlot:SetSize( ww - 2*padx, hh*0.05 )
	ClearSlot:SetText( "" )
	ClearSlot.Paint = function( pan, ww, hh )
		draw.RoundedBox( 5, 0, 0, ww, hh, ( pan:IsDown() and Color( 0, 55, 155, 155 ) ) or Color( 155, 155, 155, 155 ) )
		draw.SimpleText( "CLEAR SELECTED SLOT", "wOS.ALCS.DescFont", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	ClearSlot.DoClick = function()
		local sel = ArtList:GetSelectedLine()
		if not sel or sel < 1 then return end
		local dat = ArtList:GetLine( sel )
		if not dat then return end
		local item = dat:GetColumnText( 1 )
		if not item or #item < 1 then return end
		wOS.ALCS.Admin.BufferInfo = {}
		net.Start( "wOS.Dueling.ClearAdminArtifact" )
			net.WriteString( ply:SteamID64() )
			net.WriteString( item )
		net.SendToServer()
	end	
	
end

function wOS.ALCS.Admin:OpenExecWLMenu( ply )

	net.Start( "wOS.ExecSys.AdminRequestExecWL" )
		net.WriteString( ply:SteamID64() )
	net.SendToServer()
	self.DataTab:Clear()
	
	local mw, mh = w*0.5, h*0.5
	local padx, pady = mw*0.01, mw*0.01
	local bpady = mh*0.01
	local basew, baseh = mw*0.25, mh 
	local cw, ch = ( basew - 1.5*padx ), baseh - 2*pady
	local ww, hh = self.DataTab:GetSize()
	local posx, posy = self.DataTab:GetPos()
	local possx, possy = self.AdminMenu:GetPos()
	posx = possx + posx
	posy = possy + posy
	
	local AddL = vgui.Create( "DButton", self.DataTab )
	AddL:SetPos( ww*0.6 + 2*padx, pady)
	AddL:SetSize( ww*0.4 - 3*padx, hh*0.05 )
	AddL:SetText( "" )
	AddL.Paint = function( pan, ww, hh )
		draw.RoundedBox( 5, 0, 0, ww, hh, ( pan:IsDown() and Color( 0, 55, 155, 155 ) ) or Color( 155, 155, 155, 155 ) )
		draw.SimpleText( "ADD EXECUTION", "wOS.ALCS.DescFont", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	local AddLevelEntry = vgui.Create( "DComboBox",self.DataTab )
	AddLevelEntry:SetPos( padx, pady )
	AddLevelEntry:SetSize( ww*0.6, hh*0.05 )
	AddLevelEntry:SetValue( "" )
	for exec, dat in pairs( wOS.ALCS.ExecSys.Executions ) do
		AddLevelEntry:AddChoice( exec )
	end
	AddL.DoClick = function()
		local tree = AddLevelEntry:GetSelected()
		if not tree or #tree < 1 then return end
		wOS.ALCS.Admin.BufferInfo = {}
		net.Start( "wOS.ExecSys.AddWL" )
			net.WriteString( tree )
			net.WriteString( ply:SteamID64() )
		net.SendToServer()
	end
	
	local SkillList = vgui.Create( "DListView", self.DataTab )
	SkillList:SetMultiSelect( false )
	SkillList:AddColumn( "Execution" )
	SkillList:SetPos( padx , 2*pady + hh*0.05 )
	SkillList:SetSize( ww - 2*padx, hh*0.8 - 2*pady )
	SkillList.Think = function( pan )
		if not self.BufferInfo.Received then
			pan.Refreshed = false
		else
			if not pan.Refreshed then
				SkillList:Clear()
				for tree, _ in pairs( self.BufferInfo.Data ) do
					SkillList:AddLine( tree )
				end
				pan.Refreshed = true
			end
		end
	end
	
	local RemoveWL = vgui.Create( "DButton", self.DataTab )
	RemoveWL:SetPos( padx, hh*0.85 + pady )
	RemoveWL:SetSize( ww - 2*padx, hh*0.05 )
	RemoveWL:SetText( "" )
	RemoveWL.Paint = function( pan, ww, hh )
		draw.RoundedBox( 5, 0, 0, ww, hh, ( pan:IsDown() and Color( 0, 55, 155, 155 ) ) or Color( 155, 155, 155, 155 ) )
		draw.SimpleText( "REMOVE SELECTED EXECUTION", "wOS.ALCS.DescFont", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	RemoveWL.DoClick = function()
		local sel = SkillList:GetSelectedLine()
		if not sel or sel < 1 then return end
		local dat = SkillList:GetLine( sel )
		if not dat then return end
		local tree = dat:GetColumnText( 1 )
		if not tree or #tree < 1 then return end
		wOS.ALCS.Admin.BufferInfo = {}
		net.Start( "wOS.ExecSys.RemoveWL" )
			net.WriteString( tree )
			net.WriteString( ply:SteamID64() )
		net.SendToServer()
	end	
	
end
