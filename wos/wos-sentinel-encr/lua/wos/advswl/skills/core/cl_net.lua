--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2020
	
	Contact: www.wiltostech.com
		----------------------------------------]]--








































































wOS = wOS or {}
wOS.SkillTrees = wOS.SkillTrees or {}

local PLAYER = LocalPlayer()

net.Receive( "wOS.SkillTree.SendPlayerData", function()

	local equipped_skills = net.ReadTable()
	local localplayer = net.ReadBool()
	
	if localplayer then
		wOS.EquippedSkills = table.Copy( equipped_skills )
	else
		local ply = net.ReadEntity()
		ply.EquippedSkills = table.Copy( equipped_skills )
	end

end )

net.Receive( "wOS.SkillTree.SendWLData", function()

	local whitelist_trees = net.ReadTable()
	local localplayer = net.ReadBool()
	
	if localplayer then
		wOS.SkillTreeWhitelists = table.Copy( whitelist_trees )
	else
		local ply = net.ReadEntity()
		ply.WOS_SkillTreeWhitelists = table.Copy( whitelist_trees )
	end

end )

wOS.TreeIcons = {}
wOS.TreeIcons[ "Help Menu" ] = { MainIcon = Material( "wos/skilltrees/wiltos.png", "unlitgeneric" ) }

net.Receive( "wOS.SkillTree.SendTrees", function()

	local trees = net.ReadTable()

	for name, data in pairs( trees ) do
		wOS.SkillTrees[ name ] = data
		if not wOS.TreeIcons[ name ] then
			wOS.TreeIcons[ name ] = {}
			wOS.TreeIcons[ name ].MainIcon = wOS.ALCS.Skills:PrecacheIcon( "wos-alcs-treename-" .. name, data.TreeIcon )
			for tier, sdata in pairs( data.Tier ) do
				wOS.TreeIcons[ name ][ tier ] = {}
				for skill, info in pairs( sdata ) do
					if info.DummySkill then continue end
					wOS.TreeIcons[ name ][ tier ][ skill ] = {}
					wOS.TreeIcons[ name ][ tier ][ skill ].Icon = wOS.ALCS.Skills:PrecacheIcon( "wos-alcs-skillname-" .. name .. tier .. skill, info.Icon )
				end
			end
		end
	end

end )

net.Receive( "wOS.SkillTree.RefreshWeapon", function()

	local name = net.ReadString()
	local self = LocalPlayer():GetWeapon( name )
	if not IsValid( self ) then return end
	
	self.ForcePowerList = net.ReadTable()
	self.DevestatorList = net.ReadTable()
	
	self.ForcePowers = {}
	self.AvailablePowers = table.Copy( wOS.AvailablePowers )
	local breakoff = wOS.ALCS.Config.LightsaberHUD == WOS_ALCS.HUD.HYBRID
	for _, force in pairs( self.ForcePowerList ) do
		if not self.AvailablePowers[ force ] then continue end
		self.ForcePowers[ #self.ForcePowers + 1 ] = self.AvailablePowers[ force ]
		if !breakoff then continue end
		if #self.ForcePowers >= wOS.ALCS.Config.MaximumForceSlots then break end
	end
	
	self.Devestators = {}
	self.AvailableDevestators = table.Copy( wOS.AvailableDevestators )
	for _, dev in pairs( self.DevestatorList ) do
		if not self.AvailableDevestators[ dev ] then continue end
		self.Devestators[ #self.Devestators + 1 ] = self.AvailableDevestators[ dev ]
	end

end )

net.Receive( "wOS.SkillTree.RefreshForms", function()

	local name = net.ReadString()
	local self = LocalPlayer():GetWeapon( name )
	if not IsValid( self ) then return end
	
	self.Forms = net.ReadTable()
	self.Stances = net.ReadTable()
	self.UseForms = {}
	for _, form in pairs( self.Forms ) do
		self.UseForms[ form ] = true
	end

end )

net.Receive( "wOS.SkillTree.RefreshDualForms", function()

	local name = net.ReadString()
	local self = LocalPlayer():GetWeapon( name )
	if not IsValid( self ) then return end
	
	self.DualFormList = net.ReadTable()

end )