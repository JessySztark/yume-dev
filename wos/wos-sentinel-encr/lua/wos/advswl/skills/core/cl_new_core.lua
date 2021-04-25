--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2020
	
	Contact: www.wiltostech.com
		----------------------------------------]]--








































































wOS = wOS or {}
wOS.ALCS = wOS.ALCS or {}
wOS.ALCS.Skills = wOS.ALCS.Skills or {}

wOS.ALCS.Skills.MagiCOSTime = os.time()

local w,h = ScrW(), ScrH()
local wallMat = Material( "wos/debug/debugblack", "unlitgeneric" )
local upButton = Material( "wos/crafting/gui/up.png", "unlitgeneric" )
local downButton = Material( "wos/crafting/gui/down.png", "unlitgeneric" )
local bufferBar = Material( "wos/crafting/gui/buffer.png", "unlitgeneric" )
local boxTop = Material( "phoenix_storms/metalset_1-2", "unlitgeneric" )

local centerpoint = wOS.ALCS.Config.Crafting.CraftingCamLocation
local color_unselected = Color( 0, 0, 0, 100 )
local LastCamOrigin = vector_origin
local LastCamAng = Angle( 0, 0, 0 )

function wOS.ALCS.Skills:PrecacheIcon( name, png )

	local mat = Material( png )
	local actualmat = CreateMaterial( name, "unlitgeneric", 
		{
		 ["$model"] = 1,
		}
	)
	actualmat:SetTexture( "$basetexture", mat:GetTexture("$basetexture") )
	return actualmat
	
end

wOS.ALCS.Skills.Camera = wOS.ALCS.Skills.Camera or {}

wOS.ALCS.Skills.SkillRenders = wOS.ALCS.Skills.SkillRenders or {}

wOS.ALCS.Runes = wOS.ALCS.Runes or {}
local letters = { "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z" }
for i=1, #letters do
	wOS.ALCS.Runes[ letters[i] ] = Material( "wos/runes/" .. letters[i] .. ".png", "unlitgeneric" )
end 

function wOS.ALCS.Skills:CreateCubeMat( pos, mat, normal, size, static )

	if not pos then return end
	normal = normal or vector_up
	size = size or 16
	
	local tim = static or ( CurTime() * 50 ) % 360
	
	render.SetMaterial( mat )
	for i = 0, 3 do
		local dir = normal:Angle()
		dir:RotateAroundAxis( normal, tim + i*90 )
		local right = dir:Right()
		render.DrawQuadEasy( pos + normal * size/2 + right*size/2, right, size, size, color_white, 180 )
	end

	render.SetMaterial( boxTop )
	render.DrawQuadEasy( pos, normal*-1, size, size, color_white, tim*-1 )
	render.DrawQuadEasy( pos + normal*size, normal, size, size, color_white, tim )
	
end

function wOS.ALCS.Skills:CreateCubeModel( pos, mat )
	local CubeModel = ClientsideModel( "models/wos/lct/props/woscube.mdl", RENDERGROUP_OPAQUE )
	CubeModel:SetPos( pos )
	local ang = CubeModel:GetAngles()
	ang:RotateAroundAxis( ang:Right(), 180 )
	CubeModel:SetAngles( ang )
	CubeModel:SetColor( Color( 255, 255, 255 ) )
	CubeModel:SetSubMaterial( 0, "!" .. mat )
	CubeModel:SetSubMaterial( 1, "phoenix_storms/metalset_1-2" )
	CubeModel:SetNoDraw( true )
	return CubeModel
end

hook.Add( "PostDrawOpaqueRenderables", "wOS.ALCS.SkillsBox", function()
	if !IsValid( wOS.ALCS.Skills.Menu ) then return end
	if !wOS.ALCS.Skills.Menu:IsVisible() then return end
	if !wOS.ALCS.Skills.Menu.RenderNow and !wOS.ALCS.Skills.Menu.FullScreen then return end
	if !wOS.ALCS.Skills.Menu:IsVisible() then return end

	local pos = Vector( centerpoint ) 
	local angle = Angle(0, 0, 0)
    local scale = 100
    local size = 5
    local center = pos
	render.SetMaterial(wallMat)
	render.DrawQuadEasy(center + Vector(0, 0, size*scale/2), Vector(0, 0, -1), size*scale, size*scale, 0, Color(255, 0, 0), 0)
	render.DrawQuadEasy(center - Vector(0, size*scale/2, 0), Vector(0, 1, 0), size*scale, size*scale, 0, Color(255, 0, 0), 0)
	render.DrawQuadEasy(center - Vector(size*scale/2, 0, 0), Vector(1, 0, 0), size*scale, size*scale, 0, Color(255, 0, 0), 0)
	render.DrawQuadEasy(center - Vector(0, -size*scale/2, 0), Vector(0, -1, 0), size*scale, size*scale, 0, Color(255, 0, 0), 0)
	render.DrawQuadEasy(center - Vector(-size*scale/2, 0, 0), Vector(-1, 0, 0), size*scale, size*scale, 0, Color(255, 0, 0), 0)
	render.DrawQuadEasy(center, Vector(0, 0, 1), size*scale, size*scale, 0, Color(0, 0, 0 ), 0)	
	
end )

