local ITEM = {} 
ITEM.Rarity = 100

ITEM.Name = "Mossman's Head"

ITEM.Description = "A neat little trinket"

ITEM.Type = WOSTYPE.MISC2

--Add user groups that are allowed to use this tree. If anyone is allowed, set this to FALSE ( TREE.UserGroups = false )
ITEM.UserGroups = false

--Does this item disappear from the inventory after it's been applied?
ITEM.BurnOnUse = false

ITEM.Model = "models/maxofs2d/balloon_mossman.mdl"

ITEM.OnEquip = function( wep )
end

wOS:RegisterItem( ITEM )