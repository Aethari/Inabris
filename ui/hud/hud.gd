extends Control

var player : Node2D

func _ready() -> void:
	if not visible:
		visible = true
	
	player = get_tree().root.get_node("Level").get_player()
	
	$HealthBar.max_value = player.max_hp
	$HungerBar.max_value = player.total_hunger
	$ThirstBar.max_value = player.total_thirst

func _process(_delta: float) -> void:
	$HealthBar.value = player.hp
	$HungerBar.value = player.hunger
	$ThirstBar.value = player.thirst
