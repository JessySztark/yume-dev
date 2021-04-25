local ITEM = {} 
ITEM.Rarity = 100

ITEM.Name = "Hyperball Blueprint"

ITEM.Description = "A way to tame your inner charge"

ITEM.Type = WOSTYPE.BLUEPRINT

--Add user groups that are allowed to use this tree. If anyone is allowed, set this to FALSE ( TREE.UserGroups = false )
ITEM.UserGroups = false

--Does this item disappear from the inventory after it's been applied?
ITEM.BurnOnUse = true

ITEM.Model = "models/gangwars/crafting/blup.mdl"

--The materials required to make the item. This can be RAW MATERIALS or OTHER ITEMS. Just make sure you use their exact name
--IF THEY ARE NOI VALID MATERIALS, THEY WILL NOT BE CONSIDERED IN THE CRAFTING PROCESS!
ITEM.Ingredients = {
	[ "Refined Steel" ] = 5,
	[ "Glass" ] = 30,
}

--The name of the item that this blueprint will give to the player ( if they have enough slots )
ITEM.Result = "Hyperball"

ITEM.OnCrafted = function( ply )
	ply:AddSkillXP( 100 )
end

wOS:RegisterItem( ITEM )