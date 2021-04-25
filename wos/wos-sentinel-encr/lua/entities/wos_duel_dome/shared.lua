ENT.Type = 			"anim"
ENT.Base 			= "base_anim"


function ENT:SetupDataTables()

	self:NetworkVar( "String", 0, "Title" )

	self:NetworkVar( "Int", 0, "MaxDuelHealth" )
	
	self:NetworkVar( "Entity", 0, "Rival" )
	self:NetworkVar( "Entity", 1, "Duelist" )
	
	self:NetworkVar( "Bool", 0, "Started" )
	self:NetworkVar( "Bool", 1, "HasStarted" )

	self:NetworkVar( "Float", 0, "Radius" )
	self:NetworkVar( "Float", 1, "TimeLimit" )
	self:NetworkVar( "Float", 2, "Stake" )
	
end
