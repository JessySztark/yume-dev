local ITEM = {} 
ITEM.Rarity = 100

--The name of the item ( is also an identifier for spawning the item )
ITEM.Name = "Corrupted Crystal ( Blue )"

--The description that appears with the item name
ITEM.Description = "Cracked by the force, it bleeds with it's ignition"

--The category it belongs to
ITEM.Type = WOSTYPE.CRYSTAL

--Add user groups that are allowed to use this tree. If anyone is allowed, set this to FALSE ( TREE.UserGroups = false )
ITEM.UserGroups = false

--Does this item disappear from the inventory after it's been applied?
ITEM.BurnOnUse = false

--The model of the item on the floor / inventory
ITEM.Model = "models/venator/venator_kybercrystal_wos_blue.mdl"

--The chance for the item to appear randomly. 0 = will not spawn, 100 = incredibly high chance
ITEM.Rarity = 5

--The raw materials you will receive from this item when dismantled in the construction module
--Set this to FALSE or delete this entry if you don't want to be able to dismantle it
ITEM.DismantleParts = {
	[ "Glass" ] = 30,
	[ "Refined Steel" ] = 1,
}

ITEM.OnEquip = function( wep )
	wep.CustomSettings[ "Blade" ] = "Corrupted"
	wep.UseColor = Color( 0, 0, 255 )
end

wOS:RegisterItem( ITEM )