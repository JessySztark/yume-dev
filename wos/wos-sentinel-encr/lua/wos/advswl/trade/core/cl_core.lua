--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2020
	
	Contact: www.wiltostech.com
		----------------------------------------]]--

wOS = wOS or {}
wOS.ALCS = wOS.ALCS or {}
wOS.ALCS.GTN = wOS.ALCS.GTN or {}
wOS.ALCS.GTN.Modes = {}
wOS.ALCS.GTN.Modes.AUCTIONS = 0
wOS.ALCS.GTN.Modes.TRADES = 1
wOS.ALCS.GTN.Modes.MYLISTINGS = 3

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

function wOS.ALCS.GTN:CreateGTNPanel( mode )
	if self.Menu then
		self.Menu:Remove()
		self.Menu = nil
	end
	
	gui.EnableScreenClicker( true )

	self.Menu = vgui.Create( "DFrame" )
	self.Menu:SetDraggable( true )
	self.Menu:ShowCloseButton( false )
	self.Menu:SetTitle( "" )
	local sx, sy = wOS.ALCS.Skills.Menu:GetSize()
	self.Menu:SetSize( sx, sy )
	local px, py = wOS.ALCS.Skills.Menu:GetPos()
	self.Menu:SetPos( px, py )
	self.Menu.Paint = function( pan, ww, hh )
		draw.RoundedBox( 0, 0, 0, ww*0.985, hh*0.02, Color( 255, 255, 255, 155 ) )
		draw.RoundedBox( 0, ww*0.985, 0, ww*0.015, hh*0.02, Color( 255, 0, 0 ) )
	end	


	local mw, mh = self.Menu:GetSize()
	
	local button = vgui.Create( "DButton", self.Menu )
	button:SetSize( mw*0.015, mh*0.02 )
	button:SetPos( mw*0.985, 0 )
	button:SetText( "" )
	button.DoClick = function()
		wOS.ALCS.Skills:CleanAllMenus()
		self.Menu:Remove()
		self.Menu = nil
	end	
	button.Paint = nil

	local p_think = self.Menu.Think
	self.Menu.Think = function( pan )
		p_think( pan )
		if not vgui.CursorVisible() then
			gui.EnableScreenClicker( true )
		end
		if not LocalPlayer():Alive() then
			button:DoClick()
			return
		end
	end

	self.DataTab = vgui.Create( "DPanel", self.Menu )
	self.DataTab:SetPos( 0, mh*0.02 )
	self.DataTab:SetSize( mw, mh*0.98 )
	self.DataTab.Paint = function( pan, ww, hh )
		blurpanel( pan )
		draw.RoundedBox( 3, 0, 0, ww, hh, Color( 25, 25, 25, 245 ) )
	end

	if mode == wOS.ALCS.GTN.Modes.AUCTIONS then
		self:ShowAuctionHouse()
	elseif mode == wOS.ALCS.GTN.Modes.TRADES then
		self:ShowTradeHouse()
	else
		self:ShowMyListings()
	end

end

