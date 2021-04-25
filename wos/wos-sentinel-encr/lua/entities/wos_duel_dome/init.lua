
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

function ENT:Initialize()
	
	self.Entity:SetMoveType( MOVETYPE_NONE )
	self.Entity:SetSolid( SOLID_NONE )
	
	self.Entity:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
	self.Entity:DrawShadow( false )	
	self.Entity:Activate()
	
	self:SetRadius( 1000 )
	self:SetStarted( false )
	self:SetHasStarted( false )
	self:SetTimeLimit( 0 )
	self:SetRival( NULL )
	self:SetDuelist( NULL )
	self:SetTitle( "Duel Dome " .. self:EntIndex() )
	self.LastVal = 0

end

function ENT:Think()
	
	if not self:GetStarted() then return end

	local ply1 = self:GetDuelist()
	local ply2 = self:GetRival()
	
	local players = player.GetAll()
	for i=1, #player.GetAll() do
		local ply = player.GetAll()[i]
		if not IsValid( ply ) then continue end
		if ply == ply1 or ply == ply2 then continue end
		local pos1 = ply:GetPos()
		local pos2 = self:GetPos()
		local dist = pos1:DistToSqr( pos2 )
		if dist <= ( self:GetRadius()^2 + 100 ) then
			ply:SetVelocity( ( pos1 - pos2 + Vector( 0, 0, 30 ) ):GetNormalized()*1000 )
		end
	end
	
	if not self:GetHasStarted() then

		if not ply1:IsValid() or not ply2:IsValid() then return end
		if self.IntroTime and self.IntroLooped then
			ply1:Freeze( true )
			ply2:Freeze( true )
			if self.IntroTime - CurTime() < 0 then
				if self.IntroLooped < 2 then
					local item = wOS.ALCS.Dueling.Spirits[ ply1.WOS_DuelData.DuelSpirit ]
					if item then
						ply1:SetSequenceOverride( item.Sequence, 6 )
					end
					item = wOS.ALCS.Dueling.Spirits[ ply2.WOS_DuelData.DuelSpirit ]
					if item then
						ply2:SetSequenceOverride( item.Sequence, 6 )
					end
					self.IntroTime = CurTime() + 6
					self.IntroLooped = self.IntroLooped  + 1
				else
					self:SetTimeLimit( self:GetTimeLimit() + 2 )
					self:SetHasStarted( true )
					ply1:Freeze( false )
					ply2:Freeze( false )
				end
			end
		end
		
	else
	
		if not ply1:IsValid() or not ply2:IsValid() then 
			wOS.ALCS.Dueling:EndDuel( self, ply1, ply2, true )
			return 
		end
		
		if self.BladesOnly then
			local wep = ply1:GetActiveWeapon()
			if !IsValid( wep ) or not wep.IsLightsaber or not wep.PersonalLightsaber then
				wOS.ALCS.Dueling:EndDuel( self, ply1, ply2 )
				return 
			end
			wep = ply2:GetActiveWeapon()
			if !IsValid( wep ) or not wep.IsLightsaber or not wep.PersonalLightsaber then
				wOS.ALCS.Dueling:EndDuel( self, ply1, ply2 )
				return 
			end
		end
			
		if self:GetPos():DistToSqr( ply1:GetPos() ) > self:GetRadius()^2 then
			ply1:SetVelocity( ( self:GetPos() - ply1:GetPos() + Vector( 0, 0, 30 ) ):GetNormalized()*1000 )
		end
		
		if self:GetPos():DistToSqr( ply2:GetPos() ) > self:GetRadius()^2 then
			ply2:SetVelocity( ( self:GetPos() - ply2:GetPos() + Vector( 0, 0, 30 ) ):GetNormalized()*1000 )
		end
	
		if ply1:GetExecuted() or ply2:GetExecuted() then return end
		
		if not ply1:Alive() or not ply2:Alive() then
			wOS.ALCS.Dueling:EndDuel( self, ply1, ply2 )
			return 		
		end		
	
		if self:GetTimeLimit() - CurTime() < 0 then
			wOS.ALCS.Dueling:EndDuel( self, ply1, ply2, true )
			return 
		end

	
	end
end

function ENT:OnRemove()

end

function ENT:ReInitialize()
	self:SetStarted( false )
	self:SetHasStarted( false )
	self:SetTimeLimit( 0 )
	self:SetRival( NULL )
	self:SetDuelist( NULL )
end

function ENT:UpdateTransmitState()

	return TRANSMIT_ALWAYS
	
end