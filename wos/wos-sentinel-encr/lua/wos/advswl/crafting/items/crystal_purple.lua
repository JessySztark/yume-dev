local ITEM = {} 
ITEM.Rarity = 100

ITEM.Name = "Crystal ( Purple )"

ITEM.Description = "Basic Crystal"

ITEM.Type = WOSTYPE.CRYSTAL

--Add user groups that are allowed to use this tree. If anyone is allowed, set this to FALSE ( TREE.UserGroups = false )
ITEM.UserGroups = false

--Does this item disappear from the inventory after it's been applied?
ITEM.BurnOnUse = false

ITEM.Model = "models/venator/venator_kybercrystal_wos_purple.mdl"

--The chance for the item to appear randomly. 0 = will not spawn, 100 = incredibly high chance
ITEM.Rarity = 15

ITEM.OnEquip = function( wep )
	wep.UseColor = Color( 255, 0, 255 )
end

wOS:RegisterItem( ITEM )