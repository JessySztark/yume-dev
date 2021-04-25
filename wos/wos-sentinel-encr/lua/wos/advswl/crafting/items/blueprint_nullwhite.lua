local ITEM = {} 
ITEM.Rarity = 100

ITEM.Name = "Nullifier Blueprint"

ITEM.Description = "Creates a way to amplify all else"

ITEM.Type = WOSTYPE.BLUEPRINT

--Add user groups that are allowed to use this tree. If anyone is allowed, set this to FALSE ( TREE.UserGroups = false )
ITEM.UserGroups = false

--Does this item disappear from the inventory after it's been applied?
ITEM.BurnOnUse = true

ITEM.Model = "models/gangwars/crafting/blup.mdl"

--The raw materials required to make the item. IF THEY ARE NOI VALID MATERIALS, THEY WILL NOT BE CONSIDERED IN THE CRAFTING PROCESS!
ITEM.Ingredients = {
	[ "Refined Steel" ] = 20,
	[ "Aluminum Alloy" ] = 20,
	[ "Glass" ] = 5,
}

--The name of the item that this blueprint will give to the player ( if they have enough slots )
ITEM.Result = "Null Refractor ( Unstable )"

ITEM.OnCrafted = function( ply )
	ply:AddSkillXP( 100 )
end

wOS:RegisterItem( ITEM )