local ITEM = {} 
ITEM.Rarity = 100

ITEM.Name = "Hyperball"

ITEM.Description = "Overcharges the igniter for a more pronounced beam"

ITEM.Type = WOSTYPE.MISC1

--Add user groups that are allowed to use this tree. If anyone is allowed, set this to FALSE ( TREE.UserGroups = false )
ITEM.UserGroups = false

--Does this item disappear from the inventory after it's been applied?
ITEM.BurnOnUse = false

ITEM.Model = "models/maxofs2d/hover_rings.mdl"

ITEM.OnEquip = function( wep )
	wep.UseLength = wep.UseLength + wep.UseLength*0.25
	wep.UseWidth = wep.UseWidth + wep.UseWidth*0.25
end

wOS:RegisterItem( ITEM )