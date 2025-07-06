## A class for objects that exist in the world, as opposed to 
## the player's inventory.
class_name WorldItem
extends Node2D

## Fired when the item is picked up by the player.
signal picked_up

## Whether or not the WorldItem can be picked up by the player.
@export var allow_pickup : bool = true

## A key representing which item the WorldItem is. See
## [InventoryItem] for more info about item keys.
@export var key : int = 1

## The texture that will be used to display the item in game.
## This is automatically loaded from a res://items/icons/<key>.png
## file based on the item's key. Icons should be 16x16 pixels in
## size. If a texture does not exist, the debug/missing texture
## is used. This is the same texture for negative numbers.
var icon : Texture2D

## The [Sprite2D] that is automatically created based on
## the item's key.
var sprite : Sprite2D

## A reference to the player.
var player : Node2D

func _ready() -> void:
	player = get_tree().root.get_node("Level").get_player()
	picked_up.connect(player._on_item_pickup)
	
	if has_node("ColorRect"):
		get_node("ColorRect").visible = false
		
	icon = load("res://items/icons/" + str(key) + ".png")
	if icon == null:
		push_error("Could not load texture \"res://items/icons/", str(key), ".png\". Falling back to debug/missing texture.")
		icon = load("res://items/icons/-1.png")
	
	sprite = Sprite2D.new()
	sprite.texture = icon
	sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	sprite.scale = Vector2(4, 4)
	sprite.position = Vector2(32, 32)
	add_child(sprite)

func _process(_delta: float) -> void:
	if allow_pickup and player.global_position == global_position:
		picked_up.emit(self)
