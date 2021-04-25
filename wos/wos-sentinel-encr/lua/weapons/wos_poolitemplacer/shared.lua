if SERVER then

	AddCSLuaFile( "shared.lua" )
	
	SWEP.Weight				= 1
	SWEP.AutoSwitchTo		= false
	SWEP.AutoSwitchFrom		= false
	
end

if CLIENT then

	ClientItemPlacerTbl = {}
	ClientItemPlacerTbl[ "teh" ] = {}

	SWEP.DrawAmmo			= true
	SWEP.DrawCrosshair		= true
	SWEP.CSMuzzleFlashes	= true

	SWEP.ViewModelFOV		= 74
	SWEP.ViewModelFlip		= false
	
	SWEP.PrintName = "Item Placement Tool"
	SWEP.Slot = 5
	SWEP.Slotpos = 5
	
	function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
		
	end
	
end

SWEP.HoldType = "pistol"

SWEP.ViewModel	= "models/weapons/c_toolgun.mdl"
SWEP.WorldModel = "models/weapons/w_toolgun.mdl"
SWEP.UseHands = true

SWEP.Primary.Swap           = Sound( "weapons/clipempty_rifle.wav" )
SWEP.Primary.Sound			= Sound( "NPC_CombineCamera.Click" )
SWEP.Primary.Delete1		= Sound( "Weapon_StunStick.Melee_Hit" )
SWEP.Primary.Delete			= Sound( "Weapon_StunStick.Melee_HitWorld" )

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "pistol"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.AmmoType = "Knife"

SWEP.ItemTypes = { "info_wos_itemspawn", }

SWEP.ServersideItems = { "info_wos_itemspawn" }

SWEP.SharedItems = { "info_wos_itemspawn" }

if SERVER then
	util.AddNetworkString( "ItemPlacerSynch" )
	util.AddNetworkString( "CategorySynch" )
end

local SpawnedCategories = {}
function SWEP:Initialize()

	if SERVER then
	
		self.Weapon:SetWeaponHoldType( self.HoldType )
		
	end
	for i = 1, 9 do
		SpawnedCategories[i] = 1
	end
	
end

function SWEP:Synch()

	for k,v in pairs( self.ServersideItems ) do
	
		local ents = ents.FindByClass( v )
		local postbl = {}
		
		for c,d in pairs( ents ) do
		
			table.insert( postbl, d:GetPos() )
		
		end
		
		net.Start( "ItemPlacerSynch" )
		net.WriteString( v )
		net.WriteTable( postbl )
		net.Send( self.Owner )
	
		//local tbl = { Name = v, Ents = postbl }
		
		//datastream.StreamToClients( { self.Owner }, "ItemPlacerSynch", tbl )
		
	end

end

