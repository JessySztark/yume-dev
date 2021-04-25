--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2020
	
	Contact: www.wiltostech.com
		----------------------------------------]]--








































































wOS = wOS or {}

wOS.ForcePowers:RegisterNewPower({
		name = "Saut De Force",
		icon = "L",
		image = "wos/forceicons/leap.png",
		cooldown = 2,
		manualaim = false,
		description = "Sautez plus haut et plus loin grâce à la Force.",
		action = function( self )
			if ( self:GetForce() < 10 || !self.Owner:IsOnGround() ) then return end
			self:SetForce( self:GetForce() - 10 )

			self:SetNextAttack( 0.5 )

			self.Owner:SetVelocity( self.Owner:GetAimVector() * 512 + Vector( 0, 0, 512 ) )

			self:PlayWeaponSound( "lightsaber/force_leap.wav" )

			// Trigger the jump animation, yay
			self:CallOnClient( "ForceJumpAnim", "" )
			return true
		end
})

wOS.ForcePowers:RegisterNewPower({
			name = "Charge",
			icon = "CH",
			distance = 600,
			image = "wos/forceicons/charge.png",
			target = 1,
			cooldown = 0,
			manualaim = false,
			description = "Foncez sur votre ennemis.",
			action = function( self )
				local ent = self:SelectTargets( 1, 600 )[ 1 ]
				if !IsValid( ent ) then self:SetNextAttack( 0.2 ) return end
				if ( self:GetForce() < 20 ) then self:SetNextAttack( 0.2 ) return end
				local newpos = ( ent:GetPos() - self.Owner:GetPos() )
				newpos = newpos / newpos:Length()
				self.Owner:SetLocalVelocity( newpos*700 + Vector( 0, 0, 300 ) )
				self:SetForce( self:GetForce() - 20 )
				self:PlayWeaponSound( "lightsaber/force_leap.wav" )
				self.Owner:SetSequenceOverride( "phalanx_a_s2_t1", 5 )		
				self:SetNextAttack( 1 )
				self.AerialLand = true
				return true
			end
})

wOS.ForcePowers:RegisterNewPower({
		name = "Absorption De Force",
		icon = "A",
		image = "wos/forceicons/eshell.png",
		cooldown = 0,
		description = "Maintenez Click Droit pour vous protéger.",
		action = function( self )
			if ( self:GetForce() < 1 ) then return end
			self:SetForce( self:GetForce() - 0.1 )
			self.Owner:SetNW2Float( "wOS.ForceAnim", CurTime() + 0.6 )
			self:SetNextAttack( 0.3 )
			return true
		end
})
	
wOS.ForcePowers:RegisterNewPower({
		name = "Lancée De Sabre",
		icon = "T",
		image = "wos/forceicons/throw.png",
		cooldown = 0,
		manualaim = false,
		description = "Envoie votre sabre laser qui reviendra vers vous.",
		action = function(self)
			if self:GetForce() < 20 then return end
			self:SetForce( self:GetForce() - 20 )
			self:SetEnabled(false)
			self:SetBladeLength(0)
			self:SetNextAttack( 1 )
			self:GetOwner():DrawWorldModel(false)

			local ent = ents.Create("ent_lightsaber_thrown")
			ent:SetModel(self:GetWorldModel())
			ent:Spawn()
			ent.CustomSettings = table.Copy( self.CustomSettings )
			ent:SetBladeLength(self:GetMaxLength())
			ent:SetMaxLength(self:GetMaxLength())
			ent:SetBladeWidth( self:GetBladeWidth() )
			
			ent:SetCrystalColor(self:GetCrystalColor())
			ent:SetInnerColor( self:GetInnerColor() )
			
			ent:SetDarkInner( self:GetDarkInner() )
			
			ent:SetWorldModel( self:GetWorldModel() )
			ent.SaberThrowDamage = self.SaberThrowDamage			
			local pos = self:GetSaberPosAng()
			ent:SetPos(pos)
			pos = pos + self.Owner:GetAimVector() * 750
			ent:SetEndPos(pos)
			ent:SetOwner(self.Owner)
			return true
		end
}) 

