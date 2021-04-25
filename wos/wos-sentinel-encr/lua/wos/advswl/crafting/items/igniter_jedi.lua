local ITEM = {} 
ITEM.Rarity = 100

ITEM.Name = "Jedi Igniter"

ITEM.Description = "Jedi Crystal Activator"

ITEM.Type = WOSTYPE.IGNITER

--Add user groups that are allowed to use this tree. If anyone is allowed, set this to FALSE ( TREE.UserGroups = false )
ITEM.UserGroups = false

--Does this item disappear from the inventory after it's been applied?
ITEM.BurnOnUse = false

ITEM.Model = "models/wos/lct/crafting/sparkplug.mdl"
ITEM.Rarity = 60

ITEM.OnEquip = function( wep )
	wep.UseOnSound = "lightsaber/saber_on1.wav"
	wep.UseOffSound = "lightsaber/saber_off1.wav"
end

wOS:RegisterItem( ITEM )