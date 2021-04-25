local ITEM = {} 
ITEM.Rarity = 100

ITEM.Name = "Heavy Igniter"

ITEM.Description = "Heavy Crystal Activator"

ITEM.Type = WOSTYPE.IGNITER

--Add user groups that are allowed to use this tree. If anyone is allowed, set this to FALSE ( TREE.UserGroups = false )
ITEM.UserGroups = false

--Does this item disappear from the inventory after it's been applied?
ITEM.BurnOnUse = false

ITEM.Model = "models/wos/lct/crafting/sparkplug.mdl"
ITEM.Rarity = 50

ITEM.OnEquip = function( wep )
	wep.UseOnSound = "lightsaber/saber_on3.wav"
	wep.UseOffSound = "lightsaber/saber_off3.wav"
end

wOS:RegisterItem( ITEM )