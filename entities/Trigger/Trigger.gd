## A class for certain tiles that activate an event when the
## player steps on them.
class_name Trigger
extends Node2D

## Fired when the Trigger is triggered
signal triggered

## Which trigger effect to be ran when the Trigger is triggered
@export var key : int = 1

## Whether or not the trigger should activate when the player
## steps onto it.
@export var active : bool = true

## If true, frees the trigger once the player steps on it.
@export var one_shot : bool = true

## Number of times to run the trigger when activated.
@export var runs : int = 1

## A reference to the player
var player : Node2D

func _ready() -> void:
	player = get_tree().root.get_node("Level").get_player()

func _process(_delta: float) -> void:
	if active and player.global_position == global_position:
		
		for i in range(0, runs):
			TriggerEvent.run(key, -1)
		
		if one_shot:
			queue_free()
