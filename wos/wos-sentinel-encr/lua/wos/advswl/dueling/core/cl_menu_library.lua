--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2020
	
	Contact: www.wiltostech.com
		----------------------------------------]]--








































































wOS = wOS or {}
wOS.ALCS = wOS.ALCS or {}
wOS.ALCS.Skills = wOS.ALCS.Skills or {}
wOS.ALCS.Skills.Camera = wOS.ALCS.Skills.Camera or {}

local w,h = ScrW(), ScrH()
local pi = math.pi

local upButton = Material( "wos/crafting/gui/up.png", "unlitgeneric" )
local downButton = Material( "wos/crafting/gui/down.png", "unlitgeneric" )
local leftButton = Material( "wos/crafting/gui/left.png", "unlitgeneric" )
local rightButton = Material( "wos/crafting/gui/right.png", "unlitgeneric" )
local bufferBar = Material( "wos/crafting/gui/buffer.png", "unlitgeneric" )
local boxTop = Material( "phoenix_storms/metalset_1-2", "unlitgeneric" )

local wireFrame = Material( "trails/plasma" )

local DuelBlock = Material( "wos/advswl/duel_holocron.png", "unlitgeneric" )

local centerpoint = wOS.ALCS.Config.Crafting.CraftingCamLocation
local color_unselected = Color( 0, 0, 0, 100 )
local grad = Material( "gui/gradient_up" )

wOS.ALCS.Skills.CubeModels = wOS.ALCS.Skills.CubeModels or {}

