--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2020
	
	Contact: www.wiltostech.com
		----------------------------------------]]--








































































wOS = wOS or {}
wOS.ALCS = wOS.ALCS or {}
wOS.ALCS.Storage = wOS.ALCS.Storage or {}
wOS.ALCS.Skills = wOS.ALCS.Skills or {}
wOS.ALCS.Skills.Camera = wOS.ALCS.Skills.Camera or {}


wOS.ALCS.Storage.HoverInfo = { Slot = 0, Active = nil }
wOS.ALCS.Storage.LastPosI = 0
wOS.ALCS.Storage.LastPosS = 0

local w,h = ScrW(), ScrH()
local pi = math.pi

local upButton = Material( "wos/crafting/gui/up.png", "unlitgeneric" )
local downButton = Material( "wos/crafting/gui/down.png", "unlitgeneric" )
local leftButton = Material( "wos/crafting/gui/left.png", "unlitgeneric" )
local rightButton = Material( "wos/crafting/gui/right.png", "unlitgeneric" )
local bufferBar = Material( "wos/crafting/gui/buffer.png", "unlitgeneric" )
local boxTop = Material( "phoenix_storms/metalset_1-2", "unlitgeneric" )

local wireFrame = Material( "trails/plasma" )

local DuelBlock = Material( "wos/advswl/storage_holocron.png", "unlitgeneric" )

local centerpoint = wOS.ALCS.Config.Crafting.CraftingCamLocation
local color_unselected = Color( 0, 0, 0, 100 )
local grad = Material( "gui/gradient_up" )

wOS.ALCS.Skills.CubeModels = wOS.ALCS.Skills.CubeModels or {}

