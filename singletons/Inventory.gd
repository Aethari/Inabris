## Inventory handling singleton
extends Node

## A signal which is emitted when an update is applied to
## [member inventory], i.e. items being added or removed.
signal inventory_updated

## An array containing the entire inventory.
var inventory : Array

# == Functions =================================================
## Adds a [WorldItem] to [member inventory]. After adding the
## item, moves it to the top of [member inventory].
func add_item(item : WorldItem):
	if inventory.size() == 0:
		var i = InventoryItem.new(item.key, 1)
		inventory.insert(0, i)
		print("Inventory: 1 ", i.item_name, " (", i.key, ") added")
	else:
		var found = false
		
		for j in inventory:
			if item.key == j.key:
				found = true
				j.count += 1
				print("Inventory: 1 ", j.item_name, " (", j.key, ") added")
				break
		
		if not found:
			var i = InventoryItem.new(item.key, 1)
			inventory.insert(0, i)
			print("Inventory: 1 ", i.item_name, " (", i.key, ") added")
	
	inventory_updated.emit()

## Removes several items from [member inventory] based on a
## given key. If a negative number is given for count, items
## will be added. This function does not work on items that
## aren't in [member inventory].
func remove_item(key : int):
	for i in inventory:
		if i.key == key:
			i.count -= 1
			print("Inventory: 1 ", i.item_name, " (", i.key, ") removed")
		
		if i.count <= 0:
			inventory.erase(i)
		break
	
	inventory_updated.emit()

func get_item_count(key : int):
	for item in inventory:
		if item.key == key:
			return item.count

# == Engine functions ==========================================
func _ready() -> void:
	inventory = []
