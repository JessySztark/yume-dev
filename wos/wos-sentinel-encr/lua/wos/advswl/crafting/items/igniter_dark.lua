local ITEM = {} 
ITEM.Rarity = 100

ITEM.Name = "Dark Saber Igniter"

ITEM.Description = "Dark Saber Crystal Activator"

ITEM.Type = WOSTYPE.IGNITER

--Add user groups that are allowed to use this tree. If anyone is allowed, set this to FALSE ( TREE.UserGroups = false )
ITEM.UserGroups = false

--Does this item disappear from the inventory after it's been applied?
ITEM.BurnOnUse = false

ITEM.Model = "models/wos/lct/crafting/sparkplug.mdl"
ITEM.Rarity = 40

ITEM.OnEquip = function( wep )
	wep.UseOnSound = "lightsaber/darksaber_on.wav"
	wep.UseOffSound = "lightsaber/darksaber_off.wav"
end

wOS:RegisterItem( ITEM )