wOS.ALCS.Skills.MenuLibrary = wOS.ALCS.Skills.MenuLibrary or {}
wOS.ALCS.Skills.Camera[ "Storage-Overview" ] = { origin = centerpoint - Vector( 45, -35, -30 ), angles = Angle( 0, 90.501, 0.000 ) }
wOS.ALCS.Skills.MenuLibrary[ "Storage-Overview" ] = function()
	
	wOS.ALCS.Storage.LastPosI = 0
	wOS.ALCS.Storage.LastPosS = 0
	
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
			pan:Text( "ENTER STORAGE DECK", "wOS.TitleFont", x + ww*-2.7*( 1 - rat  ), y + bh/2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )

			pan.LastHover = CurTime() + 0.01
	    end							
		if _jp then
			wOS.ALCS.Skills:ChangeCamFocus( "Storage-ViewDeck" )
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
	
	local store_count = 0
	for i = 1, wOS.ALCS.Storage.Data.MaxSlots do
		local dat = wOS.ALCS.Storage.Data.Backpack[ i ]
		if not dat then continue end
		if dat.Name == "Empty" then continue end
		store_count = store_count + 1 
	end
	
	local frontpane = tduiw.Create()
	frontpane.SizeX = 8
	frontpane.SizeY = 35
	frontpane.ShouldAcceptInputs = true
	frontpane.Renders = function( pan )
		local ww, hh = pan.SizeX, pan.SizeY
		
		local x = 0 - ww/2
		local y = 10
		local bh = hh/7
		
		local col = color_white
		if store_count >= wOS.ALCS.Storage.Data.MaxSlots*0.9 then
			col = Color( 255, 0, 0 )
		end

		pan:Text( "OCCUPIED SLOTS", "wOS.CraftDescriptions", 0, -hh*1.1, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		pan:Text( store_count .. " / " .. wOS.ALCS.Storage.Data.MaxSlots, "wOS.TitleFont", 0, -hh*0.95, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

		
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
			pan:Text( "PROTECT YOUR BELONGINGS FROM HARM", "wOS.CraftDescriptions", 0, y + bh*2*( 1.5 + rat ), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
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
		image = wOS.ALCS.Runes[ "b" ]
		pan:Mat( image, x, y, ww, bh )	
		local _jp, _pr, _hov = pan:Button( "", "wOS.TitleFont", x, y, ww, bh, color_white, color_white )
		if _jp then
			net.Start( "wOS.ALCS.Storage.PurchaseStorage" ) 
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
			pan:Text( "PURCHASE STORAGE SPACE", "wOS.TitleFont", x + ww*1.1*( 1 - rat  ), y + bh/2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			pan:Text( "THIS WILL DEDUCT CREDITS", "wOS.DescriptionFont", x, y + bh*( 1 + rat ), Color( 255, 0, 0 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
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

wOS.ALCS.Skills.Camera[ "Storage-ViewDeck" ] = { origin = centerpoint - Vector( 45, 10, -30 ), angles = Angle( 0, 270, 0.000 ) }
wOS.ALCS.Skills.MenuLibrary[ "Storage-ViewDeck" ] = function()
	
	local forward = wOS.ALCS.Skills.Camera[ wOS.ALCS.Skills.CamFocus ].angles:Forward()
	local right = wOS.ALCS.Skills.Camera[ wOS.ALCS.Skills.CamFocus ].angles:Right()
	local up = wOS.ALCS.Skills.Camera[ wOS.ALCS.Skills.CamFocus ].angles:Up()
	
	local backpane = tduiw.Create()
	backpane.SizeX = 8
	backpane.SizeY = 35
	backpane.ShouldAcceptInputs = true
	backpane.Selected = -1
	backpane.Renders = function( pan )
		local ww, hh = pan.SizeX, pan.SizeY
		
		local x = 0 - ww/2
		local y = 10
		local bh = hh/7
		
		local lst = 0
		image = wOS.ALCS.Runes[ "x" ]
		pan:Mat( image, x, y, ww, bh )	
		local _jp, _pr, _hov = pan:Button( "", "wOS.TitleFont", x, y, ww, bh, color_white, color_white )
		if _jp then
			wOS.ALCS.Skills:ChangeCamFocus( "Storage-Overview" )
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
	backpane:SetUIScale( 10 )
	backpane.Scaling = 0.025
	
	backpane.CamPos = wOS.ALCS.Skills.Camera[ wOS.ALCS.Skills.CamFocus ].origin + forward*15 - up*3.3
	backpane.CamAng = wOS.ALCS.Skills.Camera[ wOS.ALCS.Skills.CamFocus ].angles + Angle( 0, 0, 0 )
	table.insert( wOS.ALCS.Skills.Menu.VGUI, backpane )
	
	local frontpane = tduiw.Create()
	frontpane.SizeX = 8
	frontpane.SizeY = 35
	frontpane.LeftCount = 1
	frontpane.RightCount = 5	
	frontpane.ShouldAcceptInputs = true
	frontpane.LastScrollSlot = 0
	frontpane.ScrollSlot = 0
	frontpane.Selected = 1
	frontpane.Offset = wOS.ALCS.Storage.LastPosS

	frontpane.Inventory = {}

	for slot = 1, wOS.ALCS.Storage.Data.MaxSlots do
		local name = wOS.ALCS.Storage.Data.Backpack[ slot ]
		local data = wOS.ALCS.Storage.Data.Backpack[ slot ]
		if not name then
			table.insert( frontpane.Inventory, { name = "Empty", amount = 0, slot = slot } )
			continue
		end
		local amount = 1
		if istable( data ) then
			name = data.Name
			amount = data.Amount or 1
		end
		if name != "Empty" then
			if not wOS.ItemList[ name ] then 
				table.insert( frontpane.Inventory, { name = "CORRUPTED ITEM", amount = 0, slot = slot } )
				continue 
			end
		end
		table.insert( frontpane.Inventory, { name = name, amount = amount, slot = slot } )
	end
	
	frontpane.Renders = function( pan )
		local ww, hh = pan.SizeX, pan.SizeY
		local bh = hh/7
		local pady = bh*0.05
		local x = 40 - ww*4
		local y = -26
		local lst = 0
		pan.Selected = 0
		if pan.Offset != wOS.ALCS.Storage.LastPosS then
			wOS.ALCS.Storage.LastPosS = pan.Offset
		end
		ww = ww/2
		if #pan.Inventory > 10 then
			pan:Mat( upButton, x - ww*1.1, y, ww, hh*0.35 )
			local _jp, _pr, _hov = pan:Button( "", "wOS.TitleFont", x - ww*1.1, y, ww, hh*0.35, color_white, color_white )
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
			pan:Mat( bufferBar, x - ww*1.1, y + hh*0.4, ww, hh*0.69 )	
			pan:Rect( x - ww*1.1, y + hh*0.4, ww, hh*0.69, Color( 0, 0, 0, 0 ), color_white )			
			pan:Mat( downButton, x - ww*1.1, y + hh*1.14, ww, hh*0.35 )
			local _jp, _pr, _hov = pan:Button( "", "wOS.TitleFont", x - ww*1.1, y + hh*1.14, ww, hh*0.35, color_white, color_white )			
			if _jp then
				if pan.Offset + 10 >= #pan.Inventory then return end
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
		ww = ww*2	
		
		pan:Text( "STORAGE", "wOS.CraftTitles", x + ww*1.4, y + hh*1.5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
	
		for i = 1, 10 do
			local slot = i + pan.Offset
			if slot > #pan.Inventory then break end
			local dat = pan.Inventory[slot]
			local col = color_white
			if wOS.ALCS.Storage.HoverInfo.Slot == slot and !wOS.ALCS.Storage.HoverInfo.Inventory then
				col = Color( 255, 0, 0 )
			end
			
			pan:Text( slot, "wOS.TitleFont", x + ww*0.4, y + bh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			pan:Line( x + ww*0.8, y, x + ww*0.8, y + bh )
			
			pan:Text( dat.name, "wOS.TitleFont", x + ww, y + bh/2, col, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			if dat.amount > 1 then
				pan:Text( "x" .. dat.amount, "wOS.TitleFont", x + ww*4.1, y + bh/2, col, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
			end
			local _jp, _pr, _hov = pan:Button( "", "wOS.TitleFont", x, y, ww*4.2, bh, col, Color( 175, 0, 0 ) )
			if _jp then
				if wOS.ALCS.Storage.HoverInfo.Slot > 0 then
					if !wOS.ALCS.Storage.HoverInfo.Inventory then
						if wOS.ALCS.Storage.HoverInfo.Slot != slot then
							net.Start( "wOS.ALCS.Storage.MoveStorageSlot" )
								net.WriteInt( wOS.ALCS.Storage.HoverInfo.Slot, 32 )
								net.WriteInt( slot, 32 )
							net.SendToServer()
						end
					else
						net.Start( "wOS.ALCS.Storage.TransferInventorySlot" )
							net.WriteInt( wOS.ALCS.Storage.HoverInfo.Slot, 32 )
							net.WriteInt( slot, 32 )
						net.SendToServer()
						wOS.SaberInventory[ wOS.ALCS.Storage.HoverInfo.Slot ] = wOS.ALCS.Storage.Data.Backpack[ slot ]
					end
					wOS.ALCS.Storage.HoverInfo.Inventory = nil
					wOS.ALCS.Storage.HoverInfo.Slot = 0
				else
					wOS.ALCS.Storage.HoverInfo.Slot = slot
					wOS.ALCS.Storage.HoverInfo.Inventory = nil
				end
			elseif _hov then
				pan.Selected = slot
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
		
		if pan.SlideTimes and pan.LastHover < CurTime() then
			pan.SlideTimes	= nil
			pan.LastButt = nil
		end
	
	end
	frontpane:SetUIScale( 10 )
	frontpane.Scaling = 0.018
	
	frontpane.CamPos = wOS.ALCS.Skills.Camera[ wOS.ALCS.Skills.CamFocus ].origin + forward*15 + up*1.5 + right*5.3
	frontpane.CamAng = wOS.ALCS.Skills.Camera[ wOS.ALCS.Skills.CamFocus ].angles + Angle( 0, 0, 0 )
	table.insert( wOS.ALCS.Skills.Menu.VGUI, frontpane )
	
	local invpane = tduiw.Create()
	invpane.SizeX = 8
	invpane.SizeY = 35
	invpane.LeftCount = 1
	invpane.RightCount = 5	
	invpane.ShouldAcceptInputs = true
	invpane.LastScrollSlot = 0
	invpane.ScrollSlot = 0
	invpane.Selected = 1
	invpane.Offset = wOS.ALCS.Storage.LastPosI
	
	invpane.Inventory = {}
	
	for slot = 1, wOS.ALCS.Config.Crafting.MaxInventorySlots do
		local name = wOS.SaberInventory[ slot ]
		local data = wOS.SaberInventory[ slot ]
		if not name then
			table.insert( invpane.Inventory, { name = "Empty", amount = 1, slot = slot } )
			continue
		end
		local amount = 1
		if istable( data ) then
			name = data.Name
			amount = data.Amount or 1
		end
		if name != "Empty" then
			if not wOS.ItemList[ name ] then 
				table.insert( invpane.Inventory, { name = "Empty", amount = 1, slot = slot } )
				continue 
			end
		end
		table.insert( invpane.Inventory, { name = name, amount = amount, slot = slot } )
	end

	invpane.Renders = function( pan )
		local ww, hh = pan.SizeX, pan.SizeY
		local bh = hh/7
		local pady = bh*0.05
		local x = 40 - ww*4
		local y = -26
		local lst = 0
		pan.Selected = 0
		if pan.Offset != wOS.ALCS.Storage.LastPosI then
			wOS.ALCS.Storage.LastPosI = pan.Offset
		end
		ww = ww/2
		if #pan.Inventory > 10 then
			pan:Mat( upButton, x - ww*1.1, y, ww, hh*0.35 )
			local _jp, _pr, _hov = pan:Button( "", "wOS.TitleFont", x - ww*1.1, y, ww, hh*0.35, color_white, color_white )
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
			pan:Mat( bufferBar, x - ww*1.1, y + hh*0.4, ww, hh*0.69 )	
			pan:Rect( x - ww*1.1, y + hh*0.4, ww, hh*0.69, Color( 0, 0, 0, 0 ), color_white )			
			pan:Mat( downButton, x - ww*1.1, y + hh*1.14, ww, hh*0.35 )
			local _jp, _pr, _hov = pan:Button( "", "wOS.TitleFont", x - ww*1.1, y + hh*1.14, ww, hh*0.35, color_white, color_white )			
			if _jp then
				if pan.Offset + 10 >= #pan.Inventory then return end
				pan.Offset = pan.Offset + 1
				surface.PlaySound( "buttons/lightswitch2.wav" )
			elseif _hov then
				pan.Selected = slot
				local speed = 0.1
				if pan.LastButt != lst then
					surface.PlaySound( "wos/alcs/ui_rollover.wav" )
					pan.LastButt = lst
				end
				pan.LastHover = CurTime() + 0.01
			end							
		end
		ww = ww*2	
		
		pan:Text( "INVENTORY", "wOS.CraftTitles", x + ww*1.85, y + hh*1.5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
	
		for i = 1, 10 do
			local slot = i + pan.Offset
			if slot > #pan.Inventory then break end
			local dat = pan.Inventory[slot]
			local col = color_white

			if wOS.ALCS.Storage.HoverInfo.Slot == slot and wOS.ALCS.Storage.HoverInfo.Inventory then
				col = Color( 255, 0, 0 )
			end
			
			pan:Text( slot, "wOS.TitleFont", x + ww*0.4, y + bh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			pan:Line( x + ww*0.8, y, x + ww*0.8, y + bh )
			
			pan:Text( dat.name, "wOS.TitleFont", x + ww, y + bh/2, col, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			if dat.amount > 1 then
				pan:Text( "x" .. dat.amount, "wOS.TitleFont", x + ww*4.1, y + bh/2, col, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
			end
			local _jp, _pr, _hov = pan:Button( "", "wOS.TitleFont", x, y, ww*4.2, bh, col, Color( 175, 0, 0 ) )
			if _jp then
				if wOS.ALCS.Storage.HoverInfo.Slot > 0 then
					if wOS.ALCS.Storage.HoverInfo.Inventory then
						if wOS.ALCS.Storage.HoverInfo.Slot != slot then
							net.Start( "wOS.ALCS.Storage.MoveInventorySlot" )
								net.WriteInt( wOS.ALCS.Storage.HoverInfo.Slot, 32 )
								net.WriteInt( slot, 32 )
							net.SendToServer()
							local dat = wOS.SaberInventory[ slot ]
							wOS.SaberInventory[ slot ] = wOS.SaberInventory[ wOS.ALCS.Storage.HoverInfo.Slot ]
							wOS.SaberInventory[ wOS.ALCS.Storage.HoverInfo.Slot ] = dat 
						end
					else
						net.Start( "wOS.ALCS.Storage.TransferInventorySlot" )
							net.WriteInt( slot, 32 )
							net.WriteInt( wOS.ALCS.Storage.HoverInfo.Slot, 32 )
						net.SendToServer()
						wOS.SaberInventory[ slot ] = wOS.ALCS.Storage.Data.Backpack[ wOS.ALCS.Storage.HoverInfo.Slot ]
					end
					wOS.ALCS.Storage.HoverInfo.Inventory = nil
					wOS.ALCS.Storage.HoverInfo.Slot = 0
				else
					wOS.ALCS.Storage.HoverInfo.Slot = slot
					wOS.ALCS.Storage.HoverInfo.Inventory = true
				end
			elseif _hov then
				pan.Selected = slot
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
		
		if pan.SlideTimes and pan.LastHover < CurTime() then
			pan.SlideTimes	= nil
			pan.LastButt = nil
		end
	
	end
	invpane:SetUIScale( 10 )
	invpane.Scaling = 0.018
	
	invpane.CamPos = wOS.ALCS.Skills.Camera[ wOS.ALCS.Skills.CamFocus ].origin + forward*15 + up*1.5 - right*13.5
	invpane.CamAng = wOS.ALCS.Skills.Camera[ wOS.ALCS.Skills.CamFocus ].angles + Angle( 0, 0, 0 )
	table.insert( wOS.ALCS.Skills.Menu.VGUI, invpane )
	
	wOS.ALCS.Skills.CubeModels[1] = ClientsideModel( "models/props_lab/huladoll.mdl" )
	wOS.ALCS.Skills.CubeModels[1]:SetPos( frontpane.CamPos + forward*110 - up*5 + right*20 )
	
	wOS.ALCS.Skills.CubeModels[2] = ClientsideModel( "models/props_lab/huladoll.mdl" )
	wOS.ALCS.Skills.CubeModels[2]:SetPos( frontpane.CamPos + forward*110 - up*5 - right*30 )
	
	frontpane.PostRenders = function( pan )
		local model = "models/props_lab/huladoll.mdl"
		local sel = pan.Selected
		if !wOS.ALCS.Storage.HoverInfo.Inventory and wOS.ALCS.Storage.HoverInfo.Slot > 0 then
			sel = wOS.ALCS.Storage.HoverInfo.Slot
		end
		if pan.Inventory[ sel ] then
			local name = pan.Inventory[ sel ].name
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
		if IsValid( display ) then 
			if display:GetModel() != model then
				display:SetModel( model )
			end
			local ang = display:GetAngles()
			ang:RotateAroundAxis( ang:Up(), FrameTime()*-100 )
			display:SetAngles( ang )
		end
	end
	
	invpane.PostRenders = function( pan )
		local model = "models/props_lab/huladoll.mdl"
		local sel = pan.Selected
		if wOS.ALCS.Storage.HoverInfo.Inventory and wOS.ALCS.Storage.HoverInfo.Slot > 0 then
			sel = wOS.ALCS.Storage.HoverInfo.Slot
		end
		if pan.Inventory[ sel ] then
			local name = pan.Inventory[ sel ].name
			if name then
				local item = wOS.ItemList[ name ]
				if item then
					if item.Model then
						model = item.Model
					end
				end
			end
		end
		
		local display = wOS.ALCS.Skills.CubeModels[2]
		if IsValid( display ) then 
			if display:GetModel() != model then
				display:SetModel( model )
			end
			local ang = display:GetAngles()
			ang:RotateAroundAxis( ang:Up(), FrameTime()*-100 )
			display:SetAngles( ang )
		end
		
	end
	
end