if CLIENT then

	function SWEP:DrawHUD()

		draw.SimpleText( "PRIMARY FIRE: Place Item          SECONDARY FIRE: Change Item Type          +USE: Delete Nearest Item Of Current Type          RELOAD: Remove All Of Current Item Type", "Trebuchet24", ScrW() * 0.5, ScrH() - 120, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		draw.SimpleText( "CURRENT ITEM TYPE: "..self.ItemTypes[ self.Weapon:GetNW2Int( "ItemType", 1 ) ], "Trebuchet24", ScrW() * 0.5, ScrH() - 100, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		for k, v in pairs( ClientItemPlacerTbl ) do
			for c, d in pairs( v ) do
				local pos = d:ToScreen()
				if pos.visible then
					draw.SimpleText( "info_wos_itemspawn", "Trebuchet24", pos.x, pos.y - 15, Color(80,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
					draw.RoundedBox( 0, pos.x - 2, pos.y - 2, 4, 4, Color(255,255,255) )
				end
			end
		end
		
	end

end


net.Receive( "ItemPlacerSynch", function( len )

	ClientItemPlacerTbl[ net.ReadString() ] = net.ReadTable()
	
end )

net.Receive( "CategorySynch", function( len )
	
	SpawnedCategories= net.ReadTable()
	
end )

--[[function PlacerSynch( handler, id, encoded, decoded )

	ClientItemPlacerTbl[ decoded.Name ] = decoded.Ents

end
datastream.Hook( "ItemPlacerSynch", PlacerSynch )]]

function SWEP:Deploy()

	if SERVER then
	
		self.Weapon:Synch()
	
	end

	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
	
	return true
	
end  

function SWEP:Think()	

	if CLIENT then return end

	if self.Owner:KeyDown( IN_USE ) and ( ( self.NextDel or 0 ) < CurTime() ) then
	
		self.NextDel = CurTime() + 1
		
		local tr = util.TraceLine( util.GetPlayerTrace( self.Owner ) )
		
		local closest
		local dist = 1000
		
		for k,v in pairs( ents.FindByClass( self.ItemTypes[ self.Weapon:GetNW2Int( "ItemType", 1 ) ] ) ) do
		
			if v:GetPos():Distance( tr.HitPos ) < dist then
			
				dist = v:GetPos():Distance( tr.HitPos )
				closest = v
			
			end
		
		end
		
		if IsValid( closest ) then
		
			closest:Remove()
			
			self.Owner:EmitSound( self.Primary.Delete1 )
			
			self.Weapon:Synch()
		
		end
		
	end

end

function SWEP:Reload()

	if CLIENT then return end
	
	for k,v in pairs( ents.FindByClass( self.ItemTypes[ self.Weapon:GetNW2Int( "ItemType", 1 ) ] ) ) do
	
		v:Remove()
	
	end
	
	self.Weapon:Synch()
	
	self.Owner:EmitSound( self.Primary.Delete )
	
end

function SWEP:Holster()

	return true

end

function SWEP:ShootEffects()	
	
	self.Owner:MuzzleFlash()								
	self.Owner:SetAnimation( PLAYER_ATTACK1 )	
	
	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK ) 
	
end

function SWEP:PlaceItem()

	local itemtype = self.ItemTypes[ self.Weapon:GetNW2Int( "ItemType", 1 ) ]
	
	local tr = util.TraceLine( util.GetPlayerTrace( self.Owner ) )
	
	local ent = ents.Create( itemtype )
	ent:SetPos( tr.HitPos + tr.HitNormal * 5 )
	ent:Spawn()
	ent.AdminPlaced = true
	local WriteCategories = {}
	for slot, val in pairs( SpawnedCategories ) do
		WriteCategories[ slot ] = ( val == 1 )
	end
	ent.SpawnCategories = table.Copy( WriteCategories )

end

function SWEP:PrimaryAttack()

	self.Weapon:SetNextPrimaryFire( CurTime() + 1 )
	self.Weapon:EmitSound( self.Primary.Sound, 100, math.random(95,105) )
	self.Weapon:ShootEffects()
	
	if SERVER then
	
		self.Weapon:PlaceItem()
		
		self.Weapon:Synch()
		
	end

end

SWEP.CategoryNames = { "Crystals", "Igniters", "Idlers", "Vortex Regulators", "Hilts", "Misc 1", "Misc 2", "Blueprints", "Raw Materials" }

local Options
function SWEP:SecondaryAttack()
	if CLIENT then
		if IsValid( Options ) then return end
		gui.EnableScreenClicker( true )
		Options = vgui.Create( "DFrame" )
		Options:SetSize( ScrW()*0.2, ScrH()*0.2 )
		Options:SetTitle( "Allowed Items" )
		Options:Center()

		local omenu = vgui.Create( "DScrollPanel", Options )
		omenu:SetSize( ScrW()*0.2, ScrH()*0.2*0.95 )
		omenu:SetPos( 0, ScrH()*0.05*0.2 )
		omenu.Paint = nil

		local posx, posy = ScrW()*0.2*0.05, ScrH()*0.2*0.13
		local offsety = ScrH()*0.2*0.005
		for i=1, 9 do
			local l = vgui.Create( "DCheckBox", omenu )
			l:SetSize( 16, 16 )
			l:SetPos( posx + ScrW()*0.2*0.8, posy )
			l:SetColor( color_black )
			//l:SetText( self.CategoryNames[ i ] )
			l.ID = i
			l:SetChecked( SpawnedCategories[ l.ID ] == 1 )
			l.OnChange = function( pan, val )
				if val then
					SpawnedCategories[pan.ID] = 1
				else
					SpawnedCategories[pan.ID] = 0
				end
			end

			local l2 = vgui.Create( "DLabel", omenu )
			l2:SetPos( posx, posy )
			l2:SetColor( color_white )
			l2:SetText( self.CategoryNames[ i ] )
			l2:SizeToContents()
			
			posy = posy + 16 + offsety
		end
		Options.OnClose = function( pan )
			net.Start( "CategorySynch" )
				net.WriteTable( SpawnedCategories )
			net.SendToServer()
			gui.EnableScreenClicker( false )
			Options = nil
		end
	end
--[[
	self.Weapon:SetNextSecondaryFire( CurTime() + 0.5 )
	
	self.Weapon:EmitSound( self.Primary.Swap )
	
	if SERVER then
	
		self.Weapon:SetNW2Int( "ItemType", self.Weapon:GetNW2Int( "ItemType", 1 ) + 1 )
		
		if self.Weapon:GetNW2Int( "ItemType", 1 ) > #self.ItemTypes then
		
			self.Weapon:SetNW2Int( "ItemType", 1 )
		
		end
	
	end
	]]--
end