local creation_panel
local function OpenCreationPanel()

	if IsValid( creation_panel ) then
		creation_panel:Remove()
		creation_panel = nil
	end

	creation_panel = vgui.Create( "DPanel" )
	creation_panel:SetSize( ScrW()*0.4, ScrH()*0.4 )
	creation_panel:Center()
	creation_panel.Paint = function( pan ,ww, hh )
		blurpanel( pan )
		draw.RoundedBox( 3, 0, 0, ww, hh, Color( 25, 25, 25, 245 ) )
		surface.SetDrawColor( color_white )
		surface.DrawOutlinedRect(0,0,ww,hh) 	
		surface.DrawOutlinedRect(ww*0.38, hh*0.02, ww*0.6, hh*0.47 ) 
		surface.DrawOutlinedRect(ww*0.38, hh*0.51, ww*0.6, hh*0.47 ) 			
	end
	creation_panel.Think = function( pan )
		if not IsValid( wOS.ALCS.GTN.Menu ) or not IsValid( wOS.ALCS.GTN.DataTab ) then
			pan:Remove()
		end
	end

	local cw, ch = creation_panel:GetSize()

	local InvenList = vgui.Create( "DListView", creation_panel )
	InvenList:SetMultiSelect( false )
	InvenList:AddColumn( "Slot" )
	InvenList:AddColumn( "Item" )
	InvenList:AddColumn( "Amount" )
	InvenList:SetPos( cw*0.02, ch*0.02 )
	InvenList:SetSize( cw*0.34, ch*0.84 )
	for i=1, wOS.ALCS.Config.Crafting.MaxInventorySlots do
		local dat = wOS.SaberInventory[i]
		if not dat then continue end
		if dat.Type == WOSTYPE.RAWMATERIAL then continue end
		local name = dat
		local amount = 1
		if istable( dat ) then
			name = dat.Name
			amount = dat.Amount or 1
		end
		if name == "Empty" then continue end
		InvenList:AddLine( i, name, amount )
	end

	local close = vgui.Create( "DButton", creation_panel )
	close:SetPos( cw*0.02, ch*0.88 )
	close:SetSize( cw*0.34, ch*0.08 )
	close:SetText( "" )
	close.Paint = function( pan, ww, hh )
		draw.RoundedBox( 5, 0, 0, ww, hh, ( pan:IsDown() and Color( 0, 55, 155, 155 ) ) or Color( 155, 155, 155, 155 ) )
		draw.SimpleText( "CANCEL CREATION", "wOS.ALCS.DescFont", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	close.DoClick = function( pan )
		creation_panel:Remove()
		creation_panel = nil
	end		

	local dock1 = vgui.Create( "DPanel",creation_panel )
	dock1:SetPos( cw*0.4, ch*0.04 )
	dock1:SetSize( cw*0.56, ch*0.43 )
	dock1.Paint = nil

	local dw, dh = dock1:GetSize()

	local InvenList2 = vgui.Create( "DListView", dock1 )
	InvenList2:SetMultiSelect( false )
	InvenList2:AddColumn( "Item" )
	InvenList2:SetPos( 0, 0 )
	InvenList2:SetSize( dw, dh*0.8 )
	local lst = {}
	for item, dat in pairs( wOS.ItemList ) do
		if dat.Type == WOSTYPE.RAWMATERIAL then continue end
		lst[ #lst + 1 ] = item
	end
	table.sort(lst)
	for _, item in pairs( lst ) do
		InvenList2:AddLine( item )
	end	

	local createt = vgui.Create( "DButton", dock1 )
	createt:SetPos( 0, dh*0.81 )
	createt:SetSize( dw, dh*0.19 )
	createt:SetText( "" )
	createt.Paint = function( pan, ww, hh )
		draw.RoundedBox( 5, 0, 0, ww, hh, ( pan:IsDown() and Color( 0, 55, 155, 155 ) ) or Color( 155, 155, 155, 155 ) )
		draw.SimpleText( "CREATE TRADE LISTING", "wOS.ALCS.DescFont", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	createt.DoClick = function( pan )
		local sel = InvenList:GetSelectedLine()
		if not sel or sel < 1 then return end
		local dat = InvenList:GetLine( sel )
		if not dat then return end
		local slot = dat:GetColumnText( 1 )
		if not slot then return end

		local sel = InvenList2:GetSelectedLine()
		if not sel or sel < 1 then return end
		local dat = InvenList2:GetLine( sel )
		if not dat then return end
		local item = dat:GetColumnText( 1 )
		if not item or #item < 1 then return end

		net.Start( "wOS.ALCS.GTN.CreateTrade" )
			net.WriteInt( tonumber( slot ), 32 )
			net.WriteString( item )
		net.SendToServer()
		creation_panel:Remove()
	end		

	local dock2 = vgui.Create( "DPanel",creation_panel )
	dock2:SetPos( cw*0.4, ch*0.53 )
	dock2:SetSize( dw, dh )
	dock2.Paint = nil

	local cx, cy = creation_panel:GetPos()
	local dx, dy = dock2:GetPos()

	dx = cx + dx
	dy = cy + dy


	local StartBkd = vgui.Create( "DTextEntry", dock2 )
	StartBkd:MakePopup()
	StartBkd:SetPos( dx + dw*0.7, dy )
	StartBkd:SetSize( dw*0.3, dh*0.15 )
	StartBkd:SetText( wOS.ALCS.Config.GTN.MinimumStart )
	StartBkd:SetNumeric( true )
	
	local StartLabel = vgui.Create( "DLabel", dock2 )
	StartLabel:SetPos( 0, 0 )
	StartLabel:SetSize( dw*0.6, dh*0.15 )
	StartLabel:SetText( "Starting Bid:" )
	StartLabel:SetFont( "wOS.AdminMain" )

	local BuyBkd = vgui.Create( "DTextEntry", dock2 )
	BuyBkd:MakePopup()
	BuyBkd:SetPos( dx + dw*0.7, dy + dh*0.3 )
	BuyBkd:SetSize( dw*0.3, dh*0.15 )
	BuyBkd:SetText( wOS.ALCS.Config.GTN.MinimumStart )
	BuyBkd:SetNumeric( true )
	
	local BuyLabel = vgui.Create( "DLabel", dock2 )
	BuyLabel:SetPos( 0, dh*0.3 )
	BuyLabel:SetSize( dw*0.6, dh*0.15 )
	BuyLabel:SetText( "Buy Now Price:" )
	BuyLabel:SetFont( "wOS.AdminMain" )


	local BuyTog = vgui.Create( "DCheckBox", dock2 )
	BuyTog:SetPos( dw - dh*0.15, dh*0.6 )
	BuyTog:SetSize( dh*0.15, dh*0.15 )
	
	local TogLabel = vgui.Create( "DLabel", dock2 )
	TogLabel:SetPos( 0, dh*0.6 )
	TogLabel:SetSize( dw*0.6, dh*0.15 )
	TogLabel:SetText( "Enable Buy Now:" )
	TogLabel:SetFont( "wOS.AdminMain" )


	local createa = vgui.Create( "DButton", dock2 )
	createa:SetPos( 0, dh*0.81 )
	createa:SetSize( dw, dh*0.19 )
	createa:SetText( "" )
	createa.Paint = function( pan, ww, hh )
		draw.RoundedBox( 5, 0, 0, ww, hh, ( pan:IsDown() and Color( 0, 55, 155, 155 ) ) or Color( 155, 155, 155, 155 ) )
		draw.SimpleText( "CREATE AUCTION LISTING", "wOS.ALCS.DescFont", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	createa.DoClick = function( pan )

		local sel = InvenList:GetSelectedLine()
		if not sel or sel < 1 then return end
		local dat = InvenList:GetLine( sel )
		if not dat then return end
		local slot = dat:GetColumnText( 1 )
		if not slot then return end

		local start = StartBkd:GetText()
		if #start < 1 then return end

		local buynow = BuyBkd:GetText()
		if #buynow < 1 then return end

		net.Start("wOS.ALCS.GTN.CreateAuction")
			net.WriteInt( slot, 32 )
			net.WriteInt( tonumber( start ), 32 )
			net.WriteBool( BuyTog:GetChecked() )
			net.WriteInt( tonumber( buynow ), 32 )
		net.SendToServer()
		creation_panel:Remove()
	end
	
end

function wOS.ALCS.GTN:ShowMyListings()
	net.Start( "wOS.ALCS.GTN.RequestMyListings" )
	net.SendToServer()
	self.DataTab:Clear()
 	self.DataTab.SelectedID = 0

	local mw, mh = self.DataTab:GetSize()
	local padx, pady = mh*0.025, mh*0.025 
	local toptab = vgui.Create( "DPanel", self.DataTab )
	toptab:SetPos( padx, pady )
	toptab:SetSize( mw*0.25, mh - 2*pady )
	toptab.Paint = function( pan, ww, hh )
		surface.SetDrawColor( color_white )
		surface.DrawOutlinedRect( ww*0.05, hh*0.075, ww*0.9, ww*0.9 )
		surface.DrawOutlinedRect( 0, 0, ww, hh )
		surface.DrawLine( ww*0.05, hh*0.83, ww*0.95, hh*0.83 )
		surface.DrawLine( ww*0.05, hh*0.74, ww*0.95, hh*0.74 )

		if self.DataTab.SelectedID > 0 then
			surface.DrawLine( ww*0.05, hh*0.535, ww*0.95, hh*0.535 )
			surface.DrawLine( ww*0.05, hh*0.645, ww*0.95, hh*0.645 )
			local tbl = ( self.DataTab.Trade and self.BufferInfo.Data.Trades ) or self.BufferInfo.Data.Auctions
			tbl = tbl or {}
			local text = ( self.DataTab.Trade and "TRADE" ) or "AUCTION"
			local dat = tbl[ self.DataTab.SelectedID ]
			if dat then
				draw.SimpleText( text .. " IDENTIFICATION " .. dat.ID, "wOS.AdminFont", ww/2, hh*0.01, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
				draw.SimpleText( "ENDS " .. dat.Expiration, "wOS.ALCS.DescFont", ww/2, hh*0.04, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
				if self.DataTab.Trade then
					local itemd = wOS.ItemList[ dat.Item ]
					draw.SimpleText( dat.Item, "wOS.ALCS.DescFont", ww/2, hh*0.47, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
					draw.SimpleText( ( itemd and itemd.Description ) or "ITEM DATA NOT FOUND", "wOS.ALCS.DescFont", ww/2, hh*0.5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
					
					itemd = wOS.ItemList[ dat.RequestedItem ]
					draw.SimpleText( dat.RequestedItem, "wOS.ALCS.DescFont", ww/2, hh*0.565, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
					draw.SimpleText( ( itemd and itemd.Description ) or "ITEM DATA NOT FOUND", "wOS.ALCS.DescFont", ww/2, hh*0.595, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
				else
					local itemd = wOS.ItemList[ dat.Item ]
					draw.SimpleText( "FOR " .. dat.Item, "wOS.ALCS.DescFont", ww/2, hh*0.47, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
					draw.SimpleText( ( itemd and itemd.Description ) or "ITEM DATA NOT FOUND", "wOS.ALCS.DescFont", ww/2, hh*0.5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )

					local txt =  ( tonumber( dat.BuyNowPrice ) != 0 and dat.BuyNowPrice ) or "N/A"
					draw.SimpleText( "BUY NOW PRICE: " ..txt , "wOS.ALCS.DescFont", ww/2, hh*0.55, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
					draw.SimpleText( "CURRENT BID: " .. dat.CurrentBid, "wOS.ALCS.DescFont", ww/2, hh*0.58, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
					draw.SimpleText( "BIDDER ID: " .. dat.BidderSteamID, "wOS.ALCS.DescFont", ww/2, hh*0.61, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
				end
			else
				draw.SimpleText( text .. " IDENTIFICATION INVALID", "wOS.AdminFont", ww/2, hh*0.02, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
				draw.SimpleText( "ERROR", "wOS.ALCS.DescFont", ww/2, hh*0.47, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
				draw.SimpleText( "ERROR", "wOS.ALCS.DescFont", ww/2, hh*0.5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
				draw.SimpleText( "ERROR", "wOS.ALCS.DescFont", ww/2, hh*0.55, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
				draw.SimpleText( "ERROR", "wOS.ALCS.DescFont", ww/2, hh*0.58, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
				draw.SimpleText( "ERROR", "wOS.ALCS.DescFont", ww/2, hh*0.61, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
			end
		else
			draw.SimpleText( "NO LISTING SELECTED", "wOS.AdminFont", ww/2, hh*0.02, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
		end

	end

	local tw, th = toptab:GetSize()

	local create = vgui.Create( "DButton", toptab )
	create:SetPos( tw*0.52, th*0.9 - tw*0.1 )
	create:SetSize( tw*0.43, th*0.05 )
	create:SetText( "" )
	create.Paint = function( pan, ww, hh )
		draw.RoundedBox( 5, 0, 0, ww, hh, ( pan:IsDown() and Color( 0, 55, 155, 155 ) ) or Color( 155, 155, 155, 155 ) )
		draw.SimpleText( "CREATE LISTING", "wOS.ALCS.DescFont", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	create.DoClick = function( pan )
		OpenCreationPanel()
	end	

	local refresh = vgui.Create( "DButton", toptab )
	refresh:SetPos( tw*0.05, th*0.9 - tw*0.1 )
	refresh:SetSize( tw*0.43, th*0.05 )
	refresh:SetText( "" )
	refresh.Paint = function( pan, ww, hh )
		draw.RoundedBox( 5, 0, 0, ww, hh, ( pan:IsDown() and Color( 0, 55, 155, 155 ) ) or Color( 155, 155, 155, 155 ) )
		draw.SimpleText( "REFRESH LISTINGS", "wOS.ALCS.DescFont", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	refresh.DoClick = function( pan )
		self:ShowMyListings()
	end	

	local close = vgui.Create( "DButton", toptab )
	close:SetPos( tw*0.05, th*0.95 - tw*0.05 )
	close:SetSize( tw*0.9, th*0.05 )
	close:SetText( "" )
	close.Paint = function( pan, ww, hh )
		draw.RoundedBox( 5, 0, 0, ww, hh, ( pan:IsDown() and Color( 0, 55, 155, 155 ) ) or Color( 155, 155, 155, 155 ) )
		draw.SimpleText( "CLOSE MENU", "wOS.ALCS.DescFont", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	close.DoClick = function( pan )
		wOS.ALCS.Skills.Menu:SetVisible( true )
		self.Menu:Remove()
		self.Menu = nil
	end	

	local remove = vgui.Create( "DButton", toptab )
	remove:SetPos( tw*0.05, th*0.69 - tw*0.05 )
	remove:SetSize( tw*0.9, th*0.05 )
	remove:SetText( "" )
	remove.Paint = function( pan, ww, hh )
		draw.RoundedBox( 5, 0, 0, ww, hh, ( pan:IsDown() and Color( 0, 55, 155, 155 ) ) or Color( 155, 155, 155, 155 ) )
		draw.SimpleText( "REMOVE THIS LISTING", "wOS.ALCS.DescFont", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	remove.DoClick = function( pan )
		if self.DataTab.SelectedID < 1 then return end
		local tbl = ( self.DataTab.Trade and self.BufferInfo.Data.Trades ) or self.BufferInfo.Data.Auctions
		tbl = tbl or {}
		local dat =  tbl[ self.DataTab.SelectedID ]
		if not dat then return end
		net.Start( "wOS.ALCS.GTN.RemoveListing" )
			net.WriteBool( self.DataTab.Trade )
			net.WriteInt( dat.ID, 32 )
		net.SendToServer()
	end	
	
	local modelpanel = vgui.Create( "DModelPanel", toptab )
	modelpanel:SetSize( tw*0.9, tw*0.9 )	
	modelpanel:SetPos( tw*0.05, th*0.075 )	

	function modelpanel.ApplyNewModel( pan, model )
		local Iconent = ClientsideModel("borealis/barrel.mdl")
		Iconent:SetAngles(Angle(0,0,0))
		Iconent:SetPos(Vector(0,0,0))
		Iconent:Spawn()
		Iconent:Activate()	
		Iconent:SetModel( model )
		local center = Iconent:OBBCenter()
		local dist = Iconent:BoundingRadius()*1.6		
		pan:SetModel( model )
		pan:SetLookAt( center )
		pan:SetCamPos( center + Vector( dist, dist, 0 ) )	
		Iconent:Remove()
	end			
	modelpanel:ApplyNewModel( "models/props_lab/huladoll.mdl" )

	toptab.Think = function( pan )
		if self.DataTab.SelectedID < 1 then 
			remove:SetVisible( false )
		else
			remove:SetVisible( true )
		end
	end

	local sidetab = vgui.Create( "DPanel", self.DataTab )
	sidetab:SetPos( 2*padx + mw*0.25, pady )
	sidetab:SetSize( mw*0.75 - 3*padx, mh - 2*pady )
	sidetab.Paint = function( pan, ww, hh )
		surface.SetDrawColor( color_white )
		surface.DrawOutlinedRect( 0, 0, ww, hh )
	end
	
	local sw, sh = sidetab:GetSize()

	local columns = vgui.Create( "DPanel", sidetab )
	columns:SetSize( sw, sh*0.07 )
	columns.Paint = function( pan, ww, hh )

		if not self.BufferInfo.Data then return end
		if not self.BufferInfo.Data.Trades then return end
		if self.BufferInfo.LastUpdated + 2 > CurTime() then return end

		surface.SetDrawColor( color_white )
		surface.DrawOutlinedRect( 0, 0, ww, hh )

		draw.SimpleText( "ID", "wOS.AdminFont", ww*0.05, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		surface.DrawLine( ww*0.1, 0, ww*0.1, hh )

		if self.DataTab.Trade then
			draw.SimpleText( "Offered Item Name", "wOS.AdminFont", ww*0.325, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			surface.DrawLine( ww*0.55, 0, ww*0.55, hh )
			draw.SimpleText( "Requested Item Name", "wOS.AdminFont", ww*0.775, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		else
			draw.SimpleText( "Item Name", "wOS.AdminFont", ww*0.3, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			surface.DrawLine( ww*0.5, 0, ww*0.5, hh )
			draw.SimpleText( "Buy Now Price", "wOS.AdminFont", ww*0.6, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			surface.DrawLine( ww*0.7, 0, ww*0.7, hh )
			draw.SimpleText( "Current Bid", "wOS.AdminFont", ww*0.85, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end

	end

	local listing_list = vgui.Create( "DScrollPanel", sidetab )
	listing_list:SetPos( 0, sh*0.07 )
	listing_list:SetSize( sw, sh*0.93 )
	listing_list.Paint = nil
	local sbar = listing_list:GetVBar()
	sbar.Paint = nil
	sbar.btnUp.Paint = nil
	sbar.btnDown.Paint = nil
	sbar.btnGrip.Paint = nil
	listing_list.Refresh = function( pan, tbl )
		pan:Clear()
		local offset = 0
		local color_shift = false
		local bh = pan:GetTall()*0.07
		
		for num, dat in ipairs( tbl ) do
			local info_panel = vgui.Create( "DButton", pan )
			info_panel:SetPos( 0, offset )
			info_panel:SetSize( sw, bh )
			info_panel:SetText( "" )
			info_panel.Selectable = num
			info_panel.Swap = color_shift
			info_panel.Paint = function( p, ww, hh )
				local col = ( p.Swap and Color( 125, 125, 125 ) ) or Color( 55, 55, 55 )
				if self.DataTab.SelectedID == p.Selectable then
					col = Color( 25, 25, 125 )
				end
				draw.RoundedBox( 0, 0, 0, ww, hh, col )

				surface.SetDrawColor( color_white )
				surface.DrawOutlinedRect(0, 0, ww, hh)

				draw.SimpleText( dat.ID, "wOS.ALCS.DescFont", ww*0.05, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				surface.DrawLine( ww*0.1, 0, ww*0.1, hh )
				if self.DataTab.Trade then
					draw.SimpleText( dat.Item, "wOS.ALCS.DescFont", ww*0.325, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
					surface.DrawLine( ww*0.55, 0, ww*0.55, hh )
					draw.SimpleText( dat.RequestedItem, "wOS.ALCS.DescFont", ww*0.775, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				else
					draw.SimpleText( dat.Item, "wOS.ALCS.DescFont", ww*0.3, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
					surface.DrawLine( ww*0.5, 0, ww*0.5, hh )
					draw.SimpleText( ( tonumber( dat.BuyNowPrice ) != 0 and dat.BuyNowPrice ) or "N/A", "wOS.ALCS.DescFont", ww*0.6, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
					surface.DrawLine( ww*0.7, 0, ww*0.7, hh )
					draw.SimpleText( dat.CurrentBid, "wOS.ALCS.DescFont", ww*0.85, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				end
		
			end
			info_panel.DoClick = function( p )
				self.DataTab.SelectedID = p.Selectable
				local item_m = wOS.ItemList[ dat.Item ]
				local model = "models/props_lab/huladoll.mdl"
				if item_m then model = item_m.Model end
				modelpanel:ApplyNewModel( model )
			end
			color_shift = !color_shift
			offset = offset + bh
		end
		
	end

	local showtrade = vgui.Create( "DButton", toptab )
	showtrade:SetPos( tw*0.05, th*0.78 - tw*0.05 )
	showtrade:SetSize( tw*0.43, th*0.05 )
	showtrade:SetText( "" )
	showtrade.Paint = function( pan, ww, hh )
		if not self.BufferInfo.Data then return end
		if not self.BufferInfo.LastUpdated then return end
		if self.BufferInfo.LastUpdated + 2 > CurTime() then return end
		draw.RoundedBox( 5, 0, 0, ww, hh, ( pan:IsDown() and Color( 0, 55, 155, 155 ) ) or Color( 155, 155, 155, 155 ) )
		draw.SimpleText( "SHOW TRADES", "wOS.ALCS.DescFont", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	showtrade.DoClick = function( pan )
		if not self.BufferInfo.Data then return end
		if not self.BufferInfo.LastUpdated then return end
		if self.BufferInfo.LastUpdated + 2 > CurTime() then return end
		self.DataTab.Trade = true
		self.DataTab.SelectedID = 0
		modelpanel:ApplyNewModel( "models/props_lab/huladoll.mdl" )
		listing_list:Refresh( self.BufferInfo.Data.Trades or {} )
	end	

	local showauct = vgui.Create( "DButton", toptab )
	showauct:SetPos( tw*0.52, th*0.78 - tw*0.05 )
	showauct:SetSize( tw*0.43, th*0.05 )
	showauct:SetText( "" )
	showauct.Paint = function( pan, ww, hh )
		if not self.BufferInfo.Data then return end
		if not self.BufferInfo.LastUpdated then return end
		if self.BufferInfo.LastUpdated + 2 > CurTime() then return end
		draw.RoundedBox( 5, 0, 0, ww, hh, ( pan:IsDown() and Color( 0, 55, 155, 155 ) ) or Color( 155, 155, 155, 155 ) )
		draw.SimpleText( "SHOW AUCTIONS", "wOS.ALCS.DescFont", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	showauct.DoClick = function( pan )
		if not self.BufferInfo.Data then return end
		if not self.BufferInfo.LastUpdated then return end
		if self.BufferInfo.LastUpdated + 2 > CurTime() then return end

		self.DataTab.Trade = nil
		self.DataTab.SelectedID = 0
		modelpanel:ApplyNewModel( "models/props_lab/huladoll.mdl" )
		listing_list:Refresh( self.BufferInfo.Data.Auctions or {} )
	end	

	function self:RefreshMenu()
		modelpanel:ApplyNewModel( "models/props_lab/huladoll.mdl" )
		self.DataTab.SelectedID = 0
		if self.DataTab.Trade then
			listing_list:Refresh( self.BufferInfo.Data.Trades or {} )
		else
			listing_list:Refresh( self.BufferInfo.Data.Auctions or {} )
		end
	end

end

function wOS.ALCS.GTN:ShowAuctionHouse()
	net.Start( "wOS.ALCS.GTN.RequestAuctions" )
	net.SendToServer()
	self.DataTab:Clear()
 	self.DataTab.SelectedID = 0

	local mw, mh = self.DataTab:GetSize()
	local padx, pady = mh*0.025, mh*0.025 
	local toptab = vgui.Create( "DPanel", self.DataTab )
	toptab:SetPos( padx, pady )
	toptab:SetSize( mw*0.25, mh - 2*pady )
	toptab.Paint = function( pan, ww, hh )
		surface.SetDrawColor( color_white )
		surface.DrawOutlinedRect( ww*0.05, hh*0.075, ww*0.9, ww*0.9 )
		surface.DrawOutlinedRect( 0, 0, ww, hh )
		surface.DrawLine( ww*0.05, hh*0.83, ww*0.95, hh*0.83 )


		if self.DataTab.SelectedID > 0 then
			surface.DrawLine( ww*0.05, hh*0.74, ww*0.95, hh*0.74 )
			surface.DrawLine( ww*0.05, hh*0.535, ww*0.95, hh*0.535 )
			local tbl = self.BufferInfo.Data
			tbl = tbl or {}
			local text = "AUCTION"
			local dat = tbl[ self.DataTab.SelectedID ]
			if dat then
				draw.SimpleText( text .. " IDENTIFICATION " .. dat.ID, "wOS.AdminFont", ww/2, hh*0.01, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
				draw.SimpleText( "ENDS " .. dat.Expiration, "wOS.ALCS.DescFont", ww/2, hh*0.04, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
				local itemd = wOS.ItemList[ dat.Item ]
				draw.SimpleText( dat.Item, "wOS.ALCS.DescFont", ww/2, hh*0.47, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
				draw.SimpleText( ( itemd and itemd.Description ) or "ITEM DATA NOT FOUND", "wOS.ALCS.DescFont", ww/2, hh*0.5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )

				local txt =  ( tonumber( dat.BuyNowPrice ) != 0 and dat.BuyNowPrice ) or "N/A"
				draw.SimpleText( "BUY NOW PRICE: " ..txt , "wOS.ALCS.DescFont", ww/2, hh*0.55, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
				draw.SimpleText( "CURRENT BID: " .. dat.CurrentBid, "wOS.ALCS.DescFont", ww/2, hh*0.58, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
				draw.SimpleText( "BIDDER ID: " .. dat.BidderSteamID, "wOS.ALCS.DescFont", ww/2, hh*0.61, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )

				if txt != "N/A" then
					surface.DrawLine( ww*0.05, hh*0.645, ww*0.95, hh*0.645 )
				end

			else
				draw.SimpleText( text .. " IDENTIFICATION INVALID", "wOS.AdminFont", ww/2, hh*0.02, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
				draw.SimpleText( "ERROR", "wOS.ALCS.DescFont", ww/2, hh*0.47, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
				draw.SimpleText( "ERROR", "wOS.ALCS.DescFont", ww/2, hh*0.5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
				draw.SimpleText( "ERROR", "wOS.ALCS.DescFont", ww/2, hh*0.55, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
				draw.SimpleText( "ERROR", "wOS.ALCS.DescFont", ww/2, hh*0.58, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
				draw.SimpleText( "ERROR", "wOS.ALCS.DescFont", ww/2, hh*0.61, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
			end
		else
			draw.SimpleText( "NO LISTING SELECTED", "wOS.AdminFont", ww/2, hh*0.02, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
		end

	end

	local tw, th = toptab:GetSize()

	local refresh = vgui.Create( "DButton", toptab )
	refresh:SetPos( tw*0.05, th*0.9 - tw*0.1 )
	refresh:SetSize( tw*0.9, th*0.05 )
	refresh:SetText( "" )
	refresh.Paint = function( pan, ww, hh )
		draw.RoundedBox( 5, 0, 0, ww, hh, ( pan:IsDown() and Color( 0, 55, 155, 155 ) ) or Color( 155, 155, 155, 155 ) )
		draw.SimpleText( "REFRESH LISTINGS", "wOS.ALCS.DescFont", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	refresh.DoClick = function( pan )
		self:ShowAuctionHouse()
	end	

	local close = vgui.Create( "DButton", toptab )
	close:SetPos( tw*0.05, th*0.95 - tw*0.05 )
	close:SetSize( tw*0.9, th*0.05 )
	close:SetText( "" )
	close.Paint = function( pan, ww, hh )
		draw.RoundedBox( 5, 0, 0, ww, hh, ( pan:IsDown() and Color( 0, 55, 155, 155 ) ) or Color( 155, 155, 155, 155 ) )
		draw.SimpleText( "CLOSE MENU", "wOS.ALCS.DescFont", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	close.DoClick = function( pan )
		wOS.ALCS.Skills.Menu:SetVisible( true )
		self.Menu:Remove()
		self.Menu = nil
	end	
	
	local modelpanel = vgui.Create( "DModelPanel", toptab )
	modelpanel:SetSize( tw*0.9, tw*0.9 )	
	modelpanel:SetPos( tw*0.05, th*0.075 )	

	function modelpanel.ApplyNewModel( pan, model )
		local Iconent = ClientsideModel("borealis/barrel.mdl")
		Iconent:SetAngles(Angle(0,0,0))
		Iconent:SetPos(Vector(0,0,0))
		Iconent:Spawn()
		Iconent:Activate()	
		Iconent:SetModel( model )
		local center = Iconent:OBBCenter()
		local dist = Iconent:BoundingRadius()*1.6		
		pan:SetModel( model )
		pan:SetLookAt( center )
		pan:SetCamPos( center + Vector( dist, dist, 0 ) )	
		Iconent:Remove()
	end			
	modelpanel:ApplyNewModel( "models/props_lab/huladoll.mdl" )

	local sidetab = vgui.Create( "DPanel", self.DataTab )
	sidetab:SetPos( 2*padx + mw*0.25, pady )
	sidetab:SetSize( mw*0.75 - 3*padx, mh - 2*pady )
	sidetab.Paint = function( pan, ww, hh )
		surface.SetDrawColor( color_white )
		surface.DrawOutlinedRect( 0, 0, ww, hh )
	end
	
	local sw, sh = sidetab:GetSize()

	local columns = vgui.Create( "DPanel", sidetab )
	columns:SetSize( sw, sh*0.07 )
	columns.Paint = function( pan, ww, hh )

		if not self.BufferInfo.Data then return end
		if self.BufferInfo.LastUpdated + 2 >= CurTime() then return end

		surface.SetDrawColor( color_white )
		surface.DrawOutlinedRect( 0, 0, ww, hh )

		draw.SimpleText( "ID", "wOS.AdminFont", ww*0.05, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		surface.DrawLine( ww*0.1, 0, ww*0.1, hh )

		draw.SimpleText( "Item Name", "wOS.AdminFont", ww*0.25, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		surface.DrawLine( ww*0.4, 0, ww*0.4, hh )

		draw.SimpleText( "Buy Now Price", "wOS.AdminFont", ww*0.5, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		surface.DrawLine( ww*0.6, 0, ww*0.6, hh )

		draw.SimpleText( "Current Bid", "wOS.AdminFont", ww*0.675, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		surface.DrawLine( ww*0.75, 0, ww*0.75, hh )

		draw.SimpleText( "Auction Ends", "wOS.AdminFont", ww*0.875, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

	end

	local listing_list = vgui.Create( "DScrollPanel", sidetab )
	listing_list:SetPos( 0, sh*0.07 )
	listing_list:SetSize( sw, sh*0.93 )
	listing_list.Paint = nil
	local sbar = listing_list:GetVBar()
	sbar.Paint = nil
	sbar.btnUp.Paint = nil
	sbar.btnDown.Paint = nil
	sbar.btnGrip.Paint = nil
	listing_list.Refresh = function( pan, tbl )
		pan:Clear()
		local offset = 0
		local color_shift = false
		local bh = pan:GetTall()*0.07
		
		for num, dat in ipairs( tbl ) do
			local info_panel = vgui.Create( "DButton", pan )
			info_panel:SetPos( 0, offset )
			info_panel:SetSize( sw, bh )
			info_panel:SetText( "" )
			info_panel.Selectable = num
			info_panel.Swap = color_shift
			info_panel.Paint = function( p, ww, hh )
				local col = ( p.Swap and Color( 125, 125, 125 ) ) or Color( 55, 55, 55 )
				if self.DataTab.SelectedID == p.Selectable then
					col = Color( 25, 25, 125 )
				end
				draw.RoundedBox( 0, 0, 0, ww, hh, col )

				surface.SetDrawColor( color_white )
				surface.DrawOutlinedRect(0, 0, ww, hh)

				draw.SimpleText( dat.ID, "wOS.ALCS.DescFont", ww*0.05, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				surface.DrawLine( ww*0.1, 0, ww*0.1, hh )
				draw.SimpleText( dat.Item, "wOS.ALCS.DescFont", ww*0.25, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				surface.DrawLine( ww*0.4, 0, ww*0.4, hh )

				draw.SimpleText( ( tonumber( dat.BuyNowPrice ) != 0 and dat.BuyNowPrice ) or "N/A", "wOS.ALCS.DescFont", ww*0.5, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				surface.DrawLine( ww*0.6, 0, ww*0.6, hh )

				draw.SimpleText( dat.CurrentBid, "wOS.ALCS.DescFont", ww*0.675, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				surface.DrawLine( ww*0.75, 0, ww*0.75, hh )

				draw.SimpleText( dat.Expiration, "wOS.ALCS.DescFont", ww*0.875, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

			end
			info_panel.DoClick = function( p )
				self.DataTab.SelectedID = p.Selectable
				local item_m = wOS.ItemList[ dat.Item ]
				local model = "models/props_lab/huladoll.mdl"
				if item_m then model = item_m.Model end
				modelpanel:ApplyNewModel( model )
			end
			color_shift = !color_shift
			offset = offset + bh
		end
		
	end
	listing_list.Delay = CurTime() + 3
	listing_list.Think = function( pan )
		if pan.Delay > CurTime() then return end
		if not self.BufferInfo.Data then return end
		if self.BufferInfo.LastUpdated + 2 >= CurTime() then return end
		pan:Refresh( self.BufferInfo.Data )
		pan.Think = nil
	end

	local tx, ty = toptab:GetPos()
	local sx, sy = self.DataTab:GetPos()
	tx = sx + ty
	ty = sx + ty

	sx, sy = self.Menu:GetPos()
	tx = sx + ty
	ty = sx + ty

	local offertext = vgui.Create( "DTextEntry", toptab )
	offertext:MakePopup()
	offertext:SetPos( tx + tw*0.05, ty + th*0.725 - tw*0.05 )
	offertext:SetSize( tw*0.4, th*0.05 )
	offertext:SetText( "0" )
	offertext:SetNumeric( true )

	local offerbutton = vgui.Create( "DButton", toptab )
	offerbutton:SetPos( tw*0.5, th*0.785 - tw*0.05 )
	offerbutton:SetSize( tw*0.45, th*0.05 )
	offerbutton:SetText( "" )
	offerbutton.Paint = function( pan, ww, hh )
		draw.RoundedBox( 5, 0, 0, ww, hh, ( pan:IsDown() and Color( 0, 55, 155, 155 ) ) or Color( 155, 155, 155, 155 ) )
		draw.SimpleText( "BID AMOUNT", "wOS.ALCS.DescFont", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	offerbutton.DoClick = function( pan )
		if self.DataTab.SelectedID < 1 then return end
		local tbl = self.BufferInfo.Data
		tbl = tbl or {}
		local dat =  tbl[ self.DataTab.SelectedID ]
		if not dat then return end
		local offer = tonumber( offertext:GetText() )
		if offer < 1 then return end
		if offer <= tonumber( dat.CurrentBid ) then return end
		net.Start( "wOS.ALCS.GTN.MakeAuctionOffer" )
			net.WriteInt( offer, 32 )
			net.WriteInt( dat.ID, 32 )
			net.WriteInt( dat.CharID, 32 )
			net.WriteString( dat.SteamID )
		net.SendToServer()
	end	


	local remove = vgui.Create( "DButton", toptab )
	remove:SetPos( tw*0.05, th*0.69 - tw*0.05 )
	remove:SetSize( tw*0.9, th*0.05 )
	remove:SetText( "" )
	remove.Paint = function( pan, ww, hh )
		draw.RoundedBox( 5, 0, 0, ww, hh, ( pan:IsDown() and Color( 0, 55, 155, 155 ) ) or Color( 155, 155, 155, 155 ) )
		draw.SimpleText( "BUY IT NOW", "wOS.ALCS.DescFont", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	remove.DoClick = function( pan )
		if self.DataTab.SelectedID < 1 then return end
		local tbl = self.BufferInfo.Data
		tbl = tbl or {}
		local dat =  tbl[ self.DataTab.SelectedID ]
		if not dat then return end
		net.Start( "wOS.ALCS.GTN.BuyAuctionOut" )
			net.WriteInt( dat.ID, 32 )
			net.WriteInt( dat.CharID, 32 )
			net.WriteString( dat.SteamID )
		net.SendToServer()
	end	

	toptab.Think = function( pan )
		local vis = false
		local ovis = false
		if self.DataTab.SelectedID > 0 then 
			local dat = wOS.ALCS.GTN.BufferInfo.Data[ self.DataTab.SelectedID ]
			if dat then
				ovis = true
				if dat.BuyNowPrice and tonumber( dat.BuyNowPrice ) != 0 then
					vis = true 
				end
			end
		end
		remove:SetVisible( vis )
		offertext:SetVisible( ovis )
		offerbutton:SetVisible( ovis )
	end

	function self:RefreshMenu()

	end

end

function wOS.ALCS.GTN:ShowTradeHouse()
	net.Start( "wOS.ALCS.GTN.RequestTrades" )
	net.SendToServer()
	self.DataTab:Clear()
 	self.DataTab.SelectedID = 0

	local mw, mh = self.DataTab:GetSize()
	local padx, pady = mh*0.025, mh*0.025 
	local toptab = vgui.Create( "DPanel", self.DataTab )
	toptab:SetPos( padx, pady )
	toptab:SetSize( mw*0.25, mh - 2*pady )
	toptab.Paint = function( pan, ww, hh )
		surface.SetDrawColor( color_white )
		surface.DrawOutlinedRect( ww*0.05, hh*0.075, ww*0.9, ww*0.9 )
		surface.DrawOutlinedRect( 0, 0, ww, hh )
		surface.DrawLine( ww*0.05, hh*0.83, ww*0.95, hh*0.83 )


		if self.DataTab.SelectedID > 0 then
			surface.DrawLine( ww*0.05, hh*0.535, ww*0.95, hh*0.535 )
			local tbl = self.BufferInfo.Data
			tbl = tbl or {}
			local text = "AUCTION"
			local dat = tbl[ self.DataTab.SelectedID ]
			if dat then
				draw.SimpleText( text .. " IDENTIFICATION " .. dat.ID, "wOS.AdminFont", ww/2, hh*0.01, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
				draw.SimpleText( "ENDS " .. dat.Expiration, "wOS.ALCS.DescFont", ww/2, hh*0.04, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
				
				local itemd = wOS.ItemList[ dat.Item ]
				draw.SimpleText( dat.Item, "wOS.ALCS.DescFont", ww/2, hh*0.47, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
				draw.SimpleText( ( itemd and itemd.Description ) or "ITEM DATA NOT FOUND", "wOS.ALCS.DescFont", ww/2, hh*0.5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )

				itemd = wOS.ItemList[ dat.RequestedItem ]
				draw.SimpleText( dat.RequestedItem, "wOS.ALCS.DescFont", ww/2, hh*0.615, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
				draw.SimpleText( ( itemd and itemd.Description ) or "ITEM DATA NOT FOUND", "wOS.ALCS.DescFont", ww/2, hh*0.645, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )

			else
				draw.SimpleText( text .. " IDENTIFICATION INVALID", "wOS.AdminFont", ww/2, hh*0.02, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
				draw.SimpleText( "ERROR", "wOS.ALCS.DescFont", ww/2, hh*0.47, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
				draw.SimpleText( "ERROR", "wOS.ALCS.DescFont", ww/2, hh*0.5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
				draw.SimpleText( "ERROR", "wOS.ALCS.DescFont", ww/2, hh*0.55, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
				draw.SimpleText( "ERROR", "wOS.ALCS.DescFont", ww/2, hh*0.58, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
				draw.SimpleText( "ERROR", "wOS.ALCS.DescFont", ww/2, hh*0.61, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
			end
		else
			draw.SimpleText( "NO LISTING SELECTED", "wOS.AdminFont", ww/2, hh*0.02, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
		end

	end

	local tw, th = toptab:GetSize()

	local refresh = vgui.Create( "DButton", toptab )
	refresh:SetPos( tw*0.05, th*0.9 - tw*0.1 )
	refresh:SetSize( tw*0.9, th*0.05 )
	refresh:SetText( "" )
	refresh.Paint = function( pan, ww, hh )
		draw.RoundedBox( 5, 0, 0, ww, hh, ( pan:IsDown() and Color( 0, 55, 155, 155 ) ) or Color( 155, 155, 155, 155 ) )
		draw.SimpleText( "REFRESH LISTINGS", "wOS.ALCS.DescFont", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	refresh.DoClick = function( pan )
		self:ShowTradeHouse()
	end	

	local close = vgui.Create( "DButton", toptab )
	close:SetPos( tw*0.05, th*0.95 - tw*0.05 )
	close:SetSize( tw*0.9, th*0.05 )
	close:SetText( "" )
	close.Paint = function( pan, ww, hh )
		draw.RoundedBox( 5, 0, 0, ww, hh, ( pan:IsDown() and Color( 0, 55, 155, 155 ) ) or Color( 155, 155, 155, 155 ) )
		draw.SimpleText( "CLOSE MENU", "wOS.ALCS.DescFont", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	close.DoClick = function( pan )
		wOS.ALCS.Skills.Menu:SetVisible( true )
		self.Menu:Remove()
		self.Menu = nil
	end	
	
	local modelpanel = vgui.Create( "DModelPanel", toptab )
	modelpanel:SetSize( tw*0.9, tw*0.9 )	
	modelpanel:SetPos( tw*0.05, th*0.075 )	

	function modelpanel.ApplyNewModel( pan, model )
		local Iconent = ClientsideModel("borealis/barrel.mdl")
		Iconent:SetAngles(Angle(0,0,0))
		Iconent:SetPos(Vector(0,0,0))
		Iconent:Spawn()
		Iconent:Activate()	
		Iconent:SetModel( model )
		local center = Iconent:OBBCenter()
		local dist = Iconent:BoundingRadius()*1.6		
		pan:SetModel( model )
		pan:SetLookAt( center )
		pan:SetCamPos( center + Vector( dist, dist, 0 ) )	
		Iconent:Remove()
	end			
	modelpanel:ApplyNewModel( "models/props_lab/huladoll.mdl" )

	local sidetab = vgui.Create( "DPanel", self.DataTab )
	sidetab:SetPos( 2*padx + mw*0.25, pady )
	sidetab:SetSize( mw*0.75 - 3*padx, mh - 2*pady )
	sidetab.Paint = function( pan, ww, hh )
		surface.SetDrawColor( color_white )
		surface.DrawOutlinedRect( 0, 0, ww, hh )
	end
	
	local sw, sh = sidetab:GetSize()

	local columns = vgui.Create( "DPanel", sidetab )
	columns:SetSize( sw, sh*0.07 )
	columns.Paint = function( pan, ww, hh )

		if not self.BufferInfo.Data then return end
		if self.BufferInfo.LastUpdated + 2 >= CurTime() then return end

		surface.SetDrawColor( color_white )
		surface.DrawOutlinedRect( 0, 0, ww, hh )

		draw.SimpleText( "ID", "wOS.AdminFont", ww*0.05, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		surface.DrawLine( ww*0.1, 0, ww*0.1, hh )

		draw.SimpleText( "Offered Item", "wOS.AdminFont", ww*0.2625, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		surface.DrawLine( ww*0.425, 0, ww*0.425, hh )

		draw.SimpleText( "Requested Item", "wOS.AdminFont", ww*0.5875, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		surface.DrawLine( ww*0.75, 0, ww*0.75, hh )

		draw.SimpleText( "Auction Ends", "wOS.AdminFont", ww*0.875, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

	end

	local listing_list = vgui.Create( "DScrollPanel", sidetab )
	listing_list:SetPos( 0, sh*0.07 )
	listing_list:SetSize( sw, sh*0.93 )
	listing_list.Paint = nil
	local sbar = listing_list:GetVBar()
	sbar.Paint = nil
	sbar.btnUp.Paint = nil
	sbar.btnDown.Paint = nil
	sbar.btnGrip.Paint = nil
	listing_list.Refresh = function( pan, tbl )
		pan:Clear()
		local offset = 0
		local color_shift = false
		local bh = pan:GetTall()*0.07
		
		for num, dat in ipairs( tbl ) do
			local info_panel = vgui.Create( "DButton", pan )
			info_panel:SetPos( 0, offset )
			info_panel:SetSize( sw, bh )
			info_panel:SetText( "" )
			info_panel.Selectable = num
			info_panel.Swap = color_shift
			info_panel.Paint = function( p, ww, hh )
				local col = ( p.Swap and Color( 125, 125, 125 ) ) or Color( 55, 55, 55 )
				if self.DataTab.SelectedID == p.Selectable then
					col = Color( 25, 25, 125 )
				end
				draw.RoundedBox( 0, 0, 0, ww, hh, col )

				surface.SetDrawColor( color_white )
				surface.DrawOutlinedRect(0, 0, ww, hh)

				draw.SimpleText( dat.ID, "wOS.ALCS.DescFont", ww*0.05, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				surface.DrawLine( ww*0.1, 0, ww*0.1, hh )
				draw.SimpleText( dat.Item, "wOS.ALCS.DescFont", ww*0.2625, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				surface.DrawLine( ww*0.425, 0, ww*0.425, hh )

				draw.SimpleText( dat.RequestedItem, "wOS.ALCS.DescFont", ww*0.5875, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				surface.DrawLine( ww*0.75, 0, ww*0.75, hh )

				draw.SimpleText( dat.Expiration, "wOS.ALCS.DescFont", ww*0.875, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

			end
			info_panel.DoClick = function( p )
				self.DataTab.SelectedID = p.Selectable
				local item_m = wOS.ItemList[ dat.Item ]
				local model = "models/props_lab/huladoll.mdl"
				if item_m then model = item_m.Model end
				modelpanel:ApplyNewModel( model )
			end
			color_shift = !color_shift
			offset = offset + bh
		end
		
	end
	listing_list.Delay = CurTime() + 3
	listing_list.Think = function( pan )
		if pan.Delay > CurTime() then return end
		if not self.BufferInfo.Data then return end
		if self.BufferInfo.LastUpdated + 2 >= CurTime() then return end
		pan:Refresh( self.BufferInfo.Data )
		pan.Think = nil
	end

	local remove = vgui.Create( "DButton", toptab )
	remove:SetPos( tw*0.05, th*0.74 - tw*0.05 )
	remove:SetSize( tw*0.9, th*0.05 )
	remove:SetText( "" )
	remove.Paint = function( pan, ww, hh )
		draw.RoundedBox( 5, 0, 0, ww, hh, ( pan:IsDown() and Color( 0, 55, 155, 155 ) ) or Color( 155, 155, 155, 155 ) )
		draw.SimpleText( "ACCEPT TRADE", "wOS.ALCS.DescFont", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	remove.DoClick = function( pan )
		if self.DataTab.SelectedID < 1 then return end
		local tbl = self.BufferInfo.Data
		tbl = tbl or {}
		local dat =  tbl[ self.DataTab.SelectedID ]
		if not dat then return end
		net.Start( "wOS.ALCS.GTN.BuyTradeOut" )
			net.WriteInt( dat.ID, 32 )
			net.WriteInt( dat.CharID, 32 )
			net.WriteString( dat.SteamID )
		net.SendToServer()
	end	

	toptab.Think = function( pan )
		local vis = false
		if self.DataTab.SelectedID > 0 then 
			local dat = wOS.ALCS.GTN.BufferInfo.Data[ self.DataTab.SelectedID ]
			if dat then
				vis = true 
			end
		end
		remove:SetVisible( vis )
	end

	function self:RefreshMenu()

	end

end