wOS.ForcePowers:RegisterNewPower({
		name = "Soin De Force",
		icon = "H",
		image = "wos/forceicons/heal.png",
		cooldown = 0,
		target = 1,
		manualaim = false,
		description = "Soigne votre cible.",
		action = function( self )
			if ( self:GetForce() < 10 ) then return end
			local foundents = 0

			for k, v in pairs( self:SelectTargets( 1 ) ) do
				if ( !IsValid( v ) ) then continue end
				foundents = foundents + 1
			local ed = EffectData()
			ed:SetOrigin( self:GetSaberPosAng() )
			ed:SetEntity( v )
			util.Effect( "rb655_force_heal", ed, true, true )
				v:SetHealth( math.Clamp( v:Health() + 25, 0, v:GetMaxHealth() ) )
			end

			if ( foundents > 0 ) then
				self:SetForce( self:GetForce() - 3 )
				local tbl = wOS.ALCS.Config.Skills.ExperienceTable[ self.Owner:GetUserGroup() ]
				if not tbl then 
					tbl = wOS.ALCS.Config.Skills.ExperienceTable[ "Default" ].XPPerHeal 
				else 
					tbl = wOS.ALCS.Config.Skills.ExperienceTable[ self.Owner:GetUserGroup() ].XPPerHeal
				end
				self.Owner:AddSkillXP( tbl )
			end
			self.Owner:SetNW2Float( "wOS.ForceAnim", CurTime() + 0.5 )
			self:SetNextAttack( 0.25 )
			return true
		end
}) 

wOS.ForcePowers:RegisterNewPower({
		name = "Soin De Groupe",
		icon = "GH",
		image = "wos/forceicons/group_heal.png",
		cooldown = 0,
		manualaim = false,
		description = "Soigne les personnes autour de vous et vous-même.",
		action = function( self )
			if ( self:GetForce() < 75 ) then return end
			local players = 0
			for _, ply in pairs( ents.FindInSphere( self.Owner:GetPos(), 200 ) ) do
				if not IsValid( ply ) then continue end
				if not ply:IsPlayer() then continue end
				if not ply:Alive() then continue end
				if players >= 8 then break end
				ply:SetHealth( math.Clamp( ply:Health() + 500, 0, ply:GetMaxHealth() ) )
				local ed = EffectData()
				ed:SetOrigin( self:GetSaberPosAng() )
				ed:SetEntity( ply )
				util.Effect( "rb655_force_heal", ed, true, true )		
				players = players + 1				
			end
			self.Owner:SetNW2Float( "wOS.ForceAnim", CurTime() + 0.6 )
			self:SetForce( self:GetForce() - 75 )
			local tbl = wOS.ALCS.Config.Skills.ExperienceTable[ self.Owner:GetUserGroup() ]
			if not tbl then 
				tbl = wOS.ALCS.Config.Skills.ExperienceTable[ "Default" ].XPPerHeal 
			else 
				tbl = wOS.ALCS.Config.Skills.ExperienceTable[ self.Owner:GetUserGroup() ].XPPerHeal
			end
			self.Owner:AddSkillXP( tbl )
			return true
		end
})
	
wOS.ForcePowers:RegisterNewPower({
		name = "Invisibilité",
		icon = "C",
		image = "wos/forceicons/cloak.png",
		cooldown = 0,
		description = "Vous rend invisible pendant 15 secondes.",
		action = function( self )
		if ( self:GetForce() < 50 || !self.Owner:IsOnGround() ) then return end
			if self:GetCloaking() then return end
			self:SetForce( self:GetForce() - 50 )
			self:SetNextAttack( 0.7 )
			self:PlayWeaponSound( "lightsaber/force_leap.wav" )
			self.CloakTime = CurTime() + 15

			self.Owner:SetNoTarget( true )
			local stean = self.Owner:SteamID64()
			local ply = self.Owner
			if timer.Exists( "ALCS_CLOAK_" .. stean ) then
				timer.Destroy( "ALCS_CLOAK_" .. stean )
			end
			timer.Create( "ALCS_CLOAK_" .. stean, 0.5, 20, function()
				if not IsValid( ply ) then
					timer.Destroy( "ALCS_CLOAK_" .. stean )
				end
				if not IsValid( self ) or not ply:Alive() or self.CloakTime < CurTime() then
					timer.Destroy( "ALCS_CLOAK_" .. stean )
					ply:SetNoTarget( false )
				end

				ply:SetNoTarget( ply:GetActiveWeapon() == self )
			end )

			return true
		end
})

