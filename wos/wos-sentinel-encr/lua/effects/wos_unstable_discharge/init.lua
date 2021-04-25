
function EFFECT:Init( data )
	local pos = data:GetOrigin()
	local dir = data:GetNormal()
	local len = data:GetRadius()
	local color = data:GetAngles()
	local emitter = ParticleEmitter( pos )

	local number_lol = 1

	if ( !emitter ) then return end

	for i = 0, len / number_lol do
		local pos2 = pos + dir * ( len - i * number_lol )
		--local particle = emitter:Add( "effects/muzzleflash"..math.random(1,4), pos2 )
		local particle = emitter:Add( "effects/muzzleflash"..math.random(1,4), pos2 )
		if ( particle ) then
			
			local velocity = pos2 - pos
			local angle = velocity:Angle()
			
			particle:SetLifeTime( 0 )
			particle:SetDieTime( 0.3 )

			particle:SetGravity( vector_origin )
			particle:SetVelocity( velocity )

			particle:SetStartSize( 2 )
			particle:SetEndSize( 0 )

			particle:SetStartAlpha( math.random( 100, 200 )/8 )
			particle:SetEndAlpha( 0 )
		
			
			particle:SetColor( color.p, color.y, color.r )
			particle:SetAngleVelocity( angle )
			//particle:SetLighting( true )
		end
	end

	emitter:Finish()
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end
