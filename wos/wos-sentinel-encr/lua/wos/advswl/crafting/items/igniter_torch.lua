local ITEM = {} 
ITEM.Rarity = 100

ITEM.Name = "Torch Igniter"

ITEM.Description = "A slightly overcharged igniter for an old welding torch"

ITEM.Type = WOSTYPE.IGNITER

--Add user groups that are allowed to use this tree. If anyone is allowed, set this to FALSE ( TREE.UserGroups = false )
ITEM.UserGroups = false

--Does this item disappear from the inventory after it's been applied?
ITEM.BurnOnUse = false

ITEM.Model = "models/items/combine_rifle_ammo01.mdl"
ITEM.Rarity = 40

ITEM.OnEquip = function( wep )
	wep.UseOnSound = "ambient/fire/ignite.wav"
	wep.UseOffSound = "HL1/ambience/steamburst1.wav"
end

wOS:RegisterItem( ITEM )