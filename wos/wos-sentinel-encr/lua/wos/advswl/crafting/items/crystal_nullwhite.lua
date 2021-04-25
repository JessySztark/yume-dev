local ITEM = {} 
ITEM.Rarity = 100

ITEM.Name = "Null Refractor ( Unstable )"

ITEM.Description = "Nullifies the output for an injectable beam"

ITEM.Type = WOSTYPE.CRYSTAL

--Add user groups that are allowed to use this tree. If anyone is allowed, set this to FALSE ( TREE.UserGroups = false )
ITEM.UserGroups = false

--Does this item disappear from the inventory after it's been applied?
ITEM.BurnOnUse = true

ITEM.Model = "models/props_combine/breenlight.mdl"

ITEM.OnEquip = function( wep )
	wep.CustomSettings[ "Blade" ] = "Unstable"
	wep.UseColor = Color( 255, 255, 255, 255 )
end

wOS:RegisterItem( ITEM )