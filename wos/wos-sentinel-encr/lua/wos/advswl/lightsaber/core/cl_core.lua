--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2020
	
	Contact: www.wiltostech.com
		----------------------------------------]]--








































































local SWEP = {}

SWEP.Vars = {}

SWEP.PrintName = "Lightsaber Base"
SWEP.Author = "Robotboy655 + King David"
SWEP.Category = "Robotboy655's Weapons"
SWEP.Contact = "robotboy655@gmail.com"
SWEP.Purpose = "To slice off each others limbs and heads."
SWEP.Instructions = "Use the force, Luke."
SWEP.RenderGroup = RENDERGROUP_BOTH

SWEP.LoadDelay = 0
SWEP.RegendSpeed = 1
SWEP.MaxForce = 100
SWEP.ForcePowerList = {}
SWEP.DevestatorList = {}

SWEP.Slot = 0
SWEP.SlotPos = 4

SWEP.Spawnable = false
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false
SWEP.DrawWeaponInfoBox = false

SWEP.ViewModel = "models/weapons/v_crowbar.mdl"
SWEP.WorldModel = "models/sgg/starwars/weapons/w_anakin_ep2_saber_hilt.mdl"
SWEP.ViewModelFOV = 55

SWEP.AlwaysRaised = true

SWEP.BlockInvincibility = false
SWEP.Stance = 1
SWEP.Enabled = false
SWEP.PlayerStances = {}
SWEP.IsLightsaber = true
SWEP.CurStance = 1
SWEP.FPCamTime = 0
SWEP.BlockDrainRate = 0.1
SWEP.DevestatorTime = 0
SWEP.UltimateCooldown = 0
SWEP.StaminaRegenSpeed = 1
SWEP.Cooldowns = {}

killicon.Add( "weapon_lightsaber_wos", "lightsaber/lightsaber_killicon", color_white )

local WepSelectIcon = Material( "lightsaber/selection.png" )
local Size = 96

function SWEP:SetupDataTables()

	self:NetworkVar( "Float", 0, "BladeLength" )
	self:NetworkVar( "Float", 1, "MaxLength" )
	self:NetworkVar( "Float", 2, "BladeWidth" )
	self:NetworkVar( "Float", 3, "Force" )
	self:NetworkVar( "Float", 5, "SecBladeLength" )
	self:NetworkVar( "Float", 6, "SecMaxLength" )
	self:NetworkVar( "Float", 7, "SecBladeWidth" )
	self:NetworkVar( "Float", 8, "DevEnergy" )
	self:NetworkVar( "Float", 9, "FPCamTime" )
	self:NetworkVar( "Float", 10, "Delay" )
	self:NetworkVar( "Float", 11, "BlockDrain" )
	self:NetworkVar( "Float", 12, "ForceCooldown" )
	self:NetworkVar( "Float", 13, "Stamina" )	
	self:NetworkVar( "Float", 14, "AttackDelay" )	
	
	self:NetworkVar( "Bool", 0, "DarkInner" )
	self:NetworkVar( "Bool", 1, "SecDarkInner" )
	self:NetworkVar( "Bool", 2, "Enabled" )
	self:NetworkVar( "Bool", 3, "WorksUnderwater" )
	self:NetworkVar( "Bool", 4, "AnimEnabled" )
	self:NetworkVar( "Bool", 5, "Cloaking" )
	self:NetworkVar( "Bool", 6, "DualMode" )
	self:NetworkVar( "Bool", 7, "Blocking" )
	self:NetworkVar( "Bool", 8, "HonorBound" )
	
	self:NetworkVar( "Int", 0, "ForceType" )
	self:NetworkVar( "Int", 1, "DevestatorType" )
	self:NetworkVar( "Int", 3, "Stance" )
	self:NetworkVar( "Int", 4, "Form" )
	self:NetworkVar( "Int", 5, "MaxForce" )
	self:NetworkVar( "Int", 6, "MaxStamina" )
	self:NetworkVar( "Int", 7, "HiltHoldtype" )
	self:NetworkVar( "Int", 8, "MeditateMode" )
	
	self:NetworkVar( "Vector", 0, "CrystalColor" )
	self:NetworkVar( "Vector", 1, "SecCrystalColor" )
	self:NetworkVar( "Vector", 2, "InnerColor" )
	self:NetworkVar( "Vector", 3, "SecInnerColor" )		
	
	self:NetworkVar( "String", 0, "WorldModel" )
	self:NetworkVar( "String", 1, "SecWorldModel" )
	self:NetworkVar( "String", 2, "OnSound" )
	self:NetworkVar( "String", 3, "OffSound" )
	
	self:NetworkVar( "Entity", 0, "ForceTarget" )
	
