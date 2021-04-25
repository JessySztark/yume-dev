--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2020
	
	Contact: www.wiltostech.com
		----------------------------------------]]--








































































wOS = wOS or {}
wOS.ALCS = wOS.ALCS or {}
wOS.ALCS.Prestige = wOS.ALCS.Prestige or {}
wOS.ALCS.Skills = wOS.ALCS.Skills or {}
wOS.ALCS.Skills.Camera = wOS.ALCS.Skills.Camera or {}


wOS.ALCS.Prestige.HoverInfo = { Slot = 0, Active = nil }

local w,h = ScrW(), ScrH()
local pi = math.pi

local upButton = Material( "wos/crafting/gui/up.png", "unlitgeneric" )
local downButton = Material( "wos/crafting/gui/down.png", "unlitgeneric" )
local leftButton = Material( "wos/crafting/gui/left.png", "unlitgeneric" )
local rightButton = Material( "wos/crafting/gui/right.png", "unlitgeneric" )
local bufferBar = Material( "wos/crafting/gui/buffer.png", "unlitgeneric" )
local boxTop = Material( "phoenix_storms/metalset_1-2", "unlitgeneric" )

local wireFrame = Material( "trails/plasma" )

local DuelBlock = Material( "wos/advswl/prestige_holocron.png", "unlitgeneric" )

local centerpoint = wOS.ALCS.Config.Crafting.CraftingCamLocation
local color_unselected = Color( 0, 0, 0, 100 )
local grad = Material( "gui/gradient_up" )

wOS.ALCS.Skills.CubeModels = wOS.ALCS.Skills.CubeModels or {}