hook.Add( "PreDrawTranslucentRenderables", "wOS.ALCS.SkillsRenders", function()

	if not wOS.ALCS.Skills.Menu then return end
	if not wOS.ALCS.Skills.Menu.VGUI then return end
	if !wOS.ALCS.Skills.Menu.RenderNow and !wOS.ALCS.Skills.Menu.FullScreen then return end
	if !wOS.ALCS.Skills.Menu:IsVisible() then return end
	
	if IsValid( wOS.ALCS.Skills.Menu.Player ) then
		wOS.ALCS.Skills.Menu.Player:DrawModel()
	end
	
	if wOS.ALCS.Skills.CubeModels then
		if #wOS.ALCS.Skills.CubeModels > 0 then
			for _, model in ipairs( wOS.ALCS.Skills.CubeModels ) do
				model:DrawModel()
			end
		end
	end
		
end )

hook.Add( "PostDrawTranslucentRenderables", "wOS.ALCS.SkillsRenders", function()

	if not wOS.ALCS.Skills.Menu then return end
	if not wOS.ALCS.Skills.Menu.VGUI then return end
	if !wOS.ALCS.Skills.Menu.RenderNow and !wOS.ALCS.Skills.Menu.FullScreen then return end
	if !wOS.ALCS.Skills.Menu:IsVisible() then return end
	
	render.SuppressEngineLighting( true )
	for _, frame in ipairs( wOS.ALCS.Skills.Menu.VGUI ) do
		frame:Renders()
		frame:Render( frame.CamPos, frame.CamAng, frame.Scaling or 0.1 )
		if frame.PostRenders then
			frame:PostRenders()
		end
	end
	render.SuppressEngineLighting( false )
	
end )

hook.Add( "wOS.ALCS.ShouldDisableCam", "wOS.ALCS.Skills.Prevent3rdPerson", function()
	if !IsValid( wOS.ALCS.Skills.Menu ) then return end
	if !wOS.ALCS.Skills.Menu:IsVisible() then return end
	return true
end )

hook.Add( "CalcView", "wOS.ALCS.Skills.Camera", function( ply, pos, ang )
	if ( !IsValid( ply ) or !ply:Alive() or ply:InVehicle() or ply:GetViewEntity() != ply ) then return end
	if !IsValid( wOS.ALCS.Skills.Menu ) then return end
	if !wOS.ALCS.Skills.Menu.RenderNow and !wOS.ALCS.Skills.Menu.FullScreen then return end
	if !wOS.ALCS.Skills.Menu:IsVisible() then return end
	if wOS.ALCS.Config.CameraAnimationSpeed then
		LastCamOrigin = ( LastCamOrigin == wOS.ALCS.Skills.Camera[ wOS.ALCS.Skills.CamFocus ].origin and wOS.ALCS.Skills.Camera[ wOS.ALCS.Skills.CamFocus ].origin ) or Lerp( FrameTime()*wOS.ALCS.Config.CameraAnimationSpeed, LastCamOrigin, wOS.ALCS.Skills.Camera[ wOS.ALCS.Skills.CamFocus ].origin )
		LastCamAng = ( LastCamAng == wOS.ALCS.Skills.Camera[ wOS.ALCS.Skills.CamFocus ].angles and wOS.ALCS.Skills.Camera[ wOS.ALCS.Skills.CamFocus ].angles ) or Lerp( FrameTime()*wOS.ALCS.Config.CameraAnimationSpeed, LastCamAng, wOS.ALCS.Skills.Camera[ wOS.ALCS.Skills.CamFocus ].angles )
	else
		LastCamOrigin = wOS.ALCS.Skills.Camera[ wOS.ALCS.Skills.CamFocus ].origin
		LastCamAng = wOS.ALCS.Skills.Camera[ wOS.ALCS.Skills.CamFocus ].angles	
	end
	local amod = wOS.ALCS.Skills.Menu.AngleMod
	amod = LastCamAng:Right()*amod.x + LastCamAng:Up()*amod.y
	return  { 
				origin = LastCamOrigin + amod,
				angles = LastCamAng,
				drawviewer = false,
		    }
	
end )

