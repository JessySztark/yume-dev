--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2020
	
	Contact: www.wiltostech.com
		----------------------------------------]]--








































































wOS = wOS or {}
wOS.ForcePowers = wOS.ForcePowers or {}

wOS.ForcePowers:RegisterNewPower({
			name = "Force Crush Test",
			icon = "CH",
			distance = 600,
			image = "wos/forceicons/charge.png",
			target = 1,
			cooldown = 0,
			manualaim = true,
			description = "LCRUSH",
			action = function( self )
				local ent = self:SelectTargets( 1, 600 )[ 1 ]
				if !IsValid( ent ) or !ent:IsPlayer() then self:SetNextAttack( 0.2 ) return end
				wOS.ALCS.ExecSys:PerformExecution( self.Owner, ent, "Force Crush" )
				self:SetNextAttack( 1 )
				return true
			end
})

wOS.ForcePowers:RegisterNewPower({
			name = "Fighting Chance Test",
			icon = "CH",
			distance = 600,
			image = "wos/forceicons/charge.png",
			target = 1,
			cooldown = 0,
			manualaim = true,
			description = "LCRUSH",
			action = function( self )
				local ent = self:SelectTargets( 1, 600 )[ 1 ]
				if !IsValid( ent ) or !ent:IsPlayer() then self:SetNextAttack( 0.2 ) return end
				wOS.ALCS.ExecSys:PerformExecution( self.Owner, ent, "Fighting Chance" )
				self:SetNextAttack( 1 )
				return true
			end
})

wOS.ForcePowers:RegisterNewPower({
			name = "Head Splitter Test",
			icon = "CH",
			distance = 600,
			image = "wos/forceicons/charge.png",
			target = 1,
			cooldown = 0,
			manualaim = true,
			description = "LCRUSH",
			action = function( self )
				local ent = self:SelectTargets( 1, 600 )[ 1 ]
				if !IsValid( ent ) or !ent:IsPlayer() then self:SetNextAttack( 0.2 ) return end
				wOS.ALCS.ExecSys:PerformExecution( self.Owner, ent, "Head Splitter" )
				self:SetNextAttack( 1 )
				return true
			end
})

wOS.ForcePowers:RegisterNewPower({
			name = "Force Blast Test",
			icon = "CH",
			distance = 600,
			image = "wos/forceicons/charge.png",
			target = 1,
			cooldown = 0,
			manualaim = true,
			description = "LCRUSH",
			action = function( self )
				local ent = self:SelectTargets( 1, 600 )[ 1 ]
				if !IsValid( ent ) or !ent:IsPlayer() then self:SetNextAttack( 0.2 ) return end
				wOS.ALCS.ExecSys:PerformExecution( self.Owner, ent, "Force Blast" )
				self:SetNextAttack( 1 )
				return true
			end
})