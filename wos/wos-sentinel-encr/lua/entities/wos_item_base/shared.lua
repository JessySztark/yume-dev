ENT.Type 		= "anim"
ENT.PrintName	= "Modular Item Base"
ENT.Author		= "King David"
ENT.Contact		= ""
ENT.Category = "wiltOS Technologies"
ENT.Spawnable			= false
ENT.AdminSpawnable		= false

function ENT:SetupDataTables()
	self:NetworkVar( "String", 0, "ItemName" )
	self:NetworkVar( "String", 1, "ItemDescription" )
	self:NetworkVar( "String", 2, "RarityName" )
	self:NetworkVar( "Int", 0, "ItemType" )
	self:NetworkVar( "Int", 1, "Amount" )
	self:NetworkVar( "Vector", 0, "RColor" )
end