wOS.ALCS.Skills.MenuLibrary = wOS.ALCS.Skills.MenuLibrary or {}
wOS.ALCS.Skills.Camera[ "Duel-Overview" ] = { origin = centerpoint - Vector( 45, -35, -30 ), angles = Angle( 0, 90.501, 0.000 ) }
wOS.ALCS.Skills.MenuLibrary[ "Duel-Overview" ] = function()
	
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
		image = wOS.ALCS.Runes[ "d" ]
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
			pan:Text( "VIEW DUELING SPIRITS", "wOS.TitleFont", x + ww*-2.7*( 1 - rat  ), y + bh/2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )

			pan.LastHover = CurTime() + 0.01
	    end							
		if _jp then
			wOS.ALCS.Skills:ChangeCamFocus( "Duel-SelectSpirit" )
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
		
		local data = wOS.ALCS.Dueling.DuelData
		
		pan:Text( "WON: " .. ( data.Wins or 0 ) .. "      |      LOST: " .. ( data.Losses or 0 ), "wOS.CraftDescriptions", 0, -hh*1.1, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

		local item = wOS.ALCS.Dueling.Spirits[ data.DuelSpirit ]
		if item then
			pan:Text( "[ " .. item.Name .. " ]", "wOS.TitleFont", 0, -hh*0.95, item.RarityColor or color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			local xp = ( wOS.ALCS.Dueling.SpiritData[ data.DuelSpirit ] and wOS.ALCS.Dueling.SpiritData[ data.DuelSpirit ].experience ) or 0
			if xp >= item.MaxEnergy then
				local rate = math.abs( math.cos( CurTime()*5 ) )
				pan:Text( "THIS SPIRIT MAY BE ASCENDED", "wOS.DescriptionFont", 0, -hh*0.9, Color( 255*rate, 255 - 255*rate, 255 - 255*rate, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
			end
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
			pan:Text( "USE THE RUNES TO REFLECT ON YOUR ABILITIES", "wOS.CraftDescriptions", 0, y + bh*2*( 1.5 + rat ), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
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
		
		pan:Line( x/2, y + hh*0.15, x, y + bh/2 )
		
		local lst = 0
		image = wOS.ALCS.Runes[ "a" ]
		pan:Mat( image, x, y, ww, bh )	
		local _jp, _pr, _hov = pan:Button( "", "wOS.TitleFont", x, y, ww, bh, color_white, color_white )
		if _jp then
			wOS.ALCS.Skills:ChangeCamFocus( "Duel-AscendSpirit" )
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
			pan:Text( "MANAGE ASCENSION", "wOS.TitleFont", x + ww*1.4*( 1 - rat  ), y + bh/2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			pan.LastHover = CurTime() + 0.01
	    end							
		lst = lst + 1
		
		y = y + hh*0.4
		pan:Line( x/2, y - hh*0.05, x, y + bh/2 )
		image = wOS.ALCS.Runes[ "s" ]
		pan:Mat( image, x, y, ww, bh )	
		local _jp, _pr, _hov = pan:Button( "", "wOS.TitleFont", x, y, ww, bh, color_white, color_white )
		if _jp then
			wOS.ALCS.Skills:ChangeCamFocus( "Duel-ViewSacrifices" )
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
			pan:Text( "VIEW SACRIFICES", "wOS.TitleFont", x + ww*1.7*( 1 - rat  ), y + bh/2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
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

wOS.ALCS.Skills.Camera[ "Duel-SelectSpirit" ] = { origin = centerpoint - Vector( 65, -45, -30 ), angles = Angle( 0, 180, 0.000 ) }
wOS.ALCS.Skills.MenuLibrary[ "Duel-SelectSpirit" ] = function()

	local frontpane = tduiw.Create()
	frontpane.SizeX = 8
	frontpane.SizeY = 35
	frontpane.LeftCount = 1
	frontpane.RightCount = 5	
	frontpane.ShouldAcceptInputs = true
	frontpane.LastScrollSlot = 0
	frontpane.ScrollSlot = 0
	frontpane.Selected = 1
	frontpane.TestSkills = {}
	
	for name, data in pairs( wOS.ALCS.Dueling.Spirits ) do
		if data.UserGroups then
			if not table.HasValue( data.UserGroups, LocalPlayer():GetUserGroup() ) then continue end
		end
		local leveldata = wOS.ALCS.Dueling.SpiritData[ name ]
		if not leveldata then continue end
		local model = ClientsideModel( data.SpiritModel or LocalPlayer():GetModel(), RENDERGROUP_OPAQUE )
		model.LevelData = table.Copy( leveldata )
		model.SpiritData = table.Copy( data )
		local anim = "idle_fist"
		if data.Sequence then
			local id = model:LookupSequence(data.Sequence)
			if id != -1 then anim = id end
		end
		model:SetSequence( anim )
		model:SetCycle( 0.1 )
		table.insert( wOS.ALCS.Skills.CubeModels, model )
		table.insert( frontpane.TestSkills, name )
	end
	
	frontpane.Renders = function( pan )
		local ww, hh = pan.SizeX, pan.SizeY
		
		local x = 0 - ww/2
		local y = 10
		local bh = hh/7

		local spirit = pan.TestSkills[ pan.Selected ] or ""
		if wOS.ALCS.Dueling.Spirits[ spirit ] then
			local data = wOS.ALCS.Dueling.Spirits[ spirit ]
			pan:Text( spirit, "wOS.CraftTitles", 0, -hh*1.1, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			pan:Text( data.Description, "wOS.CraftDescriptions", 0, -hh*0.85, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )	
			pan:Text( data.RarityName or "Dueling Spirit", "wOS.TitleFont", 0, -hh*0.75, data.RarityColor or color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )			
			pan:Text( "Starting Roll: " .. ( data.StartingRoll or 0 ), "wOS.TitleFont", -ww*5, -hh*0.65, data.RarityColor or color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )						
			pan:Text( "Energy Threshold: " .. ( data.MaxEnergy or 500 ), "wOS.TitleFont", ww*5, -hh*0.65, data.RarityColor or color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )						
		end
		
		local lst = 0
		image = wOS.ALCS.Runes[ "x" ]
		pan:Mat( image, x, y + bh*2.5, ww, bh )	
		local _jp, _pr, _hov = pan:Button( "", "wOS.TitleFont", x, y + bh*2.5, ww, bh, color_white, color_white )
		if _jp then
			wOS.ALCS.Skills:ChangeCamFocus( "Duel-Overview" )
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
			pan:Rect( x + ww, y + bh*2.5, ww*( 3 - 3*rat  ), bh, Color( 10, 10, 10, 255 ), color_white )
			pan:Text( "GO BACK", "wOS.TitleFont", x + ww*2.1*( 1 - rat  ), y + bh*2.5 + bh/2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			pan.LastHover = CurTime() + 0.01
	    end							
		lst = lst + 1
		
		local _jp, _pr, _hov = pan:Button( "", "wOS.TitleFont", -hh*0.55/2, -hh*0.65, hh*0.55, hh*1.05, Color( 0, 0, 0, 0 ), Color( 0, 0, 0, 0 ) )
	    if _jp then
			if !wOS.ALCS.Dueling.Spirits[ spirit ] then return end
			net.Start( "wOS.ALCS.Dueling.SelectSpirit" )
				net.WriteString( spirit )
			net.SendToServer()
		elseif _hov then
			local speed = 0.1
			if not pan.SlideTimes then 
				pan.SlideTimes = CurTime() + speed
			end
			if pan.LastButt != lst then
				surface.PlaySound( "wos/alcs/ui_rollover.wav" )
				pan.LastButt = lst
			end
			local rat = math.Clamp( pan.SlideTimes - CurTime(), 0, speed )/speed
			pan:Text( "SELECT THE SPIRIT TO EMBODY IT", "wOS.CraftDescriptions", 0, y + bh*2*( 2.25 + rat ), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			pan.LastHover = CurTime() + 0.01
	    end		
		lst = lst + 1
		
		pan:Mat( leftButton, x - ww*2, y + bh*1.2, ww, bh )	
		local _jp, _pr, _hov = pan:Button( "", "wOS.TitleFont", x - ww*2, y + bh*1.2, ww, bh, color_white, color_white )
		if _jp then
			//Keep incrementing it who am I to stop you
			//Your PC will regret it, not me
			pan.ScrollSlot = pan.ScrollSlot - 1
			pan.Selected = math.Round( pan.ScrollSlot % #pan.TestSkills ) + 1
	    elseif _hov then
			local speed = 0.1
			if pan.LastButt != lst then
				surface.PlaySound( "wos/alcs/ui_rollover.wav" )
				pan.LastButt = lst
			end
			pan.LastHover = CurTime() + 0.01
	    end							
		lst = lst + 1
		
		pan:Mat( rightButton, x + ww*2, y + bh*1.2, ww, bh )	
		local _jp, _pr, _hov = pan:Button( "", "wOS.TitleFont", x + ww*2, y + bh*1.2, ww, bh, color_white, color_white )
		if _jp then
			//Keep incrementing it who am I to stop you
			//Your PC will regret it, not me
			pan.ScrollSlot = pan.ScrollSlot + 1
			pan.Selected = math.Round( pan.ScrollSlot % #pan.TestSkills ) + 1
	    elseif _hov then
			local speed = 0.1
			if pan.LastButt != lst then
				surface.PlaySound( "wos/alcs/ui_rollover.wav" )
				pan.LastButt = lst
			end
			pan.LastHover = CurTime() + 0.01
	    end							
		lst = lst + 1
		
		if pan.SlideTimes and pan.LastHover < CurTime() then
			pan.SlideTimes	= nil
			pan.LastButt = nil
		end
	
	end
	frontpane.PostRenders = function( pan )
		local radius = 7.7
		pan.LastScrollSlot = math.Approach( pan.LastScrollSlot, pan.ScrollSlot, 0.01 )
		local offset = pi*5/10 + pi*2/#pan.TestSkills*pan.LastScrollSlot
		local basesize = 1.3 * ( 1 - 0.04*(#pan.TestSkills/15) )
		for i = 1, #pan.TestSkills do
			local j = i - 1
			local x, y = math.sin( offset - pi*j*2/#pan.TestSkills ), math.cos( offset - pi*j*2/#pan.TestSkills )
			local setpos = pan.CamPos - Vector( 8, 0, 0 ) + Vector( radius*x, radius*y, -3 )
			local size = 40/setpos:DistToSqr( wOS.ALCS.Skills.Camera[ wOS.ALCS.Skills.CamFocus ].origin )	//Clinically proven to be the number
			if not wOS.ALCS.Skills.CubeModels[i] then continue end
			wOS.ALCS.Skills.CubeModels[i]:SetPos( setpos )
			wOS.ALCS.Skills.CubeModels[i]:SetModelScale( basesize*size )
			if wOS.ALCS.Skills.CubeModels[i].SpiritData.Name == wOS.ALCS.Dueling.DuelData.DuelSpirit then
				halo.Add( { wOS.ALCS.Skills.CubeModels[i] }, Color( 255, 255, 255, 5 ), 5, 5, 1 )
			end
			if i == pan.Selected then
				wOS.ALCS.Skills.CubeModels[i]:FrameAdvance( 1 )
				if wOS.ALCS.Skills.CubeModels[i]:GetCycle() >= 0.99 then
					wOS.ALCS.Skills.CubeModels[i]:SetCycle( 0 )
				end
			end
		end
	end
	frontpane:SetUIScale( 10 )
	frontpane.Scaling = 0.025
	
	frontpane.CamPos = wOS.ALCS.Skills.Camera[ wOS.ALCS.Skills.CamFocus ].origin + Vector( -20, 0, 0 )
	frontpane.CamAng = wOS.ALCS.Skills.Camera[ wOS.ALCS.Skills.CamFocus ].angles + Angle( 0, 0, 0 )
	table.insert( wOS.ALCS.Skills.Menu.VGUI, frontpane )
	
end

wOS.ALCS.Skills.Camera[ "Duel-AscendSpirit" ] = { origin = centerpoint - Vector( 45, 10, -30 ), angles = Angle( 0, 270, 0.000 ) }
wOS.ALCS.Skills.MenuLibrary[ "Duel-AscendSpirit" ] = function()
	
	wOS.ALCS.Dueling.Results = nil
	
	local forward = wOS.ALCS.Skills.Camera[ wOS.ALCS.Skills.CamFocus ].angles:Forward()
	local right = wOS.ALCS.Skills.Camera[ wOS.ALCS.Skills.CamFocus ].angles:Right()
	local up = wOS.ALCS.Skills.Camera[ wOS.ALCS.Skills.CamFocus ].angles:Up()
	
	local backbutt = tduiw.Create()
	backbutt.SizeX = 50
	backbutt.SizeY = 25
	backbutt.ShouldAcceptInputs = true
	
	local frontpane = tduiw.Create()
	frontpane.SizeX = 8
	frontpane.SizeY = 35
	frontpane.LeftCount = 1
	frontpane.RightCount = 5	
	frontpane.ShouldAcceptInputs = true
	frontpane.LastScrollSlot = 0
	frontpane.ScrollSlot = 0
	frontpane.Selected = 1
	frontpane.Offset = 0
	
	frontpane.Data = wOS.ALCS.Dueling.Spirits[ wOS.ALCS.Dueling.DuelData.DuelSpirit ]
	frontpane.Artifacts = {}
	frontpane.Renders = function( pan )
		local ww, hh = pan.SizeX, pan.SizeY
		local bh = hh/7
		local pady = bh*0.05
		local x = 40 - ww*4
		local y = -22
		local lst = 0
		
		pan:Rect( x, y + bh, ww*4, bh*2 + pady*3, Color( 0, 0, 0, 0 ), color_white )
		pan:Rect( x, y, ww*4, bh, Color( 0, 0, 0, 0 ), color_white )
		pan:Text( wOS.ALCS.Dueling.DuelData.DuelSpirit or "Duelist", "wOS.TitleFont", x + ww*2, y + bh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )	
		
		local data = wOS.ALCS.Dueling.SpiritData[ wOS.ALCS.Dueling.DuelData.DuelSpirit ]
		local bonus = ( data.experience > pan.Data.MaxEnergy and " [ " .. data.experience - pan.Data.MaxEnergy .. " ]" ) or ""
		pan:Text( "Current Energy: " .. data.experience .. bonus, "wOS.TitleFont", x + ww*0.1, y + bh + bh/2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )	
		
		local strength = ( data.level < data.lastlevel and "DRAINED" ) or "HEALTHY"
		pan:Text( "Spirit Strength: " .. strength, "wOS.TitleFont", x + ww*0.1, y + bh*2 + bh/2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )			
				
		if wOS.ALCS.Dueling.Results then
			local result = wOS.ALCS.Dueling.Results
			local offset = y + bh*3.5 + pady*4
			pan:Text( "ASCENSION RESULTS", "wOS.TitleFont", x + ww*2, offset, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			offset = offset + bh/2
			pan:Text( "Artifact: " .. result.artifact, "wOS.DescriptionFont", x + ww*2, offset, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )				
			offset = offset + bh/2
			
			local width = 0
			local text = ""
			if CurTime() - result.time >= 0 then
				local rat = math.min( 3, CurTime() - result.time )/3
				width = width + rat*result.start
				text = text .. "Starting Strength: " .. math.Round( rat*result.start )
			end

			if CurTime() - result.time >= 3 then
				local rat = math.min( 3, CurTime() - result.time - 3 )/3
				width = width + rat*result.mod
				text = text .. "  |  Modifier: " .. math.Round( rat*result.mod )
			end
			
			if CurTime() - result.time >= 6 then
				local rat = math.min( 3, CurTime() - result.time - 6 )/3
				width = width + rat*result.roll
				text = text .. "  |  Ascension Roll: " .. math.Round( rat*result.roll )
			end
			
			pan:Text( text, "wOS.DescriptionFont", x + ww*2, offset, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )				
			offset = offset + bh/2
			
			local frat = math.min( width / result.required, 1 )
			if CurTime() - result.time >= 9 then
				local rat = math.min( 1, CurTime() - result.time - 9 )
				pan:Text( ( frat == 1 and "[ ARTIFACT AWARDED ]" ) or "[ ARTIFACT LOST ]", "wOS.DescriptionFont", x + ww*2, offset, ( frat == 1 and Color( 0, 255, 0, 255*rat ) ) or Color( 255, 0, 0, 255*rat ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )				
			end
			
			offset = offset + bh/2
			pan:Rect( x, offset, ww*4, bh/2, Color( 0,0,0,0 ), color_white )
			pan:Mat( grad, x, offset, ww*4*frat, bh/2, Color( 148, 0, 211, 175 ) )
		end
		
		y = -18 + bh*6 + pady*8
		
		local image = wOS.ALCS.Runes[ "a" ]
		pan:Mat( image, x, y, ww, bh )	
		local _jp, _pr, _hov = pan:Button( "", "wOS.TitleFont", x, y, ww, bh, color_white, color_white )
		if _jp then
			net.Start( "wOS.ALCS.Dueling.AscendSpirit" )
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
			pan:Text( "ASCEND SPIRIT", "wOS.TitleFont", x + ww*1.8*( 1 - rat  ), y + bh/2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			pan.LastHover = CurTime() + 0.01
	    end							
		lst = lst + 1
		
		y = y + bh + pady
		image = wOS.ALCS.Runes[ "x" ]
		pan:Mat( image, x, y, ww, bh )	
		local _jp, _pr, _hov = pan:Button( "", "wOS.TitleFont", x, y, ww, bh, color_white, color_white )
		if _jp then
			wOS.ALCS.Skills:ChangeCamFocus( "Duel-Overview" )
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
		
		if pan.SlideTimes and pan.LastHover < CurTime() then
			pan.SlideTimes	= nil
			pan.LastButt = nil
		end
	
	end
	frontpane:SetUIScale( 10 )
	frontpane.Scaling = 0.025
	
	frontpane.CamPos = wOS.ALCS.Skills.Camera[ wOS.ALCS.Skills.CamFocus ].origin + forward*15
	frontpane.CamAng = wOS.ALCS.Skills.Camera[ wOS.ALCS.Skills.CamFocus ].angles + Angle( 0, -27, 0 )
	table.insert( wOS.ALCS.Skills.Menu.VGUI, frontpane )
	
	wOS.ALCS.Skills.CubeModels[1] = ClientsideModel( frontpane.Data.SpiritModel or LocalPlayer():GetModel() )
	wOS.ALCS.Skills.CubeModels[1]:SetPos( frontpane.CamPos + forward*100 - up*30 - right*40 )
	wOS.ALCS.Skills.CubeModels[1]:SetAngles( Angle( 0, 90, 0 ) )
	wOS.ALCS.Skills.CubeModels[1]:SetSequence( "pose_standing_01" )
	frontpane.PostRenders = function( pan )
		if not IsValid( wOS.ALCS.Skills.CubeModels[1] ) then return end
		wOS.ALCS.Skills.CubeModels[1]:FrameAdvance( 1 )
		if wOS.ALCS.Skills.CubeModels[1]:GetCycle() >= 0.99 and not pan.Ascending then
			wOS.ALCS.Skills.CubeModels[1]:SetCycle( 0 )
		end
	end
	
	

	backbutt.Renders = function( pan )
		local data = wOS.ALCS.Dueling.SpiritData[ wOS.ALCS.Dueling.DuelData.DuelSpirit ]
		if not data then return end
		local ww, hh = pan.SizeX, pan.SizeY
		local x = 10
		local y = -50
		
		local level = data.level
		local xp = data.experience
		local reqxp = frontpane.Data.MaxEnergy
		local lastxp = 0
		
		local rat = math.min( 1, xp/reqxp )

		pan:Text( "SPIRIT ENERGY", "wOS.CraftTitles", x, y, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		
		y = y + hh*0.23
		
		pan:Mat( grad, x, y, ww*rat, hh*0.12, Color( 148, ( xp > reqxp and 25 + 25*math.sin( CurTime()*10 ) ) or 0, 211, 175 ) )
		pan:Rect( x, y, ww, hh*0.12, Color( 0,0,0,0 ), color_white )
		
		y = y + hh*0.06
		local text = lastxp
		pan:Text( " " .. text, "wOS.CraftDescriptions", x, y, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
	
		text = reqxp
		pan:Text( text .. " ", "wOS.CraftDescriptions", x + ww, y, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
		pan:Text( "|", "wOS.CraftDescriptions", x + ww/2, y, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		
		y = y + hh*0.06
		pan:Text( "ASCENSION LEVEL " .. level, "wOS.CraftDescriptions", x, y, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		
		pan:BlockUseBind()
	end
	backbutt:SetUIScale( 20 )
	backbutt.Scaling = 0.05
	
	local spos = wOS.ALCS.Skills.CubeModels[1]:GetPos()
	backbutt.CamPos = spos - wOS.ALCS.Skills.CubeModels[1]:GetRight()*30 + wOS.ALCS.Skills.CubeModels[1]:GetForward()*20 
	backbutt.CamAng = wOS.ALCS.Skills.Camera[ wOS.ALCS.Skills.CamFocus ].angles + Angle( 0, 0, -90 )
	table.insert( wOS.ALCS.Skills.Menu.VGUI, backbutt )		
	
end

wOS.ALCS.Skills.Camera[ "Duel-ViewSacrifices" ] = { origin = centerpoint - Vector( 45, 10, -30 ), angles = Angle( 0, 270, 0.000 ) }
wOS.ALCS.Skills.MenuLibrary[ "Duel-ViewSacrifices" ] = function()
	
	local forward = wOS.ALCS.Skills.Camera[ wOS.ALCS.Skills.CamFocus ].angles:Forward()
	local right = wOS.ALCS.Skills.Camera[ wOS.ALCS.Skills.CamFocus ].angles:Right()
	local up = wOS.ALCS.Skills.Camera[ wOS.ALCS.Skills.CamFocus ].angles:Up()
	
	local frontpane = tduiw.Create()
	frontpane.SizeX = 8
	frontpane.SizeY = 35
	frontpane.LeftCount = 1
	frontpane.RightCount = 5	
	frontpane.ShouldAcceptInputs = true
	frontpane.LastScrollSlot = 0
	frontpane.ScrollSlot = 0
	frontpane.Selected = 1
	frontpane.Offset = 0
	
	frontpane.Inventory = {}
	
	for slot, data in pairs( wOS.SaberInventory ) do
		local name = data
		local amount = 1
		if istable( data ) then
			name = data.Name
			amount = data.Amount or 1
		end
		if not wOS.ItemList[ name ] then continue end
		table.insert( frontpane.Inventory, { name = name, amount = amount, slot = slot } )
	end

	frontpane.Renders = function( pan )
		local ww, hh = pan.SizeX, pan.SizeY
		local bh = hh/7
		local pady = bh*0.05
		local x = 40 - ww*4
		local y = -26
		local lst = 0
		
		if #pan.Inventory > 6 then
			pan:Mat( upButton, x - ww*1.1, y, ww, hh*0.25 )
			local _jp, _pr, _hov = pan:Button( "", "wOS.TitleFont", x - ww*1.1, y, ww, hh*0.25, color_white, color_white )
			if _jp then
				if pan.Offset <= 0 then return end
				pan.Offset = pan.Offset - 1
				surface.PlaySound( "buttons/lightswitch2.wav" )
			elseif _hov then
				local speed = 0.1
				if pan.LastButt != lst then
					surface.PlaySound( "wos/alcs/ui_rollover.wav" )
					pan.LastButt = lst
				end
				pan.LastHover = CurTime() + 0.01
			end					
			pan:Mat( bufferBar, x - ww*1.1, y + hh*0.3, ww, hh*0.3 )	
			pan:Rect( x - ww*1.1, y + hh*0.3, ww, hh*0.3, Color( 0, 0, 0, 0 ), color_white )			
			pan:Mat( downButton, x - ww*1.1, y + hh*0.65, ww, hh*0.25 )
			local _jp, _pr, _hov = pan:Button( "", "wOS.TitleFont", x - ww*1.1, y + hh*0.65, ww, hh*0.25, color_white, color_white )			
			if _jp then
				if pan.Offset + 6 >= #pan.Inventory then return end
				pan.Offset = pan.Offset + 1
				surface.PlaySound( "buttons/lightswitch2.wav" )
			elseif _hov then
				local speed = 0.1
				if pan.LastButt != lst then
					surface.PlaySound( "wos/alcs/ui_rollover.wav" )
					pan.LastButt = lst
				end
				pan.LastHover = CurTime() + 0.01
			end							
		end
		
		for i = 1, 6 do
			local slot = i + pan.Offset
			if slot > #pan.Inventory then break end
			local dat = pan.Inventory[slot]
			local col = color_white

			pan:Text( dat.name, "wOS.TitleFont", x + ww*0.1, y + bh/2, col, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			if dat.amount > 1 then
				pan:Text( "x" .. dat.amount, "wOS.TitleFont", x + ww*3.9, y + bh/2, col, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
			end
			local _jp, _pr, _hov = pan:Button( "", "wOS.TitleFont", x, y, ww*4, bh, col, color_white )
			if _jp then
				pan.Selected = slot
			elseif _hov then
				local speed = 0.1
				if pan.LastButt != lst then
					surface.PlaySound( "wos/alcs/ui_rollover.wav" )
					pan.LastButt = lst
				end
				pan.LastHover = CurTime() + 0.01
			end	
			lst = lst + 1
			y = y + bh + pady			
		end
		
		if #pan.Inventory < 1 then
			pan:Rect( x, y, ww*4, bh*6 + pady*5, Color( 0, 0, 0, 0 ), color_white )
			pan:Text( "NO ITEMS AVAILABLE", "wOS.TitleFont", x + ww*2, y + bh*3 + pady*2.5, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )	
		end
		
		y = -26 + bh*6 + pady*6	
		
		image = wOS.ALCS.Runes[ "x" ]
		pan:Mat( image, x, y, ww, bh )	
		local _jp, _pr, _hov = pan:Button( "", "wOS.TitleFont", x, y, ww, bh, color_white, color_white )
		if _jp then
			wOS.ALCS.Skills:ChangeCamFocus( "Duel-Overview" )
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
		
		if pan.SlideTimes and pan.LastHover < CurTime() then
			pan.SlideTimes	= nil
			pan.LastButt = nil
		end
	
	end
	frontpane:SetUIScale( 10 )
	frontpane.Scaling = 0.018
	
	frontpane.CamPos = wOS.ALCS.Skills.Camera[ wOS.ALCS.Skills.CamFocus ].origin + forward*15
	frontpane.CamAng = wOS.ALCS.Skills.Camera[ wOS.ALCS.Skills.CamFocus ].angles + Angle( 0, -27, 0 )
	table.insert( wOS.ALCS.Skills.Menu.VGUI, frontpane )
	
	local infopane = tduiw.Create()
	infopane.SizeX = 90
	infopane.SizeY = 35
	infopane.LeftCount = 1
	infopane.RightCount = 5	
	infopane.ShouldAcceptInputs = true
	infopane.Renders = function( pan )
		local ww, hh = pan.SizeX, pan.SizeY
		local x = 0
		local y = -hh*8
		local bh = hh*1.5

		pan:Text( "ENERGY COLLECTED", "wOS.TitleFont", -ww*2, hh*7, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )
		pan:Text( wOS.ALCS.Dueling.DuelData.Sacrifices or 0, "wOS.TitleFont", -ww*1.9, hh*7 + bh/4, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )	
		pan:Text( wOS.ALCS.Config.Dueling.SacrificeRoll, "wOS.TitleFont", -ww*2 + ww*3.9, hh*7 + bh/4, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
		pan:Text( ( wOS.ALCS.Config.Dueling.SacrificeRoll - ( wOS.ALCS.Dueling.DuelData.Sacrifices or 0 ) ) .. " UNTIL SUMMON", "wOS.TitleFont", ww*2, hh*7 + bh/2, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP )
		local frat = math.min( wOS.ALCS.Dueling.DuelData.Sacrifices / wOS.ALCS.Config.Dueling.SacrificeRoll, 1 )
		pan:Rect( -ww*2, hh*7, ww*4, bh/2, Color( 0,0,0,0 ), color_white )
		pan:Mat( grad, -ww*2, hh*7, ww*4*frat, bh/2, Color( 148, 0, 211, 175 ) )
		
		local item = frontpane.Inventory[ frontpane.Selected ]
		if not item then return end
		local dat = wOS.ItemList[ item.name ]
		if not dat then return end
		pan:Text( dat.Name, "wOS.CraftDescriptions", x, y, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		pan:Text( dat.RarityName or "Common", "wOS.TitleFont", x, y + hh*0.7, dat.RarityColor or color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
		local rare = "No"
		if dat.Rarity then
			rare = ( dat.Rarity > 0 and ( 1 / ( dat.Rarity ) ) * 10 ) or "No"
		end
		pan:Text( rare .. " Sacrificial Energy", "wOS.TitleFont", x, y + hh*1.8, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )	
		
		y = hh*4
		local size = ww*4
		x = -size/2
		local lst = 0

		local image = wOS.ALCS.Runes[ "k" ]
		pan:Rect( x + size - ww, y, ww, bh, Color( 10, 10, 10, 255 ), Color( 0, 0, 0, 0 ) )
		pan:Mat( image, x + size - ww, y, ww, bh )	
		local _jp, _pr, _hov = pan:Button( "", "wOS.TitleFont", x + size - ww, y, ww, bh, color_white, color_white )
		if _jp then
			net.Start( "wOS.ALCS.Dueling.SacrificeItem" )
				net.WriteString( dat.Name )
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
			pan:Rect( x + size - ww, y, -1*size*0.5*( 1 - rat  ), bh, Color( 10, 10, 10, 255 ), color_white )
			pan:Text( "SACRIFICE", "wOS.TitleFont", x + size - size*0.5*( 1 - rat  ), y + bh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			pan:Text( "REMOVES ITEM FROM INVENTORY", "wOS.DescriptionFont", x + size - size*0.5, y + bh*1.1*( 1 + rat ), Color( 255, 0, 0 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
			pan.LastHover = CurTime() + 0.01
	    end
		lst = lst + 1

		if pan.SlideTimes and pan.LastHover < CurTime() then
			pan.SlideTimes	= nil
			pan.LastButt = nil
		end
		
	end
	infopane.CamPos = wOS.ALCS.Skills.Camera[ wOS.ALCS.Skills.CamFocus ].origin + forward*70 - right*30
	infopane.CamAng = wOS.ALCS.Skills.Camera[ wOS.ALCS.Skills.CamFocus ].angles + Angle( 0, 0, 0 )
	table.insert( wOS.ALCS.Skills.Menu.VGUI, infopane )
	
	wOS.ALCS.Skills.CubeModels[1] = ClientsideModel( "models/props_lab/huladoll.mdl" )
	wOS.ALCS.Skills.CubeModels[1]:SetPos( frontpane.CamPos + forward*80 - up*5 - right*40 )
	frontpane.PostRenders = function( pan )
		local model = "models/props_lab/huladoll.mdl"
		if pan.Inventory[ pan.Selected ] then
			local name = pan.Inventory[ pan.Selected ].name
			if name then
				local item = wOS.ItemList[ name ]
				if item then
					if item.Model then
						model = item.Model
					end
				end
			end
		end
		local display = wOS.ALCS.Skills.CubeModels[1]
		if not IsValid( display ) then return end
		if display:GetModel() != model then
			display:SetModel( model )
		end
		local ang = display:GetAngles()
		ang:RotateAroundAxis( ang:Up(), FrameTime()*40 )
		display:SetAngles( ang )
	end
	
end