wOS.ForcePowers:RegisterNewPower({
		name = "Réflexion de Force",
		icon = "FR",
		image = "wos/forceicons/reflect.png",
		cooldown = 0,
		description = "Renvoie toutes les attaques de votre adversaire",
		action = function( self )
		if ( self:GetForce() < 50 || !self.Owner:IsOnGround() ) then return end
			if self.Owner:GetNW2Float( "ReflectTime", 0 ) >= CurTime() then return end
			self:SetForce( self:GetForce() - 50 )
			self:SetNextAttack( 0.7 )
			self:PlayWeaponSound( "lightsaber/force_leap.wav" )
			self.Owner:SetNW2Float( "ReflectTime", CurTime() + 2 )
			return true
		end
})

wOS.ForcePowers:RegisterNewPower({
		name = "Rage",
		icon = "RA",
		image = "wos/forceicons/icefuse/adrenaline.png",
		cooldown = 0,
		description = "Augmente vos dégats en libérant votre rage",
		action = function( self )
		if ( self:GetForce() < 50 || !self.Owner:IsOnGround() ) then return end
			if self.Owner:GetNW2Float( "RageTime", 0 ) >= CurTime() then return end
			self:SetForce( self:GetForce() - 50 )
			self:SetNextAttack( 0.7 )
			self:PlayWeaponSound( "lightsaber/force_leap.wav" )
			self.Owner:SetNW2Float( "RageTime", CurTime() + 10 )
			return true
		end
})

wOS.ForcePowers:RegisterNewPower({
		name = "Frappe De l'Ombre",
		icon = "SS",
		distance = 30,
		image = "wos/forceicons/cripple.png",
		cooldown = 0,
		target = 1,
		manualaim = false,
		description = "Assène un coup puissant en visant les points vitaux de l'ennemis tout en étant invisible",
		action = function( self )
			if !self:GetCloaking() then return end
			local ent = self:SelectTargets( 1, 30 )[ 1 ]
			if !IsValid( ent ) then self:SetNextAttack( 0.2 ) return end
			if ( self:GetForce() < 50 ) then self:SetNextAttack( 0.2 ) return end
			self.Owner:SetSequenceOverride("b_c3_t2", 1)
			self:SetForce( self:GetForce() - 50 )
			self.Owner:EmitSound( "lightsaber/saber_hit_laser" .. math.random( 1, 4 ) .. ".wav" )
			self.Owner:AnimResetGestureSlot( GESTURE_SLOT_CUSTOM )
			self.Owner:SetAnimation( PLAYER_ATTACK1 )
			ent:TakeDamage( 500, self.Owner, self )
			self.CloakTime = CurTime() + 0.5
			self:SetNextAttack( 0.7 )
			return true
		end
})

wOS.ForcePowers:RegisterNewPower({
		name = "Attraction De Force",
		icon = "PL",
		target = 1,
		description = "Ramène la cible vers vous",
		image = "wos/forceicons/pull.png",
		cooldown = 0,
		manualaim = false,
		action = function( self )
			if ( self:GetForce() < 20 ) then return end
			local ent = self:SelectTargets( 1 )[ 1 ]
			if not IsValid( ent ) then return end
			self:PlayWeaponSound( "lightsaber/force_repulse.wav" )
			local newpos = ( self.Owner:GetPos() - ent:GetPos() )
			newpos = newpos / newpos:Length()
			ent:SetVelocity( newpos*700 + Vector( 0, 0, 300 ) )
			self:SetForce( self:GetForce() - 20 )
			self.Owner:SetNW2Float( "wOS.ForceAnim", CurTime() + 0.3 )
			self:SetNextAttack( 1.5 )
			return true
		end		
})

