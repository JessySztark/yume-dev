--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2020
	
	Contact: www.wiltostech.com
		----------------------------------------]]--








































































wOS = wOS or {}
wOS.ALCS = wOS.ALCS or {}
wOS.ALCS.Prestige = wOS.ALCS.Prestige or {}
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

local DuelBlock = Material( "wos/advswl/trade_holocron.png", "unlitgeneric" )

local centerpoint = wOS.ALCS.Config.Crafting.CraftingCamLocation
local color_unselected = Color( 0, 0, 0, 100 )
local grad = Material( "gui/gradient_up" )

wOS.ALCS.Skills.CubeModels = wOS.ALCS.Skills.CubeModels or {}

wOS.ALCS.Skills.MenuLibrary = wOS.ALCS.Skills.MenuLibrary or {}
wOS.ALCS.Skills.Camera[ "Trade-Overview" ] = { origin = centerpoint - Vector( 45, -35, -30 ), angles = Angle( 0, 90.501, 0.000 ) }
wOS.ALCS.Skills.MenuLibrary[ "Trade-Overview" ] = function()
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
		
		//pan:Line( x/2, y + hh*0.15, x, y + bh/2 )
		//y = y + hh*0.4
		//pan:Line( x/2, y - hh*0.05, x, y + bh/2 )
		pan:Line( 0, -hh/2 + hh*0.05, x + ww, y - hh*0.2 + bh/2 )
		pan:Line( 0, -hh/2 + hh*0.1, x + ww, y + hh*0.2 + bh/2 )
		
		local lst = 0
		image = wOS.ALCS.Runes[ "a" ]
		pan:Mat( image, x, y + hh*0.2, ww, bh )	
		local _jp, _pr, _hov = pan:Button( "", "wOS.TitleFont", x, y + hh*0.2, ww, bh, color_white, color_white )
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
			pan:Rect( x, y + hh*0.2, ww*-3*( 1 - rat  ), bh, Color( 10, 10, 10, 255 ), color_white )
			pan:Text( "VIEW AUCTIONS", "wOS.TitleFont", x + ww*-2.7*( 1 - rat  ), y + hh*0.2 + bh/2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )

			pan.LastHover = CurTime() + 0.01
	    end							
		if _jp then
			wOS.ALCS.GTN:CreateGTNPanel( wOS.ALCS.GTN.Modes.AUCTIONS )
			wOS.ALCS.Skills.Menu:SetVisible( false )	
		end	
		lst = lst + 1
		
		local lst = 0
		image = wOS.ALCS.Runes[ "t" ]
		pan:Mat( image, x, y - hh*0.2, ww, bh )	
		local _jp, _pr, _hov = pan:Button( "", "wOS.TitleFont", x, y - hh*0.2, ww, bh, color_white, color_white )
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
			pan:Rect( x, y - hh*0.2, ww*-3*( 1 - rat  ), bh, Color( 10, 10, 10, 255 ), color_white )
			pan:Text( "VIEW TRADES", "wOS.TitleFont", x + ww*-2.7*( 1 - rat  ), y - hh*0.2 + bh/2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )

			pan.LastHover = CurTime() + 0.01
	    end							
		if _jp then
			wOS.ALCS.GTN:CreateGTNPanel( wOS.ALCS.GTN.Modes.TRADES )
			wOS.ALCS.Skills.Menu:SetVisible( false )	
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
		
		local number = math.random( 0, 9 ) .. "" ..  math.random( 0, 9 )

		pan:Text( "GALACTIC TRADE NETWORK", "wOS.CraftDescriptions", 0, -hh*1.1, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		pan:Text( "OPEN " .. number .. " HOURS A DAY", "wOS.DescriptionFont", 0, -hh*0.95, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )

		
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
			pan:Text( "SEIZE OPPORTUNITY ON THE MARKET", "wOS.CraftDescriptions", 0, y + bh*2*( 1.5 + rat ), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
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
		image = wOS.ALCS.Runes[ "v" ]
		pan:Mat( image, x, y, ww, bh )	
		local _jp, _pr, _hov = pan:Button( "", "wOS.TitleFont", x, y, ww, bh, color_white, color_white )
		if _jp then
			wOS.ALCS.GTN:CreateGTNPanel( wOS.ALCS.GTN.Modes.MYLISTINGS )
			wOS.ALCS.Skills.Menu:SetVisible( false )	
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
			pan:Text( "MANAGE LISTINGS", "wOS.TitleFont", x + ww*1.55*( 1 - rat  ), y + bh/2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			pan.LastHover = CurTime() + 0.01
	    end							
		lst = lst + 1
		
		y = y + hh*0.4
		pan:Line( x/2, y - hh*0.05, x, y + bh/2 )
		image = wOS.ALCS.Runes[ "r" ]
		pan:Mat( image, x, y, ww, bh )	
		local _jp, _pr, _hov = pan:Button( "", "wOS.TitleFont", x, y, ww, bh, color_white, color_white )
		if _jp then
			net.Start( "wOS.ALCS.GTN.RequestStock" ) 
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
			pan:Text( "CHECK REWARD STOCK", "wOS.TitleFont", x + ww*1.33*( 1 - rat  ), y + bh/2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			pan:Text( "MAKE SURE YOU HAVE ENOUGH INVENTORY SPACE!", "wOS.DescriptionFont", x, y + bh*( 1 + rat ), Color( 255, 0, 0 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
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