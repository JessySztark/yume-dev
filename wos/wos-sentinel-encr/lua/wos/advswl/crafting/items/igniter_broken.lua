local ITEM = {} 
ITEM.Rarity = 100

ITEM.Name = "Broken Igniter"

ITEM.Description = "Strange burst of energy when ignition is called"

ITEM.Type = WOSTYPE.IGNITER

--Add user groups that are allowed to use this tree. If anyone is allowed, set this to FALSE ( TREE.UserGroups = false )
ITEM.UserGroups = false

--Does this item disappear from the inventory after it's been applied?
ITEM.BurnOnUse = false

ITEM.Model = "models/wos/lct/crafting/sparkplug.mdl"
ITEM.Rarity = 50

ITEM.OnEquip = function( wep )
	wep.UseOnSound = "beams/beamstart5.wav"
	wep.UseOffSound = "weapons/physgun_off.wav"
end

wOS:RegisterItem( ITEM )