--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2020
	
	Contact: www.wiltostech.com
		
----------------------------------------]]--

local meta = FindMetaTable( "Player" )
function meta:GetDuelDome()
	return self:GetNWEntity( "DuelDome", NULL )
end

function meta:DuelHealth()
	return self:GetNWInt( "DuelHealth", 100 )
end

function meta:GetDuelDown()
	return self:GetNWInt( "DuelDown", 0 )
end
