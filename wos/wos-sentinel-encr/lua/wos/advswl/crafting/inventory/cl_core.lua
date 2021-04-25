--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2020
	
	Contact: www.wiltostech.com
		----------------------------------------]]--








































































wOS = wOS or {}

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

local w,h = ScrW(), ScrH()
local page = 1
local items_per_page = 10
local mw, mh = w*0.4, h*0.4
local inventory_buttons

function wOS:ViewInventory()
	
	if self.InventoryPanel then
		if self.InventoryPanel:IsVisible() then
			self.InventoryPanel:Remove()
			self.MaterialPanel:Remove()
			gui.EnableScreenClicker( false )
			self.InventoryPanel = nil
			self.MaterialPanel = nil
		end
		return
	end	
	
	if self.CraftingMenu then return end
	if wOS.ALCS.Skills.Menu then return end
	
	gui.EnableScreenClicker( true )
	local maxpages = math.Round( wOS.ALCS.Config.Crafting.MaxInventorySlots/items_per_page )
	self.InventoryPanel = vgui.Create( "DPanel" )
	self.InventoryPanel:SetSize( mw, mh )
	self.InventoryPanel:SetPos( ( w - mw )*0.5, ( h - mh )*0.5 )
	self.InventoryPanel.Paint = function( pan, ww, hh )
		if not vgui.CursorVisible() then gui.EnableScreenClicker( true ) end
		blurpanel( pan )
		draw.RoundedBox( 3, 0, 0, ww, hh, Color( 25, 25, 25, 245 ) )
		surface.SetDrawColor( color_white )
		surface.DrawOutlinedRect( 0, 0, ww, hh )
		surface.DrawLine( ww*0.25, hh*0.1, ww*0.75, hh*0.1 )
		draw.SimpleText( "Integrated Storage Device", "wOS.TitleFont", ww/2, hh*0.05, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		draw.SimpleText( "Page " .. page .. " / " .. maxpages, "wOS.TitleFont", ww/2, hh*0.835, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )		
	end

	self.InventoryPanel.Think = function( pan )
		local button = vgui.GetHoveredPanel() 
		if not button then self.InventoryInfoPanel:SetVisible( false ) return end
		if button.DataItem then
			self.InventoryInfoPanel:SetVisible( true )
			self.InventoryInfoPanel.DataItem = button.DataItem		
		else
			self.InventoryInfoPanel:SetVisible( false )
		end
	end
	
	local sw, sh = self.InventoryPanel:GetSize()
	
	local button = vgui.Create( "DButton", self.InventoryPanel )
	button:SetSize( sw*0.025, sw*0.025 )
	button:SetPos( sw*0.965, sw*0.01 )
	button:SetText( "" )
	button.Paint = function( pan, ww, hh )
		surface.SetDrawColor( Color( 255, 0, 0, 255 ) )
		surface.DrawLine( 0, 0, ww, hh )
		surface.DrawLine( 0, hh, ww, 0 )
	end
	button.DoClick = function()
		self.InventoryPanel:Remove()
		self.MaterialPanel:Remove()
		gui.EnableScreenClicker( false )
		self.InventoryPanel = nil
		self.MaterialPanel = nil
	end	
	
	wOS:BuildMaterialPanel()
	
	self.InventoryInfoPanel = vgui.Create( "DPanel" )
	self.InventoryInfoPanel:SetSize( mw*0.5, mh*0.15 )
	self.InventoryInfoPanel:SetPos( w, h )
	self.InventoryInfoPanel.DataItem = false
	self.InventoryInfoPanel.Paint = function( pan, ww, hh )	
		draw.RoundedBox( 3, 0, 0, ww, hh, Color( 25, 25, 25, 255 ) )
		surface.SetDrawColor( color_white )
		surface.DrawOutlinedRect( 0, 0, ww, hh )
		if self.InventoryInfoPanel.DataItem then
			draw.SimpleText( pan.DataItem.Name, "wOS.TitleFont", ww*0.04, hh*0.25, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			draw.SimpleText( pan.DataItem.Description, "wOS.DescriptionFont", ww*0.04, hh*0.62, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			if pan.DataItem.Amount and pan.DataItem.Amount > 1 then
				draw.SimpleText( "x" .. pan.DataItem.Amount, "wOS.TitleFont", ww*0.96, hh*0.5, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
			end
		end
	end
	
	self.InventoryInfoPanel.Think = function( pan )
		pan:SetPos( gui.MouseX() + 15, gui.MouseY() + 15 )
		if not self.InventoryPanel then
			pan:Remove()
		end
	end
	
	self.InventoryInfoPanel:SetVisible( false )
	
	local button1 = vgui.Create( "DButton", self.InventoryPanel )
	button1:SetSize( sw, sh*0.1 )
	button1:SetPos( 0, sh*0.9 )
	button1:SetText( "" )
	button1.Paint = function( pan, ww, hh )
		if pan:IsHovered() then
			draw.SimpleText( "Powered by wiltOS Technologies", "wOS.TitleFont", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )		
		else
			draw.SimpleText( "Powered by wiltOS Technologies", "wOS.TitleFont", ww/2, hh/2, Color( 75, 75, 75, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
	end
	button1.DoClick = function()
		gui.OpenURL( "www.wiltostech.com" )
	end	
	
	local button_left = vgui.Create( "DImageButton", self.InventoryPanel )
	button_left:SetSize( sw*0.15, sh*0.1 )
	button_left:SetPos( sw*0.15, sh*0.785 )
	button_left:SetImage( "wos/crafting/gui/left.png" )
	button_left.DoClick = function( pan )
		if page <= 1 then return end
		surface.PlaySound( "buttons/lightswitch2.wav" )
		page = math.max( page - 1, 1 )
		wOS:BuildItemsOnPage()
	end
	
	local button_right = vgui.Create( "DImageButton", self.InventoryPanel )
	button_right:SetSize( sw*0.15, sh*0.1 )
	button_right:SetPos( sw*0.7, sh*0.785 )
	button_right:SetImage( "wos/crafting/gui/right.png" )
	button_right.DoClick = function( pan )
		if page >= maxpages then return end
		surface.PlaySound( "buttons/lightswitch2.wav" )
		page = math.min( page + 1, maxpages )
		wOS:BuildItemsOnPage()
	end
	
	wOS:BuildItemsOnPage()
end

function wOS:BuildMaterialPanel()
	self.MaterialPanel = vgui.Create( "DPanel" )
	self.MaterialPanel:SetSize( mw*0.33, mh )
	self.MaterialPanel:SetPos( ( w + mw )*0.5 + mw*0.005, ( h - mh )*0.5 )
	self.MaterialPanel.Paint = function( pan, ww, hh )
		if not vgui.CursorVisible() then gui.EnableScreenClicker( true ) end
		blurpanel( pan )
		draw.RoundedBox( 3, 0, 0, ww, hh, Color( 25, 25, 25, 245 ) )
		surface.SetDrawColor( color_white )
		surface.DrawOutlinedRect( 0, 0, ww, hh )
		surface.DrawLine( ww*0.25, hh*0.1, ww*0.75, hh*0.1 )
		draw.SimpleText( "Raw Materials", "wOS.TitleFont", ww/2, hh*0.05, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )	
	end
	
	local pw, ph = self.MaterialPanel:GetSize()
	local padx, pady = pw*0.04, ph*0.05
	
	local MaterialBox = vgui.Create( "DComboBox", self.MaterialPanel )
	MaterialBox:SetPos( padx, ph*0.15 )
	MaterialBox:SetSize( pw - 2*padx, ph*0.07 )
	MaterialBox:SetValue( "Select Raw Material" )
	for material, data in pairs( wOS.SortedItemList[ WOSTYPE.RAWMATERIAL ] ) do
		MaterialBox:AddChoice( material )
	end
	local infobox
	MaterialBox.OnSelect = function( panel, index, value )
		if infobox then infobox:Remove() end
		infobox = vgui.Create( "DPanel", self.MaterialPanel )
		infobox:SetSize( pw - 2*padx, ph*0.78 - 2*pady )
		infobox:SetPos( padx, ph*0.22 + pady )
		
		local ww, hh = infobox:GetSize()
		local posx, posy = infobox:GetPos()
		local possx, possy = wOS.MaterialPanel:GetPos()
		posx = possx + posx
		posy = possy + posy
		local data = wOS.ItemList[ value ]
		infobox.Paint = function( pan, ww, hh )
			draw.SimpleText( "Amount: " .. wOS.RawMaterials[ value ], "wOS.TitleFont", 0, hh*0.7, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			draw.SimpleText( "Rarity: " .. ( 100 - data.Rarity ) .. "%", "wOS.TitleFont", 0, hh*0.8, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		end
		if data.Model then
			local base_slot = vgui.Create( "DPanel", infobox )
			base_slot:SetSize( ww*0.7, ww*0.7 )
			base_slot:SetPos( ww*0.15, 0 )
			base_slot:SetText( "" )
			base_slot.Paint = function( pan, ww, hh )
				surface.SetDrawColor( Color( 255, 255, 255, 25 ) )
				local SlotFrame = {
					{ x = 0, y = hh*0.1 },
					{ x = ww*0.1, y = 0 },
					{ x = ww, y = 0 },		
					{ x = ww, y = hh*0.9 },
					{ x = ww*0.9, y = hh },	
					{ x = 0, y = hh},						
				}
				draw.NoTexture()
				surface.DrawPoly( SlotFrame )
			end	
			local Iconent = ClientsideModel("borealis/barrel.mdl")
			Iconent:SetAngles(Angle(0,0,0))
			Iconent:SetPos(Vector(0,0,0))
			Iconent:Spawn()
			Iconent:Activate()	
			Iconent:SetModel( data.Model )
			local center = Iconent:OBBCenter()
			local dist = Iconent:BoundingRadius()*1.6			
			local modelpanel = vgui.Create( "DModelPanel", base_slot )
			modelpanel:SetSize( ww*0.7, ww*0.7 )		
			modelpanel:SetModel( data.Model )
			modelpanel:SetLookAt( center )
			modelpanel:SetCamPos( center + Vector( dist, dist, 0 ) )				
			Iconent:Remove()
		end
		
		local DropMat = vgui.Create( "DButton", infobox )
		DropMat:SetPos( ww*0.4 + 2*padx, hh*0.9 )
		DropMat:SetSize( ww*0.6 - 3*padx, hh*0.1 )
		DropMat:SetText( "" )
		DropMat.Paint = function( pan, ww, hh )
			draw.RoundedBox( 5, 0, 0, ww, hh, ( pan:IsDown() and Color( 0, 155, 255, 155 ) ) or Color( 155, 155, 155, 155 ) )
			draw.SimpleText( "DROP", "wOS.DescriptionFont", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
		local DropMatEntry = vgui.Create( "DTextEntry", infobox )
		DropMatEntry:MakePopup()
		DropMatEntry:SetPos( posx + padx, posy + hh*0.9 )
		DropMatEntry:SetSize( ww*0.4, hh*0.1 )
		DropMatEntry:SetText( 0 )
		DropMatEntry:SetNumeric( true )
		DropMat.DoClick = function()
			net.Start( "wOS.Crafting.DropMaterial" )
				net.WriteString( data.Name )
				net.WriteInt( tonumber( DropMatEntry:GetValue() ), 32 )
			net.SendToServer()
		end
		
	end
	

end

function wOS:BuildItemsOnPage()
	
	local sw, sh = self.InventoryPanel:GetSize()
		
	if not IsValid( inventory_buttons ) then
		inventory_buttons = vgui.Create( "DPanel", self.InventoryPanel )
		inventory_buttons:SetPos( sw*0.05, sh*0.12 )
		inventory_buttons:SetSize( sw*0.9, sh*0.65 )
		inventory_buttons.Paint = function( pan, ww, hh )
		end
	else
		inventory_buttons:Clear()
	end
	
	local min = items_per_page*(page - 1 )
	local max = math.min( items_per_page*page, wOS.ALCS.Config.Crafting.MaxInventorySlots )
	local iw, ih = inventory_buttons:GetSize()	
	local padx, pady = iw*0.01, ih*0.05
	local bw, bh = ( iw*0.2 - padx ), ( ih*0.5 - 1.5*pady )	
	local offsetx = padx
	local offsety = pady
	local items_per_row = 5
	local rows = items_per_page/items_per_row
	local rmin = min + 1
	local rmax = min + items_per_row
	local function dragdropfunc( pan, panels, dropped, _, _ )
		if not dropped then return end
		local oldpanel = panels[1]
		local oldpanx, oldpany = oldpanel.PosX, oldpanel.PosY
		local newpanx, newpany = pan.PosX, pan.PosY
		local oldslot = pan.Slot
		local newslot = oldpanel.Slot
		local data = table.Copy( oldpanel.DataItem )
		wOS.SaberInventory[ oldslot ] = wOS.SaberInventory[ newslot ]
		wOS.SaberInventory[ newslot ] = { Name = "Empty", Amount = 0 }
		net.Start( "wOS.Crafting.ChangeSlot" )
			net.WriteInt( oldslot, 32 )
			net.WriteInt( newslot, 32 )
		net.SendToServer()
		
		pan:Remove()
		oldpanel:GetParent():Remove()
		
		local empty_slot = vgui.Create( "DPanel", inventory_buttons )
		empty_slot:SetSize( bw, bh )
		empty_slot:SetPos( oldpanx, oldpany )
		empty_slot.PosX = oldpanx
		empty_slot.PosY = oldpany
		empty_slot.Slot = newslot
		empty_slot.Paint = function( pan, ww, hh )
			surface.SetDrawColor( Color( 255, 255, 255, 5 ) )
			local SlotFrame = {
				{ x = 0, y = hh*0.1 },
				{ x = ww*0.1, y = 0 },
				{ x = ww, y = 0 },		
				{ x = ww, y = hh*0.9 },
				{ x = ww*0.9, y = hh },	
				{ x = 0, y = hh},						
			}
			draw.NoTexture()
			surface.DrawPoly( SlotFrame )
		end
		empty_slot:Receiver( "InventorySlot", dragdropfunc, {} )		
		
		local base_slot = vgui.Create( "DPanel", inventory_buttons )
		base_slot:SetSize( bw, bh )
		base_slot:SetPos( newpanx, newpany )
		base_slot:SetText( "" )
		base_slot.Paint = function( pan, ww, hh )
			surface.SetDrawColor( Color( 255, 255, 255, 25 ) )
			local SlotFrame = {
				{ x = 0, y = hh*0.1 },
				{ x = ww*0.1, y = 0 },
				{ x = ww, y = 0 },		
				{ x = ww, y = hh*0.9 },
				{ x = ww*0.9, y = hh },	
				{ x = 0, y = hh},						
			}
			draw.NoTexture()
			surface.DrawPoly( SlotFrame )
		end	
		
		if data.Model then
			local Iconent = ClientsideModel("borealis/barrel.mdl")
			Iconent:SetAngles(Angle(0,0,0))
			Iconent:SetPos(Vector(0,0,0))
			Iconent:Spawn()
			Iconent:Activate()	
			Iconent:SetModel( data.Model )
			local center = Iconent:OBBCenter()
			local dist = Iconent:BoundingRadius()*1.6			
			local modelpanel = vgui.Create( "DModelPanel", base_slot )
			modelpanel:SetSize( bw, bh )		
			modelpanel:SetModel( data.Model )
			modelpanel:SetLookAt( center )
			modelpanel:SetCamPos( center + Vector( dist, dist, 0 ) )				
			Iconent:Remove()
		end
		
		local full_slot = vgui.Create( "DButton", base_slot )
		full_slot:SetSize( bw, bh )
		full_slot.PosX = newpanx
		full_slot.PosY = newpany
		full_slot.DataItem = table.Copy( data )
		full_slot.Slot = oldslot
		full_slot:SetText( "" )
		full_slot.Paint = function( pan, ww, hh )
			surface.SetDrawColor( Color( 0, 0, 0, 255 ) )
			local SlotFrame = {
				{ x = 0, y = hh*0.1 },
				{ x = ww*0.1, y = 0 },
				{ x = ww, y = 0 },		
				{ x = ww, y = hh*0.9 },
				{ x = ww*0.9, y = hh },	
				{ x = 0, y = hh },
				{ x = 0, y = hh*0.1 },						
			}				
			for i=1, 6 do
				local startpos = SlotFrame[ i ]
				local endpos = SlotFrame[ i + 1 ]
				surface.DrawLine( startpos.x, startpos.y, endpos.x, endpos.y )
			end
		end	
		full_slot:Droppable( "InventorySlot" )	
	end
	
	for row = 1, rows do
		for slot = rmin, rmax do
			local data = self.SaberInventory[ slot ]
			local item = self.SaberInventory[ slot ]
			local amount = 1
			if istable( data ) then
				item = data.Name
				amount = data.Amount or amount
			end
			if item == "Empty" then
				local empty_slot = vgui.Create( "DPanel", inventory_buttons )
				empty_slot:SetSize( bw, bh )
				empty_slot:SetPos( offsetx, offsety )
				empty_slot.PosX = offsetx
				empty_slot.PosY = offsety
				empty_slot.Slot = slot
				empty_slot.Paint = function( pan, ww, hh )
					surface.SetDrawColor( Color( 255, 255, 255, 5 ) )
					local SlotFrame = {
						{ x = 0, y = hh*0.1 },
						{ x = ww*0.1, y = 0 },
						{ x = ww, y = 0 },		
						{ x = ww, y = hh*0.9 },
						{ x = ww*0.9, y = hh },	
						{ x = 0, y = hh},						
					}
					draw.NoTexture()
					surface.DrawPoly( SlotFrame )
				end
				empty_slot:Receiver( "InventorySlot", dragdropfunc, {} )
			else
				local itemdata = self.ItemList[ item ]
				if not itemdata then itemdata = { Name = "ERROR", Description = "THIS ITEM IS CORRUPTED", Model = "" } end
				
				local base_slot = vgui.Create( "DPanel", inventory_buttons )
				base_slot:SetSize( bw, bh )
				base_slot:SetPos( offsetx, offsety )
				base_slot:SetText( "" )
				base_slot.Paint = function( pan, ww, hh )
					surface.SetDrawColor( Color( 255, 255, 255, 25 ) )
					local SlotFrame = {
						{ x = 0, y = hh*0.1 },
						{ x = ww*0.1, y = 0 },
						{ x = ww, y = 0 },		
						{ x = ww, y = hh*0.9 },
						{ x = ww*0.9, y = hh },	
						{ x = 0, y = hh},						
					}
					draw.NoTexture()
					surface.DrawPoly( SlotFrame )
				end	
				
				if itemdata.Model then
					local Iconent = ClientsideModel("borealis/barrel.mdl")
					Iconent:SetAngles(Angle(0,0,0))
					Iconent:SetPos(Vector(0,0,0))
					Iconent:Spawn()
					Iconent:Activate()	
					Iconent:SetModel( itemdata.Model )
					local center = Iconent:OBBCenter()
					local dist = Iconent:BoundingRadius()*1.6			
					local modelpanel = vgui.Create( "DModelPanel", base_slot )
					modelpanel:SetSize( bw, bh )		
					modelpanel:SetModel( itemdata.Model )
					modelpanel:SetLookAt( center )
					modelpanel:SetCamPos( center + Vector( dist, dist, 0 ) )				
					Iconent:Remove()
				end
				
				local full_slot = vgui.Create( "DButton", base_slot )
				full_slot:SetSize( bw, bh )
				full_slot.PosX = offsetx
				full_slot.PosY = offsety
				full_slot.DataItem = itemdata
				full_slot.Slot = slot
				full_slot:SetText( "" )
				full_slot.Paint = function( pan, ww, hh )
					surface.SetDrawColor( Color( 0, 0, 0, 255 ) )
					local SlotFrame = {
						{ x = 0, y = hh*0.1 },
						{ x = ww*0.1, y = 0 },
						{ x = ww, y = 0 },
						{ x = ww, y = hh*0.9 },
						{ x = ww*0.9, y = hh },
						{ x = 0, y = hh },
						{ x = 0, y = hh*0.1 },				
					}
					for i=1, 6 do
						local startpos = SlotFrame[ i ]
						local endpos = SlotFrame[ i + 1 ]
						surface.DrawLine( startpos.x, startpos.y, endpos.x, endpos.y )
					end
					if amount > 1 then
						draw.SimpleText( "x" .. amount, "wOS.TitleFont", ww*0.98, hh*0.02, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP )
					end
				end
				full_slot.DoClick = function( pan )
					if pan.ItemIconOptions then pan.ItemIconOptions:Remove() pan.ItemIconOptions = nil end
					pan.ItemIconOptions = DermaMenu( base_slot )
					pan.ItemIconOptions:SetPos( gui.MouseX(), gui.MouseY() )
					pan.ItemIconOptions.Think = function( self )
						if not pan then self:Remove() end
					end
					pan.ItemIconOptions:AddOption( "Drop", function( self ) 
						net.Start( "wOS.Crafting.DropItem" )
							net.WriteInt( slot, 32 )
						net.SendToServer()
						self:Remove()
					end )				
				end
				full_slot:Droppable( "InventorySlot" )
			end
			offsetx = offsetx + bw + padx
		end
		rmin = rmin + items_per_row
		rmax = rmax + items_per_row
		offsetx = padx
		offsety = offsety + bh + pady
	end
end