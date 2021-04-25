local ITEM = {} 
ITEM.Rarity = 100

ITEM.Name = "Dark Saber Swing"

ITEM.Description = "Dark Saber Power Vortex Regulator"

ITEM.Type = WOSTYPE.VORTEX

--Add user groups that are allowed to use this tree. If anyone is allowed, set this to FALSE ( TREE.UserGroups = false )
ITEM.UserGroups = false

--Does this item disappear from the inventory after it's been applied?
ITEM.BurnOnUse = false

ITEM.Model = "models/wos/lct/crafting/power_vortex_regulator.mdl"
ITEM.Rarity = 40

ITEM.OnEquip = function( wep )
	wep.UseSwingSound = "lightsaber/darksaber_swing.wav" 
end

wOS:RegisterItem( ITEM )