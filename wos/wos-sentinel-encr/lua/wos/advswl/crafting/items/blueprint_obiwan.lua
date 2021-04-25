local ITEM = {} 
ITEM.Rarity = 100

ITEM.Name = "Obiwan's Hilt Blueprint"

ITEM.Description = "To succeed, one must learn to create"

ITEM.Type = WOSTYPE.BLUEPRINT

--Add user groups that are allowed to use this tree. If anyone is allowed, set this to FALSE ( TREE.UserGroups = false )
ITEM.UserGroups = false

--Does this item disappear from the inventory after it's been applied?
ITEM.BurnOnUse = true

ITEM.Model = "models/gangwars/crafting/blup.mdl"

ITEM.RarityName = "Epic" 
ITEM.RarityColor = Color( 175, 175, 0 )

--The raw materials required to make the item. IF THEY ARE NOI VALID MATERIALS, THEY WILL NOT BE CONSIDERED IN THE CRAFTING PROCESS!
ITEM.Ingredients = {
	[ "Refined Steel" ] = 5,
	[ "Aluminum Alloy" ] = 2,
}

--The name of the item that this blueprint will give to the player ( if they have enough slots )
ITEM.Result = "Obiwan Kenobi"

ITEM.OnCrafted = function( ply )
	ply:AddSkillXP( 100 )
end

wOS:RegisterItem( ITEM )