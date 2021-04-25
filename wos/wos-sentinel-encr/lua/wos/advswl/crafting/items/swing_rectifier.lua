local ITEM = {} 
ITEM.Rarity = 100

ITEM.Name = "Arc Rectifier"

ITEM.Description = "Converts AC to DC in an arc welder"

ITEM.Type = WOSTYPE.VORTEX

--Add user groups that are allowed to use this tree. If anyone is allowed, set this to FALSE ( TREE.UserGroups = false )
ITEM.UserGroups = false

--Does this item disappear from the inventory after it's been applied?
ITEM.BurnOnUse = false

ITEM.Model = "models/props_lab/tpplug.mdl"
ITEM.Rarity = 40

ITEM.OnEquip = function( wep )
	wep.UseSwingSound = "ambient/fire/mtov_flame2.wav" 
end

wOS:RegisterItem( ITEM )