wOS.ForcePowers:RegisterNewPower({
		name = "Poussée De Force",
		icon = "PH",
		target = 1,
		distance = 150,
		description = "Pousse l'ennemis avec la Force",
		image = "wos/forceicons/push.png",
		cooldown = 0,
		manualaim = false,
		action = function( self )
			if ( self:GetForce() < 20 ) then return end
			local ent = self:SelectTargets( 1 )[ 1 ]
			if not IsValid( ent ) then return end
			self:PlayWeaponSound( "lightsaber/force_repulse.wav" )
			local newpos = ( self.Owner:GetPos() - ent:GetPos() )
			newpos = newpos / newpos:Length()
			ent:SetVelocity( newpos*-700 + Vector( 0, 0, 300 ) )
			self:SetForce( self:GetForce() - 20 )
			self.Owner:SetNW2Float( "wOS.ForceAnim", CurTime() + 0.3 )
			self:SetNextAttack( 1.5 )
			return true
		end			
})

wOS.ForcePowers:RegisterNewPower({
		name = "Frappe D'Éclair",
		icon = "LS",
		distance = 600,
		image = "wos/forceicons/lightningstrike.png",
		cooldown = 0,
		target = 1,
		manualaim = false,
		description = "Une charge d'éclair concentrée puissante",
		action = function( self )
			local ent = self:SelectTargets( 1, 600 )[ 1 ]
			if !IsValid( ent ) then self:SetNextAttack( 0.2 ) return end
			if ( self:GetForce() < 20 ) then self:SetNextAttack( 0.2 ) return end
			self:SetForce( self:GetForce() - 20 )
			
			local ed = EffectData()
			ed:SetOrigin( self:GetSaberPosAng() )
			ed:SetEntity( ent )
			util.Effect( "rb655_force_lighting", ed, true, true )

			local dmg = DamageInfo()
			dmg:SetAttacker( self.Owner || self )
			dmg:SetInflictor( self.Owner || self )
			dmg:SetDamage( 150 )
			ent:TakeDamageInfo( dmg )
			self.Owner:EmitSound( Sound( "npc/strider/fire.wav" ) )
			self.Owner:EmitSound( Sound( "ambient/atmosphere/thunder1.wav" ) )
			if ( !self.SoundLightning ) then
				self.SoundLightning = CreateSound( self.Owner, "lightsaber/force_lightning" .. math.random( 1, 2 ) .. ".wav" )
				self.SoundLightning:Play()
			else
				self.SoundLightning:Play()
			end
			local bullet = {}
			bullet.Num 		= 1
			bullet.Src 		= self.Owner:GetPos() + Vector( 0, 0, 10 )	
			bullet.Dir 		= ( ent:GetPos() - ( self.Owner:GetPos() + Vector( 0, 0, 10 ) ) )
			bullet.Spread 	= 0		
			bullet.Tracer	= 1
			bullet.Force	= 0						
			bullet.Damage	= 0
			bullet.AmmoType = "Pistol"
			bullet.Entity = self.Owner
			bullet.TracerName = "thor_thunder"
			self:SetNextAttack( 2 )
			self.Owner:FireBullets( bullet )
			timer.Create( "test" .. self:EntIndex(), 0.2, 1, function() if ( self.SoundLightning ) then self.SoundLightning:Stop() self.SoundLightning = nil end end )
			return true
		end
})
wOS.ForcePowers:RegisterNewPower({
		name = "Invisibilté avancé",
		icon = "AC",
		image = "wos/forceicons/advanced_cloak.png",
		cooldown = 0,
		manualaim = false,
		description = "Shrowd yourself with the force for 25 seconds",
		action = function( self )
		if ( self:GetForce() < 50 || !self.Owner:IsOnGround() ) then return end
			if self:GetCloaking() then return end
			self:SetForce( self:GetForce() - 50 )
			self:SetNextAttack( 0.7 )
			self:PlayWeaponSound( "lightsaber/force_leap.wav" )
			self.CloakTime = CurTime() + 45

			self.Owner:SetNoTarget( true )
			local stean = self.Owner:SteamID64()
			local ply = self.Owner
			if timer.Exists( "ALCS_CLOAK_" .. stean ) then
				timer.Destroy( "ALCS_CLOAK_" .. stean )
			end
			timer.Create( "ALCS_CLOAK_" .. stean, 0.5, 50, function()
				if not IsValid( ply ) then
					timer.Destroy( "ALCS_CLOAK_" .. stean )
				end
				if not IsValid( self ) or not ply:Alive() or self.CloakTime < CurTime() then
					timer.Destroy( "ALCS_CLOAK_" .. stean )
					ply:SetNoTarget( false )
				end

				ply:SetNoTarget( ply:GetActiveWeapon() == self )
			end )

			return true
		end
})