function wOS.ALCS.Skills:CleanAllMenus( button )

	if self.CubeModels then
		for i = 1, #self.CubeModels do
			if self.CubeModels[i] then
				self.CubeModels[i]:Remove()
			end
		end
		self.CubeModels = {}
	end

	if not button then
		if IsValid( self.Menu.Player ) then 
			self.Menu.Player:Remove()
		end
		self.Menu.RenderNow = false
		self.Menu:Remove()
		self.Menu = nil
		if self.SkillInfoPanel then
			self.SkillInfoPanel:Remove()
			self.SkillInfoPanel = nil
		end
		gui.EnableScreenClicker( false )
	end
	
	if not self.Menu then return end
	self.Menu.VGUI = {}
	
end

function wOS.ALCS.Skills:CloseSkillsMenu()
	self:CleanAllMenus()
	gui.EnableScreenClicker( false )
end

hook.Add( "PostRenderVGUI", "wOS.ALCS.Skills.CreateRenderWindow", function()
	if !IsValid( wOS.ALCS.Skills.Menu ) then return end
	if not wOS.ALCS.Skills.Menu:IsVisible() then return end
	wOS.ALCS.Skills.Menu.DrawRender = true
		wOS.ALCS.Skills.Menu:Paint() 
	if not wOS.ALCS.Skills.Menu then return end
	wOS.ALCS.Skills.Menu.DrawRender = false
end )

