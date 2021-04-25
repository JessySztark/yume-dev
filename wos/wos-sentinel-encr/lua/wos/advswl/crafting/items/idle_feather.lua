local ITEM = {} 
ITEM.Rarity = 100

ITEM.Name = "Feather Stabilizer"

ITEM.Description = "Maintains the feather of an oxy-acetylene welder"

ITEM.Type = WOSTYPE.IDLE

--Add user groups that are allowed to use this tree. If anyone is allowed, set this to FALSE ( TREE.UserGroups = false )
ITEM.UserGroups = false

--Does this item disappear from the inventory after it's been applied?
ITEM.BurnOnUse = false

ITEM.Model = "models/props_phx2/garbage_metalcan001a.mdl"
ITEM.Rarity = 40

ITEM.OnEquip = function( wep )
	wep.UseLoopSound = "ambient/fire/fire_med_loop1.wav"
end

wOS:RegisterItem( ITEM )