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
local boxTop = Material( "phoenix_storms/metalset_1-2", "unlitgeneric" )

local wireFrame = Material( "trails/plasma" )

local CombatBlock = Material( "wos/advswl/combat_holocron.png", "unlitgeneric" )

local centerpoint = wOS.ALCS.Config.Crafting.CraftingCamLocation
local color_unselected = Color( 0, 0, 0, 100 )
local grad = Material( "gui/gradient_up" )

wOS.ALCS.Skills.CubeModels = wOS.ALCS.Skills.CubeModels or {}

wOS.ALCS.Skills.MenuLibrary = wOS.ALCS.Skills.MenuLibrary or {}
wOS.ALCS.Skills.Camera[ "Combat-Overview" ] = { origin = centerpoint - Vector( 45, -35, -30 ), angles = Angle( 0, 90.501, 0.000 ) }
wOS.ALCS.Skills.MenuLibrary[ "Combat-Overview" ] = function()
	
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
		image = wOS.ALCS.Runes[ "e" ]
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
			pan:Text( "VIEW EXECUTIONS", "wOS.TitleFont", x + ww*-2.7*( 1 - rat  ), y + bh/2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )

			pan.LastHover = CurTime() + 0.01
	    end							
		if _jp then
			wOS.ALCS.Skills:ChangeCamFocus( "Combat-SelectExec" )
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
		
		local level = LocalPlayer():GetNW2Int( "wOS.ProficiencyLevel", 0 )
		local xp = LocalPlayer():GetNW2Int( "wOS.ProficiencyExperience", 0 )
		
		pan:Text( "PROFICIENCY LEVEL " .. level, "wOS.CraftDescriptions", 0, -hh*1.1, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		pan:Text( xp .. " EXPERIENCE POINTS", "wOS.TitleFont", 0, -hh, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

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
			pan:Text( "USE THE RUNES TO PERFECT YOUR FIGHTING STYLE", "wOS.CraftDescriptions", 0, y + bh*2*( 1.5 + rat ), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			pan.LastHover = CurTime() + 0.01
	    end		
		lst = lst + 1
		
		if pan.SlideTimes and pan.LastHover < CurTime() then
			pan.SlideTimes	= nil
			pan.LastButt = nil
		end
	
	end
	frontpane.PostRenders = function( pan )
		wOS.ALCS.Skills:CreateCubeMat( pan.CamPos, CombatBlock, nil, 6 )
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
		local y = -hh*0.3
		local bh = hh/7
		
		pan:Line( x/2, y - hh*0.15, x, y + bh/2 )
		
		local lst = 0
		image = wOS.ALCS.Runes[ "a" ]
		pan:Mat( image, x, y, ww, bh )	
		local _jp, _pr, _hov = pan:Button( "", "wOS.TitleFont", x, y, ww, bh, color_white, color_white )
		if _jp then
			wOS.ALCS.Skills:ChangeCamFocus( "Combat-Preferences" )
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
			pan:Text( "MANAGE PREFERENCES", "wOS.TitleFont", x + ww*1.4*( 1 - rat  ), y + bh/2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
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

wOS.ALCS.Skills.Camera[ "Combat-SelectExec" ] = { origin = centerpoint - Vector( 65, -45, -30 ), angles = Angle( 0, 180, 0.000 ) }
wOS.ALCS.Skills.MenuLibrary[ "Combat-SelectExec" ] = function()

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
	
	for name, data in pairs( wOS.ALCS.ExecSys.Executions ) do
		if !wOS.ALCS.ExecSys:CanUseExecution( name ) then continue end
		local model = ClientsideModel( LocalPlayer():GetModel(), RENDERGROUP_OPAQUE )
		model:SetSequence( data.PreviewSequence or "wos_hatred_start" )
		model:SetCycle( data.PreviewFrame or 0.5 )
		model.EData = data
		table.insert( wOS.ALCS.Skills.CubeModels, model )
		table.insert( frontpane.TestSkills, name )
	end
	
	frontpane.Renders = function( pan )
		local ww, hh = pan.SizeX, pan.SizeY
		
		local x = 0 - ww/2
		local y = 10
		local bh = hh/7

		local execution = pan.TestSkills[ pan.Selected ] or ""
		if wOS.ALCS.ExecSys.Executions[ execution ] then
			local data = wOS.ALCS.ExecSys.Executions[ execution ]
			pan:Text( execution, "wOS.CraftTitles", 0, -hh*1.1, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			pan:Text( data.Description, "wOS.CraftDescriptions", 0, -hh*0.85, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )	
			pan:Text( data.RarityName or "Common", "wOS.TitleFont", 0, -hh*0.75, data.RarityColor or color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )			
		end
		
		local lst = 0
		image = wOS.ALCS.Runes[ "x" ]
		pan:Mat( image, x, y + bh*2.5, ww, bh )	
		local _jp, _pr, _hov = pan:Button( "", "wOS.TitleFont", x, y + bh*2.5, ww, bh, color_white, color_white )
		if _jp then
			wOS.ALCS.Skills:ChangeCamFocus( "Combat-Overview" )
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
			if !wOS.ALCS.ExecSys.Executions[ execution ] then return end
			net.Start( "wOS.ALCS.ExecSys.SelectExecution" )
				net.WriteString( execution )
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
			pan:Text( "SELECT THE EXECUTION TO USE IT", "wOS.CraftDescriptions", 0, y + bh*2*( 2.25 + rat ), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
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
			if wOS.ALCS.LightsaberPreferences.Execution and wOS.ALCS.Skills.CubeModels[i].EData.Name == wOS.ALCS.LightsaberPreferences.Execution then
				halo.Add( { wOS.ALCS.Skills.CubeModels[i] }, Color( 255, 255, 255, 5 ), 5, 5, 1 )
			end
		end
	end
	frontpane:SetUIScale( 10 )
	frontpane.Scaling = 0.025
	
	frontpane.CamPos = wOS.ALCS.Skills.Camera[ wOS.ALCS.Skills.CamFocus ].origin + Vector( -20, 0, 0 )
	frontpane.CamAng = wOS.ALCS.Skills.Camera[ wOS.ALCS.Skills.CamFocus ].angles + Angle( 0, 0, 0 )
	table.insert( wOS.ALCS.Skills.Menu.VGUI, frontpane )
	
end

wOS.ALCS.Skills.Camera[ "Combat-Preferences" ] = { origin = centerpoint - Vector( 45, 10, -30 ), angles = Angle( 0, 270, 0.000 ) }
wOS.ALCS.Skills.MenuLibrary[ "Combat-Preferences" ] = function()
	
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
	frontpane.SelectMode = 0
	frontpane.Renders = function( pan )
		local ww, hh = pan.SizeX, pan.SizeY
		local bh = hh/7
		local pady = bh*0.05
		local x = 25
		local y = -22
		local lst = 0
		
		y = -18
		
		local image = wOS.ALCS.Runes[ "h" ]
		pan:Mat( image, x, y, ww, bh )	
		local _jp, _pr, _hov = pan:Button( "", "wOS.TitleFont", x, y, ww, bh, color_white, color_white )
		if _jp then
			frontpane.SelectMode = 1
	    elseif _hov then
			if frontpane.SelectMode != 1 then
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
				pan:Text( "GRIP SELECTION", "wOS.TitleFont", x + ww*1.6*( 1 - rat  ), y + bh/2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
				pan.LastHover = CurTime() + 0.01
			end
	    end	
		
		pan:Line( x, y + bh/2, x - ww*1.2, y + bh/2 )
		pan:Line( x - ww*1.2, y + bh/2, x - ww*2, y + bh*2.5 )
		
		if frontpane.SelectMode == 1 then
			pan:Rect( x + ww, y, ww*3, bh, Color( 10, 10, 10, 255 ), color_white )
			pan:Text( "GRIP SELECTION", "wOS.TitleFont", x + ww*1.6, y + bh/2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			lst = lst + 1
			y = y + bh + pady
			for _, data in pairs( wOS.ALCS.LightsaberBase.Grips ) do
				pan:Rect( x, y, ww*4, bh, Color( 10, 10, 10, 255 ), color_white )
				local _jp, _pr, _hov = pan:Button( data.Name, "wOS.TitleFont", x, y, ww*4, bh, ( wOS.ALCS.LightsaberPreferences.Grip == data.Name and Color( 255, 0, 0 ) ) or color_white, ( wOS.ALCS.LightsaberPreferences.Grip == data.Name and Color( 255, 0, 0 ) ) or color_white )
				if _jp then
					net.Start( "wOS.ALCS.SelectGrip" )
						net.WriteString( data.Name )
					net.SendToServer()
				elseif _hov then
					if pan.LastButt != lst then
						surface.PlaySound( "wos/alcs/ui_rollover.wav" )
						pan.LastButt = lst
					end
				end	
				y = y + bh + pady		
				lst = lst + 1
			end
		end

		y = -18 + bh*7 + pady*9
		x = 20
		image = wOS.ALCS.Runes[ "x" ]
		pan:Mat( image, x, y, ww, bh )	
		local _jp, _pr, _hov = pan:Button( "", "wOS.TitleFont", x, y, ww, bh, color_white, color_white )
		if _jp then
			wOS.ALCS.Skills:ChangeCamFocus( "Combat-Overview" )
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
	
	frontpane.CamPos = wOS.ALCS.Skills.Camera[ wOS.ALCS.Skills.CamFocus ].origin + forward*21
	frontpane.CamAng = wOS.ALCS.Skills.Camera[ wOS.ALCS.Skills.CamFocus ].angles + Angle( 0, -27, 0 )
	table.insert( wOS.ALCS.Skills.Menu.VGUI, frontpane )
	
	local leftpane = tduiw.Create()
	leftpane.SizeX = 8
	leftpane.SizeY = 35
	leftpane.LeftCount = 1
	leftpane.RightCount = 5	
	leftpane.ShouldAcceptInputs = true
	leftpane.LastScrollSlot = 0
	leftpane.ScrollSlot = 0
	leftpane.Selected = 1
	leftpane.Offset = 0
	leftpane.SelectMode = 0
	leftpane.Renders = function( pan )
		local ww, hh = pan.SizeX, pan.SizeY
		local bh = hh/7
		local pady = bh*0.05
		local x = -56
		local y = -2
		local lst = 0
		

		pan:Line( 0, -hh/2, x + ww, y - bh*2 )
		pan:Line( x + ww, y - bh*2, x + ww/2, y )
		
		local image = wOS.ALCS.Runes[ "w" ]
		pan:Mat( image, x, y, ww, bh )	
		local _jp, _pr, _hov = pan:Button( "", "wOS.TitleFont", x, y, ww, bh, color_white, color_white )
		if _jp then
			frontpane.SelectMode = 2
	    elseif _hov then
			if frontpane.SelectMode != 2 then
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
				pan:Text( "WIELDING PREFERENCE", "wOS.TitleFont", x + ww*1.2*( 1 - rat  ), y + bh/2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
				pan.LastHover = CurTime() + 0.01
			end
	    end	
		if frontpane.SelectMode == 2 then
			pan:Rect( x + ww, y, ww*3, bh, Color( 10, 10, 10, 255 ), color_white )
			pan:Text( "WIELDING PREFERENCE", "wOS.TitleFont", x + ww*1.2, y + bh/2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			lst = lst + 1
			y = y + bh + pady
			
			pan:Rect( x, y, ww*4, bh, Color( 10, 10, 10, 255 ), color_white )
			local _jp, _pr, _hov = pan:Button( "One Hand ( Right )", "wOS.TitleFont", x, y, ww*4, bh, ( !wOS.ALCS.LightsaberPreferences.Wield and Color( 255, 0, 0 ) ) or color_white, ( !wOS.ALCS.LightsaberPreferences.Wield and Color( 255, 0, 0 ) ) or color_white )
			if _jp then
				net.Start( "wOS.ALCS.SelectWield" )
					net.WriteBool( false )
				net.SendToServer()
			elseif _hov then
				if pan.LastButt != lst then
					surface.PlaySound( "wos/alcs/ui_rollover.wav" )
					pan.LastButt = lst
				end
			end	
			y = y + bh + pady		
			lst = lst + 1
			
			pan:Rect( x, y, ww*4, bh, Color( 10, 10, 10, 255 ), ( wOS.ALCS.LightsaberPreferences.Wield and Color( 66, 117, 176 ) ) or color_white )
			local _jp, _pr, _hov = pan:Button( "Dual Wield", "wOS.TitleFont", x, y, ww*4, bh, ( wOS.ALCS.LightsaberPreferences.Wield and Color( 255, 0, 0 ) ) or color_white, ( wOS.ALCS.LightsaberPreferences.Wield and Color( 255, 0, 0 ) ) or color_white )
			if _jp then
				net.Start( "wOS.ALCS.SelectWield" )
					net.WriteBool( true )
				net.SendToServer()
			elseif _hov then
				if pan.LastButt != lst then
					surface.PlaySound( "wos/alcs/ui_rollover.wav" )
					pan.LastButt = lst
				end
			end	
			y = y + bh + pady		
			lst = lst + 1
			
		end
		
		if pan.SlideTimes and pan.LastHover < CurTime() then
			pan.SlideTimes	= nil
			pan.LastButt = nil
		end
	
	end
	leftpane:SetUIScale( 10 )
	leftpane.Scaling = 0.025
	
	leftpane.PostRenders = function( pan )
		if not wOS.ALCS.Skills.CubeModels[1] then return end
		wOS.ALCS.Skills.CubeModels[1]:DrawModel()
	end
	
	leftpane.CamPos = wOS.ALCS.Skills.Camera[ wOS.ALCS.Skills.CamFocus ].origin + forward*21
	leftpane.CamAng = wOS.ALCS.Skills.Camera[ wOS.ALCS.Skills.CamFocus ].angles + Angle( 0, 27, 0 )
	table.insert( wOS.ALCS.Skills.Menu.VGUI, leftpane )
	
	wOS.ALCS.Skills.CubeModels[1] = ClientsideModel( LocalPlayer():GetModel() )
	wOS.ALCS.Skills.CubeModels[1]:SetPos( frontpane.CamPos + forward*75 - up*30 - right*10 )
	wOS.ALCS.Skills.CubeModels[1]:SetAngles( Angle( 0, 180, 0 ) )
	wOS.ALCS.Skills.CubeModels[1]:SetSequence( "vanguard_f_idle" )
	wOS.ALCS.Skills.CubeModels[1]:SetNoDraw( true )
	
	local bone = wOS.ALCS.Skills.CubeModels[1]:LookupBone( "ValveBiped.Bip01_R_Hand" )
	local rpos, rang = Vector( 0, 0, 0 ), Angle( 0, 0, 0 )
	if bone then
		rpos, rang = wOS.ALCS.Skills.CubeModels[1]:GetBonePosition( bone )
		rang:RotateAroundAxis( rang:Right(), 90 )
		rpos = rpos - rang:Forward()*6 - rang:Up()*1.8 + rang:Right()*0.5
	end
	
	bone = wOS.ALCS.Skills.CubeModels[1]:LookupBone( "ValveBiped.Bip01_L_Hand" )
	local lpos, lang = Vector( 0, 0, 0 ), Angle( 0, 0, 0 )
	if bone then
		lpos, lang = wOS.ALCS.Skills.CubeModels[1]:GetBonePosition( bone )
		lang:RotateAroundAxis( lang:Right(), -90 )
		lpos = lpos - lang:Forward()*6 + lang:Up()*3 + lang:Right()*0.5
	end
	
	wOS.ALCS.Skills.CubeModels[2] = ClientsideModel( wOS.PersonalSaber.UseHilt )
	wOS.ALCS.Skills.CubeModels[2]:SetPos( rpos )
	wOS.ALCS.Skills.CubeModels[2]:SetAngles( rang )
	
	wOS.ALCS.Skills.CubeModels[3] = ClientsideModel( wOS.SecPersonalSaber.UseHilt )
	wOS.ALCS.Skills.CubeModels[3]:SetPos( lpos )
	wOS.ALCS.Skills.CubeModels[3]:SetAngles( lang )
	
	backbutt.Renders = function( pan )
		local ww, hh = pan.SizeX, pan.SizeY
		local x = 10
		local y = -50
		
		y = y + hh*0.23
		
		
		y = y + hh*0.06

		
		y = y + hh*0.06

		
		pan:BlockUseBind()
	end
	backbutt:SetUIScale( 20 )
	backbutt.Scaling = 0.05
	
	local spos = wOS.ALCS.Skills.CubeModels[1]:GetPos()
	backbutt.CamPos = spos - wOS.ALCS.Skills.CubeModels[1]:GetRight()*30 + wOS.ALCS.Skills.CubeModels[1]:GetForward()*20 
	backbutt.CamAng = wOS.ALCS.Skills.Camera[ wOS.ALCS.Skills.CamFocus ].angles + Angle( 0, 0, -90 )
	table.insert( wOS.ALCS.Skills.Menu.VGUI, backbutt )		
	
end