wOS.ForcePowers:RegisterNewPower({
		name = "Éclair De Force",
		icon = "L",
		target = 1,
		image = "wos/forceicons/lightning.png",
		cooldown = 0,
		manualaim = false,
		description = "Torture les personnes et monstres à volonté.",
		action = function( self )
			if ( self:GetForce() < 1 ) then return end

			local foundents = 0
			for id, ent in pairs( self:SelectTargets( 1 ) ) do
				if ( !IsValid( ent ) ) then continue end

				foundents = foundents + 1
				local ed = EffectData()
				ed:SetOrigin( self:GetSaberPosAng() )
				ed:SetEntity( ent )
				util.Effect( "rb655_force_lighting", ed, true, true )

				local dmg = DamageInfo()
				dmg:SetAttacker( self.Owner || self )
				dmg:SetInflictor( self.Owner || self )
				dmg:SetDamage( 8 )
				local wep = ent:GetActiveWeapon()
				if IsValid( wep ) and wep.IsLightsaber and wep:GetBlocking() then
					ent:EmitSound( "lightsaber/saber_hit_laser" .. math.random( 1, 4 ) .. ".wav" )
					if wOS.ALCS.Config.EnableStamina then
						wep:AddStamina( -5 )
					else
						wep:SetForce( wep:GetForce() - 1 )
					end
					ent:SetSequenceOverride( "h_block", 0.5 )
				else
					if ent:IsNPC() then dmg:SetDamage( 1.6 ) end
					ent:TakeDamageInfo( dmg )
				end				
			end

			if ( foundents > 0 ) then
				self:SetForce( self:GetForce() - foundents )
				if ( !self.SoundLightning ) then
					self.SoundLightning = CreateSound( self.Owner, "lightsaber/force_lightning" .. math.random( 1, 2 ) .. ".wav" )
					self.SoundLightning:Play()
				else
					self.SoundLightning:Play()
				end

				timer.Create( "test" .. self:EntIndex(), 0.2, 1, function() if ( self.SoundLightning ) then self.SoundLightning:Stop() self.SoundLightning = nil end end )
			end
			self:SetNextAttack( 0.1 )
			return true
		end
})
	
wOS.ForcePowers:RegisterNewPower({
		name = "Combustion De Force",
		icon = "C",
		target = 1,
		description = "Enflamme les choses devant vous.",
		image = "wos/forceicons/combust.png",
		cooldown = 0,
		manualaim = false,
		action = function( self )

			local ent = self:SelectTargets( 1 )[ 1 ]

			if ( !IsValid( ent ) or ent:IsOnFire() ) then self:SetNextAttack( 0.2 ) return end

			local time = math.Clamp( 512 / self.Owner:GetPos():Distance( ent:GetPos() ), 1, 16 )
			local neededForce = math.ceil( math.Clamp( time * 2, 10, 32 ) )

			if ( self:GetForce() < neededForce ) then self:SetNextAttack( 0.2 ) return end

			ent:Ignite( time, 0 )
			self:SetForce( self:GetForce() - neededForce )

			self:SetNextAttack( 1 )
			return true
		end
})