wOS.ALCS.Skills.MenuLibrary = wOS.ALCS.Skills.MenuLibrary or {}
wOS.ALCS.Skills.Camera[ "Prestige-Overview" ] = { origin = centerpoint - Vector( 45, -35, -30 ), angles = Angle( 0, 90.501, 0.000 ) }
wOS.ALCS.Skills.MenuLibrary[ "Prestige-Overview" ] = function()
	wOS.ALCS.Skills.Menu.ModEnabled = false
	local leftpane = tduiw.Create()
	leftpane.SizeX = 8
	leftpane.SizeY = 35
	leftpane.ShouldAcceptInputs = true
	leftpane.Renders = function( pan )
	
		local ww, hh = pan.SizeX, pan.SizeY	
		local x = -30
		local y = -hh*0.4
		local bh = hh/7
		
		pan:Line( 0, -hh/2, x + ww, y + bh/2 )
		
		local lst = 0
		image = wOS.ALCS.Runes[ "m" ]
		pan:Mat( image, x, y, ww, bh )	
		local _jp, _pr, _hov = pan:Button( "", "wOS.TitleFont", x, y, ww, bh, color_white, color_white )
	    if _hov then
			local speed = 0.1
			if not pan.SlideTimes then 
				pan.SlideTimes = CurTime() + speed
				surface.PlaySound( "wos/alcs/ui_slideout.wav" )
			end
			if pan.LastButt != lst then
				surface.PlaySound( "wos/alcs/ui_rollover.wav" )
				pan.LastButt = lst
			end
			local rat = math.Clamp( pan.SlideTimes - CurTime(), 0, speed )/speed
			pan:Rect( x, y, ww*-3*( 1 - rat  ), bh, Color( 10, 10, 10, 255 ), color_white )
			pan:Text( "VIEW ASCENSION MAP", "wOS.TitleFont", x + ww*-2.7*( 1 - rat  ), y + bh/2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )

			pan.LastHover = CurTime() + 0.01
	    end							
		if _jp then
			wOS.ALCS.Skills:ChangeCamFocus( "Prestige-ViewMap" )
		end
		
		if pan.SlideTimes and pan.LastHover < CurTime() then
			pan.SlideTimes	= nil
			pan.LastButt = nil
		end
	
	end
	leftpane:SetUIScale( 10 )
	leftpane.Scaling = 0.025
	
	leftpane.CamPos = wOS.ALCS.Skills.Camera[ wOS.ALCS.Skills.CamFocus ].origin + Vector( 0, 20, -2 )
	leftpane.CamAng = wOS.ALCS.Skills.Camera[ wOS.ALCS.Skills.CamFocus ].angles + Angle( 0, 30, 0 )
	table.insert( wOS.ALCS.Skills.Menu.VGUI, leftpane )
	
	local frontpane = tduiw.Create()
	frontpane.SizeX = 8
	frontpane.SizeY = 35
	frontpane.ShouldAcceptInputs = true
	frontpane.Renders = function( pan )
		local ww, hh = pan.SizeX, pan.SizeY
		
		local x = 0 - ww/2
		local y = 10
		local bh = hh/7
		
		local level = wOS.ALCS.Prestige.Data.Level
		local tokens = wOS.ALCS.Prestige.Data.Tokens

		pan:Text( "PRESTIGE LEVEL " .. level, "wOS.CraftDescriptions", 0, -hh*1.1, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		if tokens > 0 then
			local rate = math.abs( math.cos( CurTime()*5 ) )
			pan:Text( tokens .. " UNSPENT TOKENS", "wOS.DescriptionFont", 0, -hh*0.95, Color( 255*rate, 255 - 255*rate, 255 - 255*rate, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
		end
		
		pan:Line( 0, -3, 3, 3 )
		pan:Line( 3, 3, 0, 10 )
		
		local lst = 0
		image = wOS.ALCS.Runes[ "x" ]
		pan:Mat( image, x, y, ww, bh )	
		local _jp, _pr, _hov = pan:Button( "", "wOS.TitleFont", x, y, ww, bh, color_white, color_white )
		if _jp then
			wOS.ALCS.Skills:ChangeCamFocus( "Overview" )
	    elseif _hov then
			local speed = 0.1
			if not pan.SlideTimes then 
				pan.SlideTimes = CurTime() + speed
				surface.PlaySound( "wos/alcs/ui_slideout.wav" )
			end
			if pan.LastButt != lst then
				surface.PlaySound( "wos/alcs/ui_rollover.wav" )
				pan.LastButt = lst
			end
			local rat = math.Clamp( pan.SlideTimes - CurTime(), 0, speed )/speed
			pan:Rect( x + ww, y, ww*( 3 - 3*rat  ), bh, Color( 10, 10, 10, 255 ), color_white )
			pan:Text( "GO BACK", "wOS.TitleFont", x + ww*2.1*( 1 - rat  ), y + bh/2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			pan.LastHover = CurTime() + 0.01
	    end							
		lst = lst + 1
		
		local _jp, _pr, _hov = pan:Button( "", "wOS.TitleFont", -hh*0.7/2, -hh*0.7, hh*0.7, hh*0.7, Color( 0, 0, 0, 0 ), Color( 0, 0, 0, 0 ) )
	    if _hov then
			local speed = 0.1
			if not pan.SlideTimes then 
				pan.SlideTimes = CurTime() + speed
			end
			if pan.LastButt != lst then
				surface.PlaySound( "wos/alcs/ui_rollover.wav" )
				pan.LastButt = lst
			end
			local rat = math.Clamp( pan.SlideTimes - CurTime(), 0, speed )/speed
			pan:Text( "MASTER YOUR INNER SELF", "wOS.CraftDescriptions", 0, y + bh*2*( 1.5 + rat ), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			pan.LastHover = CurTime() + 0.01
	    end		
		lst = lst + 1
		
		if pan.SlideTimes and pan.LastHover < CurTime() then
			pan.SlideTimes	= nil
			pan.LastButt = nil
		end
	
	end
	frontpane.PostRenders = function( pan )
		wOS.ALCS.Skills:CreateCubeMat( pan.CamPos, DuelBlock, nil, 6 )
	end
	frontpane:SetUIScale( 10 )
	frontpane.Scaling = 0.025
	
	frontpane.CamPos = wOS.ALCS.Skills.Camera[ wOS.ALCS.Skills.CamFocus ].origin + Vector( 0, 20, -2 )
	frontpane.CamAng = wOS.ALCS.Skills.Camera[ wOS.ALCS.Skills.CamFocus ].angles + Angle( 0, 0, 0 )
	table.insert( wOS.ALCS.Skills.Menu.VGUI, frontpane )
	
	
	local rightpane = tduiw.Create()
	rightpane.SizeX = 8
	rightpane.SizeY = 35
	rightpane.ShouldAcceptInputs = true
	rightpane.Renders = function( pan )
	
		local ww, hh = pan.SizeX, pan.SizeY	
		local x = 20
		local y = -hh*0.6
		local bh = hh/7
		

		
		local lst = 0
		
		y = y + hh*0.4
		pan:Line( x/2, y - hh*0.05, x, y + bh/2 )
		image = wOS.ALCS.Runes[ "p" ]
		pan:Mat( image, x, y, ww, bh )	
		local _jp, _pr, _hov = pan:Button( "", "wOS.TitleFont", x, y, ww, bh, color_white, color_white )
		if _jp then
			net.Start( "wOS.ALCS.Prestige.Ascend" ) 
			net.SendToServer() 
	    elseif _hov then
			local speed = 0.1
			if not pan.SlideTimes then 
				pan.SlideTimes = CurTime() + speed
				surface.PlaySound( "wos/alcs/ui_slideout.wav" )
			end
			if pan.LastButt != lst then
				surface.PlaySound( "wos/alcs/ui_rollover.wav" )
				pan.LastButt = lst
			end
			local rat = math.Clamp( pan.SlideTimes - CurTime(), 0, speed )/speed
			pan:Rect( x + ww, y, ww*( 3 - 3*rat  ), bh, Color( 10, 10, 10, 255 ), color_white )
			pan:Text( "ASCEND YOURSELF", "wOS.TitleFont", x + ww*1.55*( 1 - rat  ), y + bh/2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			pan:Text( "THIS WILL RESET EVERYTHING", "wOS.DescriptionFont", x, y + bh*( 1 + rat ), Color( 255, 0, 0 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			pan.LastHover = CurTime() + 0.01
	    end							
		lst = lst + 1
		
		if pan.SlideTimes and pan.LastHover < CurTime() then
			pan.SlideTimes	= nil
			pan.LastButt = nil
		end
	
	end
	rightpane:SetUIScale( 10 )
	rightpane.Scaling = 0.025
	
	rightpane.CamPos = wOS.ALCS.Skills.Camera[ wOS.ALCS.Skills.CamFocus ].origin + Vector( 0, 20, -2 )
	rightpane.CamAng = wOS.ALCS.Skills.Camera[ wOS.ALCS.Skills.CamFocus ].angles + Angle( 0, -30, 0 )
	table.insert( wOS.ALCS.Skills.Menu.VGUI, rightpane )
	
end

wOS.ALCS.Skills.Camera[ "Prestige-ViewMap" ] = { origin = centerpoint - Vector( 45, -35, -30 ), angles = Angle( 0, 90.501, 0.000 ) }
wOS.ALCS.Skills.MenuLibrary[ "Prestige-ViewMap" ] = function()
	wOS.ALCS.Skills.Menu.ModEnabled = true
	local selectpane = tduiw.Create()
	selectpane.Positions = {}
	
	local frontpane = tduiw.Create()
	frontpane.SizeX = 8
	frontpane.SizeY = 35
	frontpane.ShouldAcceptInputs = true
	frontpane.PathInfo = {}
	
	local forward = wOS.ALCS.Skills.Camera[ wOS.ALCS.Skills.CamFocus ].angles:Forward()
	local up = wOS.ALCS.Skills.Camera[ wOS.ALCS.Skills.CamFocus ].angles:Up()
	local right = wOS.ALCS.Skills.Camera[ wOS.ALCS.Skills.CamFocus ].angles:Right()
	local modelscale = 0.5
	local offsety = 3
	local bpos = wOS.ALCS.Skills.Camera[ wOS.ALCS.Skills.CamFocus ].origin
	local padscale = 12
	
	frontpane.Renders = function( pan )
	
		local ww, hh = pan.SizeX, pan.SizeY
		local x = 0 - ww/2
		local y = 19
		local bh = hh/7
		
		local points = wOS.ALCS.Prestige.Data.Tokens
		local offsett = wOS.ALCS.Skills.Menu.AngleMod.y*4
		local offsetp = wOS.ALCS.Skills.Menu.AngleMod.x*4
		
		pan:Text( wOS.ALCS.Prestige.MapData.HeaderName, "wOS.CraftDescriptions", offsetp, -hh*1.3 - offsett, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		pan:Text( wOS.ALCS.Prestige.MapData.HeaderTagLine, "wOS.TitleFont", offsetp, -hh*1.2 - offsett, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )			

		pan:Text( "Available Tokens: " .. points, "wOS.TitleFont", offsetp, -hh*1.1 - offsett, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )	
		
		local lst = 0
		local image = wOS.ALCS.Runes[ "x" ]
		pan:Mat( image, x + offsetp, y - offsett, ww, bh )	
		local _jp, _pr, _hov = pan:Button( "", "wOS.TitleFont", x + offsetp, y - offsett, ww, bh, color_white, color_white )
		if _jp then
			wOS.ALCS.Skills:ChangeCamFocus( "Prestige-Overview" )
	    elseif _hov then
			local speed = 0.1
			if not pan.SlideTimes then 
				pan.SlideTimes = CurTime() + speed
				surface.PlaySound( "wos/alcs/ui_slideout.wav" )
			end
			if pan.LastButt != lst then
				surface.PlaySound( "wos/alcs/ui_rollover.wav" )
				pan.LastButt = lst
			end
			local rat = math.Clamp( pan.SlideTimes - CurTime(), 0, speed )/speed
			pan:Rect( x + ww + offsetp, y - offsett, ww*( 3 - 3*rat  ), bh, Color( 10, 10, 10, 255 ), color_white )
			pan:Text( "GO BACK", "wOS.TitleFont", x + ww*2.1*( 1 - rat  ) + offsetp, y + bh/2 - offsett, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			pan.LastHover = CurTime() + 0.01
	    end
		lst = lst + 1
		
		if pan.SlideTimes and pan.LastHover < CurTime() then
			pan.SlideTimes	= nil
			pan.LastButt = nil
		end

	end
	frontpane.PostRenders = function( pan )

		if not pan.FUCKYOU then
			local bottompos = bpos + Vector( 0, 25, 0 ) 
			local maxy = 0
			local maxx = 0

			for slot, dat in pairs( wOS.ALCS.Prestige.MapData.Paths ) do
				
				if math.abs( dat.GridPosition.x ) > maxx then
					maxx = math.abs( dat.GridPosition.x )
				end
				
				if math.abs( dat.GridPosition.y ) > maxy then
					maxy = math.abs( dat.GridPosition.y )
				end
				
				local pos = bottompos + right*dat.GridPosition.x*padscale + up*dat.GridPosition.y*padscale
				local model = wOS.ALCS.Skills:CreateCubeModel( pos, "wos-alcs-prestigemap-" .. slot )
				model:SetModelScale( modelscale )
				model.Data = dat
				model.Data.Mastery = slot
				model.Pos = pos
				table.insert( wOS.ALCS.Skills.CubeModels, model )
				local vec = WorldToLocal( pos, Angle( 0,0,0 ), pan.CamPos, pan.CamAng + Angle( 0, 0, 180 ) )
				table.insert( selectpane.Positions, vec )
				pan.PathInfo[ slot ] = #wOS.ALCS.Skills.CubeModels
			end	
			
			wOS.ALCS.Skills.Menu.MaxH = offsety* 3.7 * maxy
			wOS.ALCS.Skills.Menu.MinH = wOS.ALCS.Skills.Menu.MaxH * -1
			wOS.ALCS.Skills.Menu.MaxW = padscale * 2 * maxx
			pan.FUCKYOU = true
			
		end

		--Redefining the post render function IN the post render function?
		--You bet your sweet ass I fucking did
		pan.PostRenders = function( pan )

			for i, model in pairs( wOS.ALCS.Skills.CubeModels ) do
				if not model then continue end
				local shadow = true
				model:SetMaterial( "" )
				if wOS.ALCS.Prestige.Data.Mastery[ model.Data.Mastery ] then
					model:SetAngles( Angle( 0, ( FrameTime() * 50 ) % 360, -180 ) )
					shadow = false
				else
					model:SetColor( Color( 255, 255, 255 ) )
				end
				if model.Data.RequiredMastery and #model.Data.RequiredMastery > 0 then
					for _, req in ipairs( model.Data.RequiredMastery ) do
						local nmodel = wOS.ALCS.Skills.CubeModels[req]
						if not nmodel then continue end
						render.SetMaterial( wireFrame )
						local color = Color( 255, 0, 0 )
						if wOS.ALCS.Prestige.Data.Mastery[ model.Data.Mastery ] then
							color = Color( 0, 125, 255 )
						elseif wOS.ALCS.Prestige.Data.Mastery[ req ] then
							color = color_white
							shadow = false
						end
						render.DrawBeam( model:GetPos(), nmodel:GetPos(), 0.2, 0, 0, color )
					end
				else
					shadow = false
				end
				if shadow then
					model:SetMaterial( "models/wireframe" )
					model:SetColor( Color( 255, 255, 255 ) )
				end
			end
			
		end
		
	end
	
	frontpane:SetUIScale( 10 )
	frontpane.Scaling = 0.025
	
	frontpane.CamPos = wOS.ALCS.Skills.Camera[ wOS.ALCS.Skills.CamFocus ].origin + Vector( 0, 20, -2 )
	frontpane.CamAng = wOS.ALCS.Skills.Camera[ wOS.ALCS.Skills.CamFocus ].angles + Angle( 0, 0, 0 )
	table.insert( wOS.ALCS.Skills.Menu.VGUI, frontpane )
	

	selectpane.SizeX = 4.5
	selectpane.SizeY = 4.5
	selectpane.ShouldAcceptInputs = true
	selectpane.MaxH = 0
	selectpane.MaxW = 0
	selectpane.Selected = nil
	selectpane.OffsetY = offsety*2.2
	selectpane.Renders = function( pan ) 
		local ww, hh = pan.SizeX, pan.SizeY
		local scale = modelscale*1.8

		ww, hh = ww*scale*1.2, hh*scale*1.2
		
		local x = 0.5*scale
		local y = -hh - pan.OffsetY
		
		for i = 1, #pan.Positions do
			local origin = Vector( 0, 0, 0 )
			if not pan.Positions[i] then continue end
			origin:Set( pan.Positions[i] )
			origin.y = origin.y*(1/pan:GetUIScale())/pan.Scaling
			origin.z = origin.z*(1/pan:GetUIScale())/pan.Scaling

			local _jp, _pr, _hov = pan:Button( "", "wOS.TitleFont", x + origin.y - ww/2, y + origin.z, ww, hh, Color( 0, 0, 0, 0 ), Color( 0, 0, 0, 0 ) )
			if _jp then
				local model = wOS.ALCS.Skills.CubeModels[i]
				if not model then return end
				net.Start( "wOS.ALCS.Prestige.GetMasteryBate" )
					net.WriteInt( model.Data.Mastery, 32 )
				net.SendToServer()	
			elseif _hov then
				local speed = 0.1
				if not pan.SlideTimes then 
					pan.SlideTimes = CurTime() + speed
				end
				if pan.LastButt != i then
					surface.PlaySound( "wos/alcs/ui_rollover.wav" )
					pan.LastButt = i
				end
				local rat = math.Clamp( pan.SlideTimes - CurTime(), 0, speed )/speed
				pan.LastHover = CurTime() + 0.01
				local model = wOS.ALCS.Skills.CubeModels[ i ]
				if model then
					wOS.ALCS.Skills.SkillInfoPanel:SetVisible( true )
					wOS.ALCS.Skills.SkillInfoPanel.TimeShow = CurTime() + 0.075
					wOS.ALCS.Skills.SkillInfoPanel.Data = { Name = model.Data.Name, Description = model.Data.Description, Cost = model.Data.Amount, Prestige = true, Mastery = model.Data.Mastery }
				end
			end
		end
		
		if pan.SlideTimes and pan.LastHover < CurTime() then
			pan.SlideTimes	= nil
			pan.LastButt = nil
			frontpane.CurrentHover = ""
			frontpane.CurrentTitle = ""
		end

	end
	
	selectpane:SetUIScale( 10 )
	selectpane.Scaling = 0.05
	
	selectpane.CamPos = bpos + forward*25 - up*7
	selectpane.CamAng = wOS.ALCS.Skills.Camera[ wOS.ALCS.Skills.CamFocus ].angles + Angle( 0, 0, 0 )
	table.insert( wOS.ALCS.Skills.Menu.VGUI, selectpane )
	
end