## A class for objects that exist in the player's inventory, as 
## opposed to the world. This class is neccessary because, if
## the [Inventory] used [WorldItem]s, then every item in the
## inventory would be constantly updating.
class_name InventoryItem
extends Node

## The name of the InventoryItem. This is what is displayed in
## the inventory screen.
var item_name : String

## The type of the item (Resource, Weapon, Consumable, Flask,
## etc.). Used when determining what an item can be used for.
var item_type : String

## The key of the item. This is used to track the "base" of an
## item, but allows you to have the same different items of the 
## same type have different names.
var key : int

## The number of this item in [member Inventory.inventory].
## This is what allows item stacking.
var count : int

## The texture that will be used to display the item in game.
## This is automatically loaded from a res://items/icons/<key>.png
## file based on the item's key. Icons should be 16x16 pixels in
## size. If a texture does not exist, the debug/missing texture
## is used. This is the same texture for negative numbers.
var icon : Texture2D

func _init(k : int, c : int) -> void:
	self.key = k
	self.count = c
	
	icon = load("res://items/icons/" + str(key) + ".png")
	if icon == null:
		push_error("Could not load texture \"res://items/icons/", str(key), ".png\". Falling back to debug/missing texture.")
		icon = load("res://items/icons/-1.png")
	
	match k:
		-2:
			self.item_name = "Debug Item (2)"
			self.item_type = "Debug"
		-1:
			self.item_name = "Debug Item"
			self.item_type = "Debug"
		0:
			self.item_name = "Empty Item"
			self.item_type = "Empty"
		1:
			self.item_name = "Wood"
			self.item_type = "Resource"
		2:
			self.item_name = "Stone"
			self.item_type = "Resource"
		3:
			self.item_name = "Ore"
			self.item_type = "Resource"
		4:
			self.item_name = "Thread"
			self.item_type = "Resource"
		5:
			self.item_name = "Flint"
			self.item_type = "Resource"
		6:
			self.item_name = "Clay"
			self.item_type = "Resource"
		7:
			self.item_name = "Metal Bar"
			self.item_type = "Crafted Resource"
		8:
			self.item_name = "Workbench"
			self.item_type = "Workstation"
		9:
			self.item_name = "Furnace"
			self.item_type = "Workstation"
		10:
			self.item_name = "Anvil"
			self.item_type = "Workstation"
		11:
			self.item_name = "Enchanting Workbench"
			self.item_type = "Workstation"
		12:
			self.item_name = "Stove"
			self.item_type = "Workstation"
		13:
			self.item_name = "Oven"
			self.item_type = "Workstation"
		14:
			self.item_name = "Campfire Kit"
			self.item_type = "Consumable"
		15:
			self.item_name = "Door"
			self.item_type = "Building"
		16:
			self.item_name = "Wooden Wall"
			self.item_type = "Building"
		17:
			self.item_name = "Brick Wall"
			self.item_type = "Building"
		18:
			self.item_name = "Shirt"
			self.item_type = "Armor"
		19:
			self.item_name = "Pants"
			self.item_type = "Armor"
		20:
			self.item_name = "Shoes"
			self.item_type = "Armor"
		21:
			self.item_name = "Chain Shirt"
			self.item_type = "Armor"
		22:
			self.item_name = "Chain Leggings"
			self.item_type = "Armor"
		23:
			self.item_name = "Chain Boots"
			self.item_type = "Armor"
		24:
			self.item_name = "Plate Shirt"
			self.item_type = "Armor"
		25:
			self.item_name = "Plate Leggings"
			self.item_type = "Armor"
		26:
			self.item_name = "Plate Boots"
			self.item_type = "Armor"
		27:
			self.item_name = "Stick"
			self.item_type = "Weapon"
		28:
			self.item_name = "Rock"
			self.item_type = "Weapon"
		29:
			self.item_name = "Sharp Rock"
			self.item_type = "Weapon"
		30:
			self.item_name = "Sharpened Stick"
			self.item_type = "Weapon"
		31:
			self.item_name = "Crude Spear"
			self.item_type = "Weapon"
		32:
			self.item_name = "Dagger"
			self.item_type = "Weapon"
		33:
			self.item_name = "Metal Spear"
			self.item_type = "Weapon"
		34:
			self.item_name = "Metal Axe"
			self.item_type = "Weapon"
		35:
			self.item_name = "Metal Sword"
			self.item_type = "Weapon"
		36:
			self.item_name = "Debug Book"
			self.item_type = "Enchantment Book"
		37:
			self.item_name = "Minor Damage Buff"
			self.item_type = "Enchantment Book"
		38:
			self.item_name = "Major Damage Buff"
			self.item_type = "Enchantment Book"
		39:
			self.item_name = "Flame Weapon"
			self.item_type = "Enchantment Book"
		40:
			self.item_name = "Minor Defense Buff"
			self.item_type = "Enchantment Book"
		41:
			self.item_name = "Major Defense Buff"
			self.item_type = "Enchantment Book"
		42:
			self.item_name = "Apple"
			self.item_type = "Food"
		43:
			self.item_name = "Small Steak"
			self.item_type = "Food"
		44:
			self.item_name = "Large Steak"
			self.item_type = "Food"
		45:
			self.item_name = "Baked Apple"
			self.item_type = "Food"
		46:
			self.item_name = "Cooked Steak"
			self.item_type = "Food"
		47:
			self.item_name = "Wooden Flask"
			self.item_type = "Food"
		48:
			self.item_name = "Clay Flask"
			self.item_type = "Flask"
		49:
			self.item_name = "Metal Flask"
			self.item_type = "Flask"
		50:
			self.item_name = "Minor Flask Buff"
			self.item_type = "Enchantment Book"
		51:
			self.item_name = "Major Flask Buff"
			self.item_type = "Enchantment Book"
		52:
			self.item_name = "Bed"
			self.item_type = "Building"
		53:
			self.item_name = "Cloth"
			self.item_type = "Crafted Resource"