wOS.ForcePowers:RegisterNewPower({
		name = "Répulsion De Force",
		icon = "R",
		image = "wos/forceicons/repulse.png",
		description = "Maintenir pour une meilleur distance/dégats. Pousse tout ce qu'il y a autour de vous.",
		think = function( self )
			if ( self:GetNextSecondaryFire() > CurTime() ) then return end
			if ( self:GetForce() < 1 ) then return end
			if ( !self.Owner:KeyDown( IN_ATTACK2 ) && !self.Owner:KeyReleased( IN_ATTACK2 ) ) then return end
			if ( !self._ForceRepulse && self:GetForce() < 16 ) then return end

			if ( !self.Owner:KeyReleased( IN_ATTACK2 ) ) then
				if ( !self._ForceRepulse ) then self:SetForce( self:GetForce() - 16 ) self._ForceRepulse = 1 end

				if ( !self.NextForceEffect or self.NextForceEffect < CurTime() ) then
					local ed = EffectData()
					ed:SetOrigin( self.Owner:GetPos() + Vector( 0, 0, 36 ) )
					ed:SetRadius( 128 * self._ForceRepulse )
					util.Effect( "rb655_force_repulse_in", ed, true, true )

					self.NextForceEffect = CurTime() + math.Clamp( self._ForceRepulse / 20, 0.1, 0.5 )
				end

				self._ForceRepulse = self._ForceRepulse + 0.025
				self:SetForce( self:GetForce() - 0.5 )
				if ( self:GetForce() > 0.99 ) then return end
			else
				if ( !self._ForceRepulse ) then return end
			end

			local maxdist = 128 * self._ForceRepulse

			for i, e in pairs( ents.FindInSphere( self.Owner:GetPos(), maxdist ) ) do
				if ( e == self.Owner ) then continue end

				local dist = self.Owner:GetPos():Distance( e:GetPos() )
				local mul = ( maxdist - dist ) / 256

				local v = ( self.Owner:GetPos() - e:GetPos() ):GetNormalized()
				v.z = 0

				if ( e:IsNPC() && util.IsValidRagdoll( e:GetModel() or "" ) ) then

					local dmg = DamageInfo()
					dmg:SetDamagePosition( e:GetPos() + e:OBBCenter() )
					dmg:SetDamage( 48 * mul )
					dmg:SetDamageType( DMG_GENERIC )
					if ( ( 1 - dist / maxdist ) > 0.8 ) then
						dmg:SetDamageType( DMG_DISSOLVE )
						dmg:SetDamage( e:Health() * 3 )
					end
					dmg:SetDamageForce( -v * math.min( mul * 40000, 80000 ) )
					dmg:SetInflictor( self.Owner )
					dmg:SetAttacker( self.Owner )
					e:TakeDamageInfo( dmg )

					if ( e:IsOnGround() ) then
						e:SetVelocity( v * mul * -2048 + Vector( 0, 0, 64 ) )
					elseif ( !e:IsOnGround() ) then
						e:SetVelocity( v * mul * -1024 + Vector( 0, 0, 64 ) )
					end

				elseif ( e:IsPlayer() && e:IsOnGround() ) then
					e:SetVelocity( v * mul * -2048 + Vector( 0, 0, 64 ) )
				elseif ( e:IsPlayer() && !e:IsOnGround() ) then
					e:SetVelocity( v * mul * -384 + Vector( 0, 0, 64 ) )
				elseif ( e:GetPhysicsObjectCount() > 0 ) then
					for i = 0, e:GetPhysicsObjectCount() - 1 do
						e:GetPhysicsObjectNum( i ):ApplyForceCenter( v * mul * -512 * math.min( e:GetPhysicsObject():GetMass(), 256 ) + Vector( 0, 0, 64 ) )
					end
				end
			end

			local ed = EffectData()
			ed:SetOrigin( self.Owner:GetPos() + Vector( 0, 0, 36 ) )
			ed:SetRadius( maxdist )
			util.Effect( "rb655_force_repulse_out", ed, true, true )

			self._ForceRepulse = nil

			self:SetNextAttack( 1 )

			self:PlayWeaponSound( "lightsaber/force_repulse.wav" )
		end
})