function wOS.ALCS.Skills:OpenSkillsMenu()

	if self.Menu then 
		wOS.ALCS.Skills:CloseSkillsMenu()
		return
	end
	
	if wOS.InventoryPanel then
		wOS:ViewInventory()
	end
	
	gui.EnableScreenClicker( true )

	self.Menu = vgui.Create( "DFrame" )
	self.Menu:SetDraggable( true )
	self.Menu:ShowCloseButton( false )
	self.Menu:SetTitle( "" )
	self.Menu:SetSize( ScrW()*0.8, ScrH()*0.8 )
	self.Menu:Center()
	self.Menu.SpawnTime = CurTime()
	self.Menu.VGUI = {}
	self.Menu.PosData = { x = -1, y = -1 }
	self.Menu.AngleMod = Vector( 0, 0, 0 )
	self.Menu.SetAngle = function( pan, pit, yaw )
		pan.AngleMod = Vector( pit or 0, yaw or 0, 0 )
	end
	self.Menu.AddAngleYaw = function( pan, pit, max )
		max = max or 0
		pan.AngleMod.x = math.Clamp( pan.AngleMod.x + pit, -0.5*max, 0.5*max )
	end
	self.Menu.AddAnglePitch = function( pan, yaw, max, min )
		pan.AngleMod.y = math.Clamp( pan.AngleMod.y + yaw, min or 0, max or 0 )
	end
	
	local mw, mh = self.Menu:GetSize()
	
	local button = vgui.Create( "DButton", self.Menu )
	button:SetSize( mw*0.015, mh*0.02 )
	button:SetPos( mw*0.985, 0 )
	button:SetText( "" )
	button.DoClick = function()
		self:CleanAllMenus()
	end	
	button.Paint = nil
	
	self.Menu.Paint = function( pan )
		if not pan.DrawRender then return end
		local ww, hh = pan:GetSize()
		local px, py = pan:GetPos()
		pan.PosData.x, pan.PosData.y = pan:CursorPos()
		
		if !pan.ModEnabled then
			pan:SetAngle( 0, 0 )
		end
		
		pan.RenderNow = true	
			draw.RoundedBox( 0, px, py, ww*0.985, hh*0.02, Color( 255, 255, 255, 155 ) )
			draw.RoundedBox( 0, px + ww*0.985, py, ww*0.015, hh*0.02, Color( 255, 0, 0 ) )
			local tbl = hook.Call( "CalcView", GAMEMODE, LocalPlayer() )
			tbl.w = ww
			tbl.h = hh*0.98
			tbl.x = px
			tbl.y = py + hh*0.02
			tbl.fov = 85
			render.RenderView( tbl )
		pan.RenderNow = false
		
		if wOS.ALCS.Skills.SkillInfoPanel then
			wOS.ALCS.Skills.SkillInfoPanel:Paint()
		end
		
	end
	self.Menu.OnMouseWheeled = function( pan, del )
		if not pan.ModEnabled then return end
		if LocalPlayer():KeyDown( IN_SPEED ) then
			pan:AddAngleYaw( del, pan.MaxW )
		else
			pan:AddAnglePitch( del, pan.MaxH, pan.MinH )
		end
	end
	
	self.Menu.Cycle = 0
	self.Menu.LastPaint = CurTime()
	local p_think = self.Menu.Think
	self.Menu.Think = function( pan )
		p_think( pan )
		if not vgui.CursorVisible() then
			gui.EnableScreenClicker( true )
		end
		if not LocalPlayer():Alive() or input.IsKeyDown( KEY_BACKSPACE ) then
			wOS.ALCS.Skills:CloseSkillsMenu()
			return
		end
		if pan.Player then
			pan.Player:FrameAdvance( ( RealTime() - pan.LastPaint ) )
			pan.LastPaint = CurTime()
			if pan.Player:GetCycle() >= 0.99 then
				pan.Player:SetCycle( 0 )
			end
		end

	end
	
	self.SkillInfoPanel = vgui.Create( "DPanel" )
	self.SkillInfoPanel:SetSize( mw*0.26, mh*0.08 )
	self.SkillInfoPanel:SetPos( w, h )
	self.SkillInfoPanel.Data = false
	self.SkillInfoPanel.TimeShow = 0
	self.SkillInfoPanel.Paint = function( pan, ww, hh )	
		if pan.TimeShow < CurTime() then return end
		local ww, hh = pan:GetSize()
		local px, py = pan:GetPos()
		draw.RoundedBox( 3, px, py, ww, hh, Color( 25, 25, 25, 255 ) )
		surface.SetDrawColor( color_white )
		surface.DrawOutlinedRect( px + ww*0.01, py + hh*0.01, ww*0.98, hh*0.98 )
		
		if pan.Data then
			draw.SimpleText( pan.Data.Name, "wOS.TitleFont", px + ww*0.04, py + hh*0.25, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			draw.SimpleText( pan.Data.Description, "wOS.DescriptionFont", px + ww*0.04, py + hh*0.5, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			if not pan.Data.Prestige then
				if not wOS:HasSkillEquipped( pan.Data.Tree, pan.Data.Tier, pan.Data.Skill ) then
					if wOS:CanEquipSkill( pan.Data.Tree, pan.Data.Tier, pan.Data.Skill ) then
						draw.SimpleText( "Requires " .. pan.Data.PointsRequired .. " skill point(s)", "wOS.DescriptionFont", px + ww*0.04, py + hh*0.75, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
					else
						draw.SimpleText( "UNAVAILABLE", "wOS.DescriptionFont", px + ww*0.04, py + hh*0.75, Color( 255, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
					end
				else
					draw.SimpleText( "EQUIPPED", "wOS.DescriptionFont", px + ww*0.04, py + hh*0.75, Color( 0, 128, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )			
				end
			else
				if not wOS.ALCS.Prestige.Data.Mastery[ pan.Data.Mastery ] then
					if wOS.ALCS.Prestige:CanEquipPrestige( pan.Data.Mastery ) then
						draw.SimpleText( "Requires " .. pan.Data.Cost.. " prestige token(s)", "wOS.DescriptionFont", px + ww*0.04, py + hh*0.75, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
					else
						draw.SimpleText( "UNAVAILABLE", "wOS.DescriptionFont", px + ww*0.04, py + hh*0.75, Color( 255, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
					end
				else
					draw.SimpleText( "MASTERED", "wOS.DescriptionFont", px + ww*0.04, py + hh*0.75, Color( 0, 128, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )			
				end
			end
		end
		
	end
	self.SkillInfoPanel.Think = function( pan )
		pan:SetPos( gui.MouseX() + 15, gui.MouseY() + 15 )
	end

	
	self:BuildPlayerModel()
	LastCamOrigin = self.Menu.Player:GetPos() + Vector( 0, 0, 70 )
	LastCamAng = Angle( -15.840, 30.501, 0.000 )
	
	self:ChangeCamFocus( "Overview" )
	
end

function wOS.ALCS.Skills:BuildPlayerModel()

	if !IsValid( self.Menu ) then return end
	if IsValid( self.Menu.Player ) then 
		self.Menu.Player:Remove()
	end
	self.Menu.Player = ClientsideModel( LocalPlayer():GetModel(), RENDERGROUP_STATIC )
	self.Menu.Player:SetPos( centerpoint - Vector( -30, -25, -1 ) )
	self.Menu.Player:SetSkin( LocalPlayer():GetSkin() )
	self.Menu.Player:SetModelScale( LocalPlayer():GetModelScale() )
	
	local item = wOS.ALCS.Dueling.Spirits[ wOS.ALCS.Dueling.DuelData.DuelSpirit ]

	local anim = "idle_fist"

	if item and item.Sequence then
		local id = self.Menu.Player:LookupSequence(item.Sequence)
		if id != -1 then anim = id end
	end
	self.Menu.Player:SetSequence(anim)
	self.Menu.Player.SpawnTime = CurTime()

	local ang = self.Menu.Player:GetAngles()
	ang:RotateAroundAxis( ang:Up(), -120 )	
	self.Menu.Player:SetAngles( ang )
	self.Menu.Player:SetNoDraw( true )
end

function wOS.ALCS.Skills:ChangeCamFocus( focus )
	self:CleanAllMenus( true )
	self.CamFocus = focus
	self.MenuLibrary[ focus ]()
end

function wOS:HasSkillEquipped( tree, tier, skill )

	if not self.EquippedSkills[ tree ] then return false end
	if not self.EquippedSkills[ tree ][ tier ] then return false end
	
	return self.EquippedSkills[ tree ][ tier ][ skill ]
	
end

function wOS:CanEquipSkill( tree, tier, skill )
	local skilldata = self.SkillTrees[ tree ]
	if not skilldata then return false end
	skilldata = self.SkillTrees[ tree ].Tier[ tier ]
	if not skilldata then return false end
	skilldata = self.SkillTrees[ tree ].Tier[ tier ][ skill ]
	if not skilldata then return false end
	if table.Count( skilldata.Requirements ) < 1 then return true end

	if skilldata.LockOuts then
		if table.Count( skilldata.LockOuts ) > 0 then
			for tierr, sdata in pairs( skilldata.LockOuts ) do
				for _, skilll in pairs( sdata ) do
					if self:HasSkillEquipped( tree, tierr, skilll ) then return false end
				end
			end
		end
	end

	for tierr, sdata in pairs( skilldata.Requirements ) do
		for _, skilll in pairs( sdata ) do
			if not self:HasSkillEquipped( tree, tierr, skilll ) then return false end
		end
	end
	
	return true
	
end

function wOS:HasSkillPoints( tree, tier, skill )

	local skilldata = self.SkillTrees[ name ]
	if not skilldata then return false end
	skilldata = self.SkillTrees[ name ].Tier[ tier ]
	if not skilldata then return false end
	skilldata = self.SkillTrees[ name ].Tier[ tier ][ skill ]
	if not skilldata then return false end

	return LocalPlayer():GetNW2Int( "wOS.SkillPoints", 0 ) >= skilldata.PointsRequired
	
end

if wOS.ALCS.Config.Skills.MountLevelToHUD then

	hook.Add( "HUDPaint", "wOS.SkillTrees.MountHUD", function()
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
		draw.RoundedBox( 3, ( w - w*0.43 )/2, 0, w*0.43, h*0.035, Color( 25, 25, 25, 245 ) )
		surface.SetDrawColor( color_white )
		surface.DrawOutlinedRect( ( w - w*0.33 )/2, h*0.005, w*0.33, h*0.02 )
		surface.DrawRect( (w - w*0.33 )/2, h*0.005, w*0.33*rat, h*0.02 )
		draw.SimpleText( ( level == wOS.ALCS.Config.Skills.SkillMaxLevel and "MAX" ) or lastxp, "wOS.DescriptionFont", ( w - w*0.33 )/2 - w*0.005, h*0.015, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
		draw.SimpleText( ( level == wOS.ALCS.Config.Skills.SkillMaxLevel and "LEVEL" ) or reqxp, "wOS.DescriptionFont", ( w + w*0.33 )/2 + w*0.005, h*0.015, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )		
		draw.SimpleText( "Level " .. level, "wOS.DescriptionFont", w*0.5, h*0.015, Color( 0, 128, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )		
	end )
	
end