end

function SWEP:GenerateThinkFunctions()
	self.ThinkFunctions = {}

end

function SWEP:GenerateAttackFunctions()
	self.AttackFunctions = {}

end

function SWEP:PrimaryAttack()
	if ( !IsValid( self.Owner ) ) then return end
	if self:GetBlocking() then return end
	if self.HeavyCharge then 
		if self.HeavyCharge >= CurTime() then return end
	end
	if ( prone and self.Owner:IsProne() ) then self.Owner:SetAnimation( PLAYER_ATTACK1 ); return end
	
	if not self:GetAnimEnabled() then self.Owner:SetAnimation( PLAYER_ATTACK1 ); return end
end

function SWEP:SecondaryAttack()

end

function SWEP:Reload()

end

function SWEP:GetSaberPosAng( num, side, model )

	num = num or 1
	model = model or self
	local dual = false
	if ( IsValid( self.Owner ) ) then
		local bone = self.Owner:LookupBone( "ValveBiped.Bip01_R_Hand" )
		if self.LeftHilt then
			if model == self.LeftHilt then
				bone = self.Owner:LookupBone( "ValveBiped.Bip01_L_Hand" )
				dual = true
			end
		end
		local attachment = model:LookupAttachment( "blade" .. num )
		if ( side ) then
			attachment = model:LookupAttachment( "quillon" .. num )
		end

		if ( !bone ) then

		end

		if ( attachment && attachment > 0 ) then
			local PosAng = model:GetAttachment( attachment )

			if ( !bone ) then
				PosAng.Pos = PosAng.Pos + Vector( 0, 0, 36 )
				if ( IsValid( self.Owner ) && self.Owner:IsPlayer() && self.Owner:Crouching() ) then PosAng.Pos = PosAng.Pos - Vector( 0, 0, 18 ) end
				PosAng.Ang.p = 0
			end

			return PosAng.Pos, PosAng.Ang:Forward()
		end

		if ( bone ) then
		
			local pos, ang = self.Owner:GetBonePosition( bone )
			if ( pos == self.Owner:GetPos() ) then
				local matrix = self.Owner:GetBoneMatrix( bone )
				if ( matrix ) then
					pos = matrix:GetTranslation()
					ang = matrix:GetAngles()
				end
			end
		
			if !dual then
				ang:RotateAroundAxis( ang:Forward(), 180 )
				ang:RotateAroundAxis( ang:Up(), 30 )
				ang:RotateAroundAxis( ang:Forward(), -5.7 )
				ang:RotateAroundAxis( ang:Right(), 92 )

				pos = pos + ang:Up() * -3.3 + ang:Right() * 0.8 + ang:Forward() * 5.6
				
			else
				ang:RotateAroundAxis( ang:Forward(), -180 )
				ang:RotateAroundAxis( ang:Up(), 0 )
				ang:RotateAroundAxis( ang:Forward(), -5 )
				ang:RotateAroundAxis( ang:Right(), -86 )

				pos = pos - ang:Up() * -3.6 - ang:Right() * 1.1 + ang:Forward() * 6.2			
			end
			
			return pos, ang:Forward()
		end
	end

	local defAng = model:GetAngles()
	defAng.p = 0

	local defPos = model:GetPos() + defAng:Right() * 0.6 - defAng:Up() * 0.2 + defAng:Forward() * 0.8
	defPos = defPos + Vector( 0, 0, 36 )
	if ( IsValid( self.Owner ) && self.Owner:Crouching() ) then defPos = defPos - Vector( 0, 0, 18 ) end

	return defPos, -defAng:Forward()
	
end