wOS.ForcePowers:RegisterNewPower({
		name = "Tempête De Force",
		icon = "STR",
		image = "wos/forceicons/storm.png",
		cooldown = 0,
		description = "Se charge pendant 2 secondes. Libère une tempête de Force sur vos ennemis.",
		action = function( self )
			if ( self:GetForce() < 100 ) then self:SetNextAttack( 0.2 ) return end
			if self:GetAttackDelay() >= CurTime() then return end
			self:SetForce( self:GetForce() - 100 )
			self.Owner:EmitSound( Sound( "npc/strider/charging.wav" ) )	
			self:SetAttackDelay( CurTime() + 2 )
			local tr = util.TraceLine( util.GetPlayerTrace( self.Owner ) )
			local pos = tr.HitPos + Vector( 0, 0, 600 )		
			local pi = math.pi
			local bullet = {}
			bullet.Num 		= 1
			bullet.Spread 	= 0		
			bullet.Tracer	= 1
			bullet.Force	= 0						
			bullet.Damage	= 500
			bullet.AmmoType = "Pistol"
			bullet.Entity = self.Owner
			bullet.TracerName = "thor_storm"
			timer.Simple( 2, function()
				if not IsValid( self.Owner ) then return end
				self.Owner:EmitSound( Sound( "ambient/atmosphere/thunder1.wav" ) )
				bullet.Src 		= pos
				bullet.Dir 		= Vector( 0, 0, -1 )
				self.Owner:EmitSound( Sound( "npc/strider/fire.wav" ) )
				self.Owner:FireBullets( bullet )
				timer.Simple( 0.1, function() 
					if not IsValid( self.Owner ) then return end
					bullet.Src 		= pos + Vector( 65*math.sin( pi*2/5 ), 65*math.cos( pi*2/5 ), 0 )
					bullet.Dir 		= Vector( 0, 0, -1 )
					self.Owner:EmitSound( Sound( "npc/strider/fire.wav" ) )
					self.Owner:FireBullets( bullet )			
				end )
				timer.Simple( 0.2, function() 
					if not IsValid( self.Owner ) then return end
					bullet.Src 		= pos + Vector( 65*math.sin( pi*4/5 ), 65*math.cos( pi*4/5 ), 0 )
					bullet.Dir 		= Vector( 0, 0, -1 )
					self.Owner:EmitSound( Sound( "npc/strider/fire.wav" ) )
					self.Owner:FireBullets( bullet )				
				end )
				timer.Simple( 0.3, function()
					if not IsValid( self.Owner ) then return end
					bullet.Src 		= pos + Vector( 65*math.sin( pi*6/5 ), 65*math.cos( pi*6/5 ), 0 )
					bullet.Dir 		= Vector( 0, 0, -1 )
					self.Owner:EmitSound( Sound( "npc/strider/fire.wav" ) )
					self.Owner:FireBullets( bullet )					
				end )
				timer.Simple( 0.4, function() 
					if not IsValid( self.Owner ) then return end
					bullet.Src 		= pos + Vector( 65*math.sin( pi*8/5 ), 65*math.cos( pi*8/5 ), 0 )
					bullet.Dir 		= Vector( 0, 0, -1 )
					self.Owner:EmitSound( Sound( "npc/strider/fire.wav" ) )
					self.Owner:FireBullets( bullet )					
				end )
				timer.Simple( 0.5, function() 
					if not IsValid( self.Owner ) then return end
					bullet.Src 		= pos + Vector( 65*math.sin( 2*pi ), 65*math.cos( 2*pi ), 0 )
					bullet.Dir 		= Vector( 0, 0, -1 )
					self.Owner:EmitSound( Sound( "npc/strider/fire.wav" ) )
					self.Owner:FireBullets( bullet )					
				end )
			end )
			return true
		end
})
	
