local ITEM = {} 
ITEM.Rarity = 100

ITEM.Name = "Focal Idler"

ITEM.Description = "A focused hum of a saber crafted long ago"

ITEM.Type = WOSTYPE.IDLE

--Add user groups that are allowed to use this tree. If anyone is allowed, set this to FALSE ( TREE.UserGroups = false )
ITEM.UserGroups = false

--Does this item disappear from the inventory after it's been applied?
ITEM.BurnOnUse = false

ITEM.Model = "models/wos/lct/crafting/idle_generator.mdl"

ITEM.OnEquip = function( wep )
	wep.UseLoopSound = "lightsaber/saber_loop3.wav"
end

wOS:RegisterItem( ITEM )