function SWEP:GetTargetEntity( dist, num )

	local dsqr = dist*dist
	local t = {}
	local group = player.GetAll()
	table.Add( group, ents.FindByClass( "npc_*" ) )
	local p = {}
	for id, ply in pairs( group ) do
		if ( !ply:GetModel() or ply:GetModel() == "" or ply == self.Owner or ply:Health() < 1 ) then continue end
		
		local wep = ply:GetActiveWeapon()
		if IsValid( wep ) then
			if wep.IsLightsaber then
				if wep:GetCloaking() then continue end
			end
		end
		
		local tr = util.TraceLine( {
			start = self.Owner:GetShootPos(),
			endpos = (ply.GetShootPos && ply:GetShootPos() or ply:GetPos()),
			filter = self.Owner,
		} )

		if ( tr.Entity != ply && IsValid( tr.Entity ) or tr.Entity == game.GetWorld() ) then continue end

		local pos1 = self.Owner:GetPos() + self.Owner:GetAimVector() * dist
		local pos2 = ply:GetPos()

		if ( pos1:DistToSqr( pos2 ) <= dsqr && ply:EntIndex() > 0 ) then
			table.insert( p, { ply = ply, dist = tr.HitPos:DistToSqr( pos2 ) } )
		end
	end

	for id, ply in SortedPairsByMemberValue( p, "dist" ) do
		table.insert( t, ply.ply )
		if ( #t >= num ) then return t end
	end

	return t
	
end

function SWEP:TargetThoughts()

	local target = self:GetForceTarget()
	if not IsValid( target ) then return end
	
	local diff = target:GetPos() - self.Owner:GetPos()
	local ang = ( diff ):Angle()
	local tang = LocalPlayer():EyeAngles()
	tang.y = ang.y
	
	LocalPlayer():SetEyeAngles( tang )
	
end

function SWEP:Holster()

	if self:GetEnabled() then return false end
	if self:GetHonorBound() then return false end
	
	if IsValid( self.LeftHilt ) then
		self.LeftHilt:Remove()
		self.LeftHilt = nil
	end
	
	return true
end

function SWEP:OnRemove()
	if IsValid( self.LeftHilt ) then
		self.LeftHilt:Remove()
		self.LeftHilt = nil
	end	
	return true
end

function SWEP:Deploy()

end


function SWEP:Think()
	--self:TargetThoughts()
end

----OTHER STUFF

function SWEP:GetTargetHoldType()
	--if ( !self:GetEnabled() ) then return "normal" end
	if ( self:GetWorldModel() == "models/weapons/starwars/w_maul_saber_staff_hilt.mdl" ) then return "knife" end
	if ( self:LookupAttachment( "blade2" ) && self:LookupAttachment( "blade2" ) > 0 ) then return "knife" end

	return ( self:GetDualMode() and "knife" ) or "melee2"
end

function SWEP:GetActiveForcePowerType( id )
	local ForcePowers = self.ForcePowers
	return ForcePowers[ id ]
end

function SWEP:GetActiveForcePowers()
	return self.ForcePowers
end

function SWEP:Initialize()
	self.IsLightsaber = true
	self.LoopSound = self.LoopSound or "lightsaber/saber_loop" .. math.random( 1, 8 ) .. ".wav"
	self.SwingSound = self.SwingSound or "lightsaber/saber_swing" .. math.random( 1, 2 ) .. ".wav"
	self:SetWeaponHoldType( self:GetTargetHoldType() )
	
	self.ForcePowers = {}
	self.AvailablePowers = table.Copy( wOS.AvailablePowers )
	local breakoff = wOS.ALCS.Config.LightsaberHUD == WOS_ALCS.HUD.HYBRID
	for _, force in pairs( self.ForcePowerList ) do
		if not self.AvailablePowers[ force ] then continue end
		self.ForcePowers[ #self.ForcePowers + 1 ] = self.AvailablePowers[ force ]
		if not breakoff then continue end
		if #self.ForcePowers >= wOS.ALCS.Config.MaximumForceSlots then break end
	end
	
	self.Devestators = {}
	self.AvailableDevestators = table.Copy( wOS.AvailableDevestators )
	for _, dev in pairs( self.DevestatorList ) do
		if not self.AvailableDevestators[ dev ] then continue end
		self.Devestators[ #self.Devestators + 1 ] = self.AvailableDevestators[ dev ]
	end
	
	self:GenerateThinkFunctions()
	
end

function SWEP:GetActiveDevestators()
	local Devestators = {}
	for id, t in pairs( self.Devestators ) do
		table.insert( Devestators, t )
	end
	return Devestators
end

function SWEP:GetActiveDevestatorType( id )
	local Devestators = self:GetActiveDevestators()
	return Devestators[ id ]
end

function SWEP:DrawWeaponSelection( x, y, w, h, a )
	surface.SetDrawColor( 255, 255, 255, a )
	surface.SetMaterial( WepSelectIcon )

	render.PushFilterMag( TEXFILTER.ANISOTROPIC )
	render.PushFilterMin( TEXFILTER.ANISOTROPIC )

	surface.DrawTexturedRect( x + ( ( w - Size ) / 2 ), y + ( ( h - Size ) / 2.5 ), Size, Size )

	render.PopFilterMag()
	render.PopFilterMin()
end

function SWEP:DrawWorldModel()

end

function SWEP:DrawWorldModelTranslucent()
	
	--Prevents flickering!!
	self.WorldModel = self:GetWorldModel()
	self:SetModel( self:GetWorldModel() )
	
	self:DrawPrimarySaber()
	if self:GetDualMode() then
		self:DrawSecondarySaber()
	end
	
end

function SWEP:DrawPrimarySaber()
	if ( !IsValid( self:GetOwner() ) or halo.RenderedEntity() == self ) then return end
	
	if self:GetCloaking() then 
		local vel = self.Owner:GetVelocity():Length()
		if vel < 130 then return end
		self:SetMaterial("models/shadertest/shader3")
		self:DrawModel()
		return
	end
	
	self:SetMaterial( "" )
	self:DrawModel()

	if self.NoBlade then return end

	local clr = self:GetCrystalColor()
	clr = Color( clr.x, clr.y, clr.z )
	
	local clr_inner = self:GetInnerColor()
	clr_inner = Color( clr_inner.x, clr_inner.y, clr_inner.z )

	local bladesFound = false
	local blades = 0

	for id, t in pairs( self:GetAttachments() ) do
		if ( !string.match( t.name, "blade(%d+)" ) && !string.match( t.name, "quillon(%d+)" ) ) then continue end

		local bladeNum = string.match( t.name, "blade(%d+)" )
		local quillonNum = string.match( t.name, "quillon(%d+)" )

		if ( bladeNum && self:LookupAttachment( "blade" .. bladeNum ) > 0 ) then
			blades = blades + 1
			local pos, dir = self:GetSaberPosAng( bladeNum )
			rb655_RenderBlade_wos( pos, dir, self:GetBladeLength(), self:GetMaxLength(), self:GetBladeWidth(), clr, self:GetDarkInner(), clr_inner, self:EntIndex(), self:GetOwner():WaterLevel() > 2, false, blades, self.CustomSettings )
			bladesFound = true
		end

		if ( quillonNum && self:LookupAttachment( "quillon" .. quillonNum ) > 0 ) then
			blades = blades + 1
			local pos, dir = self:GetSaberPosAng( quillonNum, true )
			rb655_RenderBlade_wos( pos, dir, self:GetBladeLength(), self:GetMaxLength(), self:GetBladeWidth(), clr, self:GetDarkInner(), clr_inner, self:EntIndex(), self:GetOwner():WaterLevel() > 2, true, blades, self.CustomSettings )
		end

	end

	if ( !bladesFound ) then
		local pos, dir = self:GetSaberPosAng()
		rb655_RenderBlade_wos( pos, dir, self:GetBladeLength(), self:GetMaxLength(), self:GetBladeWidth(), clr, self:GetDarkInner(), clr_inner, self:EntIndex(), self:GetOwner():WaterLevel() > 2, nil, nil, self.CustomSettings )
	end
	
end

function SWEP:DrawSecondarySaber()

	if !IsValid( self.LeftHilt ) and self:GetDualMode() then
		self.LeftHilt = ents.CreateClientProp()
		self.LeftHilt:SetModel( self:GetSecWorldModel() )
		self.LeftHilt:Spawn()
		self.LeftHilt:SetNoDraw( true )
	end

	local bone = self.Owner:LookupBone( "ValveBiped.Bip01_L_Hand" )
	local pos, ang = self.Owner:GetBonePosition( bone )
	if ( pos == self.Owner:GetPos() ) then
		local matrix = self.Owner:GetBoneMatrix( 16 )
		if ( matrix ) then
			pos = matrix:GetTranslation()
			ang = matrix:GetAngles()
		end
	end
	
	if self.LeftHilt:GetModel() == "models/donation gauntlet/donation gauntlet.mdl" then	

		ang:RotateAroundAxis( ang:Forward(), 180 )
		ang:RotateAroundAxis( ang:Up(), 30 )
		ang:RotateAroundAxis( ang:Forward(), -5.7 )
		ang:RotateAroundAxis( ang:Right(), -92 )
		pos = pos + ang:Up() * 3.3 + ang:Right() * 0.4 + ang:Forward() * -7

	else
	
		ang:RotateAroundAxis( ang:Forward(), 180 )
		ang:RotateAroundAxis( ang:Up(), 30 )
		ang:RotateAroundAxis( ang:Forward(), -5.7 )
		ang:RotateAroundAxis( ang:Right(), 92 )
		if not self:GetAnimEnabled() then
			ang:RotateAroundAxis( ang:Up(), 180 )
			pos = pos + ang:Up() * -5 + ang:Right() * -1 + ang:Forward() * -7	
		else
			pos = pos + ang:Up() * -3.3 + ang:Right() * 0.4 + ang:Forward() * -7	
		end
	end

	self.LeftHilt:SetPos( pos )
	self.LeftHilt:SetAngles( ang )
	
	local clr = self:GetSecCrystalColor()
	clr = Color( clr.x, clr.y, clr.z )
	
	local clr_inner = self:GetSecInnerColor()
	clr_inner = Color( clr_inner.x, clr_inner.y, clr_inner.z )

	if self:GetCloaking() then
		if self.Owner:GetVelocity():Length() < 130 then
			self.LeftHilt:SetMaterial("models/effects/vol_light001")
			self.LeftHilt:SetColor( Color( 0, 0, 0, 0 ) )
		else
			self.LeftHilt:SetMaterial("models/shadertest/shader3")
			self.LeftHilt:SetColor( Color( 255, 255, 255, 255 ) )
		end	
		return
	end

	self.LeftHilt:DrawModel()
	self.LeftHilt:SetMaterial( "" )
	self.LeftHilt:SetColor( Color( 255, 255, 255, 255 ) )

	if self.SecNoBlade then return end
	
	local bladesFound = false -- true if the model is OLD and does not have blade attachments
	local blades = 0

	for id, t in pairs( self.LeftHilt:GetAttachments() ) do
		if ( !string.match( t.name, "blade(%d+)" ) && !string.match( t.name, "quillon(%d+)" ) ) then continue end

		local bladeNum = string.match( t.name, "blade(%d+)" )
		local quillonNum = string.match( t.name, "quillon(%d+)" )

		if ( bladeNum && self.LeftHilt:LookupAttachment( "blade" .. bladeNum ) > 0 ) then
			blades = blades + 1
			local pos, dir = self:GetSaberPosAng( bladeNum, false, self.LeftHilt )
			rb655_RenderBlade_wos( pos, dir, self:GetSecBladeLength(), self:GetSecMaxLength(), self:GetSecBladeWidth(), clr, self:GetSecDarkInner(), clr_inner, self:EntIndex(), self:GetOwner():WaterLevel() > 2, false, blades, self.SecCustomSettings, true )
			bladesFound = true
		end

		if ( quillonNum && self.LeftHilt:LookupAttachment( "quillon" .. quillonNum ) > 0 ) then
			blades = blades + 1
			local pos, dir = self:GetSaberPosAng( quillonNum, true, self.LeftHilt )
			rb655_RenderBlade_wos( pos, dir, self:GetSecBladeLength(), self:GetSecMaxLength(), self:GetSecBladeWidth(), clr, self:GetSecDarkInner(), clr_inner, self:EntIndex(), self:GetOwner():WaterLevel() > 2, true, blades, self.SecCustomSettings, true )
		end

	end

	if ( !bladesFound ) then
		local pos, dir = self:GetSaberPosAng( nil, nil, self.LeftHilt )
		if not self:GetAnimEnabled() then
			dir = dir*-1
			pos = pos + dir*12 - dir:Angle():Right()*0.8 - dir:Angle():Up()*1.5
		end
		rb655_RenderBlade_wos( pos, dir, self:GetSecBladeLength(), self:GetSecMaxLength(), self:GetSecBladeWidth(), clr, self:GetSecDarkInner(), clr_inner, self:EntIndex(), self:GetOwner():WaterLevel() > 2, nil, nil, self.SecCustomSettings, true )
	end
	
end

surface.CreateFont( "SelectedForceType", {
	font	= "Roboto Cn",
	size	= ScreenScale( 16 ),
	weight	= 600
} )

surface.CreateFont( "SelectedForceHUD", {
	font	= "Roboto Cn",
	size	= ScreenScale( 6 )
} )

SWEP.Vars.grad = Material( "gui/gradient_up" )
SWEP.Vars.matBlurScreen = Material( "pp/blurscreen" )
SWEP.Vars.matBlurScreen:SetFloat( "$blur", 3 )
SWEP.Vars.matBlurScreen:Recompute()

function SWEP.Vars:DrawHUDBox( x, y, w, h, b )

	x = math.floor( x )
	y = math.floor( y )
	w = math.floor( w )
	h = math.floor( h )
	
	surface.SetMaterial( self.matBlurScreen )
	surface.SetDrawColor( 255, 255, 255, 255 )


	render.SetScissorRect( x, y, w + x, h + y, true )
		for i = 0.33, 1, 0.33 do
			self.matBlurScreen:SetFloat( "$blur", 5 * i )
			self.matBlurScreen:Recompute()
			render.UpdateScreenEffectTexture()
			surface.DrawTexturedRect( 0, 0, ScrW(), ScrH() )
		end
	render.SetScissorRect( 0, 0, 0, 0, false )


	surface.SetDrawColor( Color( 0, 0, 0, 128 ) )
	surface.DrawRect( x, y, w, h )

	if ( b ) then
		surface.SetMaterial( self.grad )
		surface.SetDrawColor( Color( 0, 128, 255, 4 ) )
		surface.DrawTexturedRect( x, y, w, h )
	end

end


function SWEP:ViewModelDrawn()

end

function SWEP:DrawHUDTargetSelection()
	local selectedForcePower = self:GetActiveForcePowerType( self:GetForceType() )
	if ( !selectedForcePower ) then return end

	local isTarget = selectedForcePower.target
	local dist = selectedForcePower.distance
	if ( isTarget ) then
		for id, ent in pairs( self:SelectTargets( isTarget, dist ) ) do
			if ( !IsValid( ent ) ) then continue end
			local maxs = ent:OBBMaxs()
			local p = ent:GetPos()
			p.z = p.z + maxs.z

			local pos = p:ToScreen()
			local x, y = pos.x, pos.y
			local size = 16

			surface.SetDrawColor( 255, 0, 0, 255 )
			draw.NoTexture()
			surface.DrawPoly( {
				{ x = x - size, y = y - size },
				{ x = x + size, y = y - size },
				{ x = x, y = y }
			} )
		end
	end
end

SWEP.Vars.ForceBar = 100
SWEP.Vars.StaminaBar = 100
SWEP.Vars.DevBar = 0

function SWEP:DrawHUD()
	if ( !IsValid( self.Owner ) or self.Owner:GetViewEntity() != self.Owner or self.Owner:InVehicle() ) then return end
	
	wOS.ALCS.LightsaberBase:HandleHUD( self )
	self:TargetThoughts()
	//self:DrawHUDTargetSelection()

end

wOS.ALCS.LightsaberBase:AddClientWeapon( SWEP, "wos_adv_single_lightsaber_base" )
wOS.ALCS.LightsaberBase:AddClientWeapon( SWEP, "wos_adv_dual_lightsaber_base" )