wOS.ForcePowers:RegisterNewPower({
		name = "Méditation",
		icon = "M",
		image = "wos/forceicons/meditate.png",
		description = "Relaxez-vous pour vous soigner et afin de déployer une grande puissance.",
		think = function( self )
			if self.MeditateCooldown and self.MeditateCooldown >= CurTime() then return end
			if ( self.Owner:KeyDown( IN_ATTACK2 ) ) and !self:GetEnabled() and self.Owner:OnGround() then
				self._ForceMeditating = true
			else
				self._ForceMeditating = false
			end
			if self._ForceMeditating then
				self:SetMeditateMode( 1 )
				if not self._NextMeditateHeal then self._NextMeditateHeal = 0 end
				if self._NextMeditateHeal < CurTime() then
					self.Owner:SetHealth( math.min( self.Owner:Health() + ( self.Owner:GetMaxHealth()*0.01 ), self.Owner:GetMaxHealth() ) )
					if #self.DevestatorList > 0 then
						self:SetDevEnergy( self:GetDevEnergy() + self.DevCharge )
					end
					local tbl = wOS.ALCS.Config.Skills.ExperienceTable[ self.Owner:GetUserGroup() ]
					if not tbl then 
						tbl = wOS.ALCS.Config.Skills.ExperienceTable[ "Default" ].Meditation 
					else 
						tbl = wOS.ALCS.Config.Skills.ExperienceTable[ self.Owner:GetUserGroup() ].Meditation 
					end
					self.Owner:AddSkillXP( tbl )
					self._NextMeditateHeal = CurTime() + 3
				end
				self.Owner:SetLocalVelocity(Vector(0, 0, 0))
				self.Owner:SetMoveType(MOVETYPE_NONE)
			else
				self:SetMeditateMode( 0 )
				if self:GetMoveType() != MOVETYPE_WALK and self.Owner:GetNW2Float( "wOS.DevestatorTime", 0 ) < CurTime() then
					self.Owner:SetMoveType(MOVETYPE_WALK)
				end
			end
			if self.Owner:KeyReleased( IN_ATTACK2 ) then
				self.MeditateCooldown = CurTime() + 3
			end
		end
})

wOS.ForcePowers:RegisterNewPower({
		name = "Canalisation",
		icon = "HT",
		image = "wos/forceicons/channel_hatred.png",
		description = "Concentrez votre haine pour vous soigner et emmagasinez là afin de déployer une grande puissance",
		think = function( self )
			if self.ChannelCooldown and self.ChannelCooldown >= CurTime() then return end
			if ( self.Owner:KeyDown( IN_ATTACK2 ) ) and !self:GetEnabled() and self.Owner:OnGround() then
				self._ForceChanneling = true
			else
				self._ForceChanneling = false
			end
			if self.Owner:KeyReleased( IN_ATTACK2 ) then
				self.ChannelCooldown = CurTime() + 3
			end
			if self._ForceChanneling then
				if not self._NextChannelHeal then self._NextChannelHeal = 0 end
				self:SetMeditateMode( 2 )
				if self._NextChannelHeal < CurTime() then
					self.Owner:SetHealth( math.min( self.Owner:Health() + ( self.Owner:GetMaxHealth()*0.01 ), self.Owner:GetMaxHealth() ) )
					if #self.DevestatorList > 0 then
						self:SetDevEnergy( self:GetDevEnergy() + self.DevCharge )
					end
					local tbl = wOS.ALCS.Config.Skills.ExperienceTable[ self.Owner:GetUserGroup() ]
					if not tbl then 
						tbl = wOS.ALCS.Config.Skills.ExperienceTable[ "Default" ].Meditation 
					else 
						tbl = wOS.ALCS.Config.Skills.ExperienceTable[ self.Owner:GetUserGroup() ].Meditation 
					end
					self.Owner:AddSkillXP( tbl )
					self._NextChannelHeal = CurTime() + 3
				end
				self.Owner:SetLocalVelocity(Vector(0, 0, 0))
				self.Owner:SetMoveType(MOVETYPE_NONE)
				if ( !self.SoundChanneling ) then
					self.SoundChanneling = CreateSound( self.Owner, "ambient/levels/citadel/field_loop1.wav" )
					self.SoundChanneling:Play()
				else
					self.SoundChanneling:Play()
				end

				timer.Create( "test" .. self:EntIndex(), 0.2, 1, function() if ( self.SoundChanneling ) then self.SoundChanneling:Stop() self.SoundChanneling = nil end end )
			else
				self:SetMeditateMode( 0 )
				if self:GetMoveType() != MOVETYPE_WALK and self.Owner:GetNW2Float( "wOS.DevestatorTime", 0 ) < CurTime() then
					self.Owner:SetMoveType(MOVETYPE_WALK)
				end
			end
			if self.Owner:KeyReleased( IN_ATTACK2 ) then
				self.ChannelCooldown = CurTime() + 3
			end			
		end
})
