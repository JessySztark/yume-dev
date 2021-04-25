local ITEM = {} 
ITEM.Rarity = 100

ITEM.Name = "Sith Igniter"

ITEM.Description = "Sith Crystal Activator"

ITEM.Type = WOSTYPE.IGNITER

--Add user groups that are allowed to use this tree. If anyone is allowed, set this to FALSE ( TREE.UserGroups = false )
ITEM.UserGroups = false

--Does this item disappear from the inventory after it's been applied?
ITEM.BurnOnUse = false

ITEM.Model = "models/wos/lct/crafting/sparkplug.mdl"
ITEM.Rarity = 60

ITEM.OnEquip = function( wep )
	wep.UseOnSound = "lightsaber/saber_on2.wav"
	wep.UseOffSound = "lightsaber/saber_off2.wav"
end

wOS:RegisterItem( ITEM )