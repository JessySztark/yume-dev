local ITEM = {} 
ITEM.Rarity = 100

ITEM.Name = "Sith Swing"

ITEM.Description = "Sith Power Vortex Regulator"

ITEM.Type = WOSTYPE.VORTEX

--Add user groups that are allowed to use this tree. If anyone is allowed, set this to FALSE ( TREE.UserGroups = false )
ITEM.UserGroups = false

--Does this item disappear from the inventory after it's been applied?
ITEM.BurnOnUse = false

ITEM.Model = "models/wos/lct/crafting/power_vortex_regulator.mdl"
ITEM.Rarity = 60

ITEM.OnEquip = function( wep )
	wep.UseSwingSound = "lightsaber/saber_swing2.wav"
end

wOS:RegisterItem( ITEM )