--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2020
	
	Contact: www.wiltostech.com
		----------------------------------------]]--








































































wOS = wOS or {}
wOS.ALCS = wOS.ALCS or {}
wOS.ALCS.Dueling = wOS.ALCS.Dueling or {}
wOS.ALCS.Dueling.Spirits = wOS.ALCS.Dueling.Spirits or {}

net.Receive( "wOS.ALCS.Dueling.SendPlayerData", function( len )

	local spirit = net.ReadBool()
	
	if !spirit then
		wOS.ALCS.Dueling.DuelData = net.ReadTable()
	else
		wOS.ALCS.Dueling.SpiritData = net.ReadTable()
	end

end )

net.Receive( "wOS.ALCS.Dueling.SendSpirits", function( len )

	local newtbl = net.ReadTable()

	wOS.ALCS.Dueling.Spirits = wOS.ALCS.Dueling.Spirits or {}
	table.Merge( wOS.ALCS.Dueling.Spirits, newtbl )
	
end )

net.Receive( "wOS.ALCS.Dueling.SendSpiritResults", function()

	local results = net.ReadTable()
	if table.Count( results ) < 1 then return end

	results.time = CurTime()
	wOS.ALCS.Dueling.Results = table.Copy( results )

end )

net.Receive( "wOS.ALCS.Dueling.RefreshSacrifices", function( len )

	wOS.SaberInventory = net.ReadTable()
	wOS.ALCS.Skills:ChangeCamFocus( "Duel-ViewSacrifices" )

end )

net.Receive( "wOS.ALCS.Dueling.CreateDuel", function( len )

	local ply = net.ReadEntity()
	if not IsValid( ply ) then return end
	
	local data = net.ReadTable()
	data.Defender = ply
	
	wOS.ALCS.Dueling:CreateChallengeMenu( data )
	
end )

net.Receive( "wOS.ALCS.Dueling.DuelRequest", function( len )


	local challenger = net.ReadEntity()
	if not challenger then return end
	
	local settings = net.ReadTable()
	local data = net.ReadTable()
	data.Challenger = challenger
	
	wOS.ALCS.Dueling:AddChallenge( data, settings )
		
end )

net.Receive( "wOS.ALCS.Dueling.DuelFinish", function( len )


	wOS.ALCS.Dueling.Opponent = nil
	wOS.ALCS.Dueling.IntroSlot = nil
	wOS.ALCS.Dueling.IntroTime = nil
	wOS.ALCS.Dueling.FadeThrough = CurTime() + 1

	local result = net.ReadInt( 32 )
	local resultpan = vgui.Create( "DPanel" )
	resultpan:SetSize( ScrW()*0.5, ScrH()*0.1 )
	resultpan:SetPos( ScrW()*0.25, ScrH()*0.02 )	
	
	if result == WOS_ALCS.DUEL.WON then
		resultpan.Paint = function( pan, ww, hh )
			draw.SimpleText( "DUEL WON! You have been awarded your wager.", "wOS.MegaDuelFont", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
	elseif result == WOS_ALCS.DUEL.LOST then
		resultpan.Paint = function( pan, ww, hh )
			draw.SimpleText( "DUEL LOST! Your wager has been deducted.", "wOS.MegaDuelFont", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
	else
		resultpan.Paint = function( pan, ww, hh )
			draw.SimpleText( "NOBODY WINS! The duel was a draw.", "wOS.MegaDuelFont", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
	end
	
	resultpan.CoolDown = CurTime() + 5
	
	resultpan.Think = function( self )
		if self.CoolDown < CurTime() then
			self:Remove()
		end
	end

end )

net.Receive( "wOS.ALCS.Dueling.DuelDecline", function( len )
	
	local resultpan = vgui.Create( "DPanel" )
	resultpan:SetSize( ScrW()*0.5, ScrH()*0.1 )
	resultpan:SetPos( ScrW()*0.25, ScrH()*0.02 )	
	resultpan.ply = net.ReadEntity()
	resultpan.Paint = function( pan, ww, hh )
		if pan.ply:IsValid() then
			draw.SimpleText( pan.ply:Nick() .. " has declined your request.", "wOS.MegaDuelFont", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
	end	
	resultpan.CoolDown = CurTime() + 5
	resultpan.Think = function( self )
		if self.CoolDown < CurTime() or not self.ply:IsValid() then
			self:Remove()
		end
	end
	
end )

net.Receive( "wOS.ALCS.Dueling.StartDuelCam", function( len )
	
	local opponent = net.ReadEntity()
	if not opponent then return end
	
	wOS.ALCS.Dueling.Opponent = opponent
	
	local data = net.ReadTable()
	if not data then return end
	
	wOS.ALCS.Dueling.Opponent.DuelData = table.Copy( data )
	
	wOS.ALCS.Dueling.IntroSlot = 1
	wOS.ALCS.Dueling.IntroTime = CurTime() + 5
	
	wOS.ALCS.Dueling.FadeThrough = CurTime() + 1
	
end )

properties.Add( "Challenge to Duel", {
	MenuLabel = "#Challenge to Duel", -- Name to display on the context menu
	Order = 1, -- The order to display this property relative to other properties
	MenuIcon = "icon16/comments_delete.png", -- The icon to display next to the property
	Filter = function( self, ent, ply ) -- A function that determines whether an entity is valid for this property
		if ( !IsValid( ent ) ) then return false end
		if ( !ent:IsPlayer() ) then return false end
		return true
	end,
	Action = function( self, ent ) -- The action to perform upon using the property ( Clientside )
		self:MsgStart()
			net.WriteEntity( ent )
		self:MsgEnd()
	end,
} )