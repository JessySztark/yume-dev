local ITEM = {} 
ITEM.Rarity = 100

ITEM.Name = "Unstable Crystal ( Red )"

ITEM.Description = "A broken crystal, giving an unsteady blade"

ITEM.Type = WOSTYPE.CRYSTAL

--Add user groups that are allowed to use this tree. If anyone is allowed, set this to FALSE ( TREE.UserGroups = false )
ITEM.UserGroups = false

--Does this item disappear from the inventory after it's been applied?
ITEM.BurnOnUse = false

ITEM.Model = "models/venator/venator_kybercrystal_wos_red.mdl"
ITEM.Rarity = 5

ITEM.OnEquip = function( wep )
	wep.CustomSettings[ "Blade" ] = "Unstable"
	wep.UseColor = Color( 255, 0, 0 )
end

wOS:RegisterItem( ITEM )