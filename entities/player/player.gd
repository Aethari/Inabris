extends Node2D

# == Exports ===================================================
@export_group("Settings")
## How much button zoom events (not the mouse wheel) should
## change the camera's zoom each frame they are pressed.
@export var button_zoom_speed : float = .02

## How much mouse wheel zoom events should change the camera's
## zoom each time they are triggered.
@export var wheel_zoom_speed : float = .3

@export_group("Movement")
## How many pixels the player should move when moving normally 
## (not bumping)
@export var move_distance : int = 64

## How many pixels the player should move when bumping into
## something (wall, enemy, etc). This moves the player's sprite
## into the wall and then immediately back out by the same
## distance.
@export var bump_distance : int = 24

@export_group("Stats")
@export_subgroup("HP")
## The max amount of HP the player can have
@export var max_hp : int = 200
## The current amount of HP the player has
@export var hp : int = 200

@export_subgroup("Hunger")
## The most full the hunger bar can be
@export var total_hunger : int = 150
## The current amount of hunger
@export var hunger : int = 150
## How much [member hunger] is decremented by every time the
## player moves.
@export var hunger_drain : int = 1
## How much damage the player takes when moving while 
## [member hunger] is at 0
@export var hunger_damage : int = 1

@export_subgroup("Thirst")
## The most full the thirst bar can be
@export var total_thirst : int = 200
## The current amount of thirst
@export var thirst : int = 200
## How much [member thirst] is decremented by every tiem the
## player moves.
@export var thirst_drain : int = 2
## How much damage the player takes when moving while 
## [member thirst] is at 0
@export var thirst_damage : int = 2

# == Non-export Locals =========================================
var tilemap : TileMapLayer
var animation_player : AnimationPlayer

var play_anim : bool = true

var can_move : bool = true

var bump : bool = false
var bump_dir : int

var move_x : bool = false
var move_y : bool = false
var target_pos : float

# == Functions =================================================
func check_collision(t : Vector2):
	var target = Vector2(t.x / tilemap.scale.x, t.y / tilemap.scale.y)
	var map_target = tilemap.local_to_map(target)
	var data = tilemap.get_cell_tile_data(map_target)
	
	if data != null and data.has_custom_data("Collision"):
		return data.get_custom_data("Collision")
	else:
		return 0

# == Engine Functions ==========================================
func _ready() -> void:
	tilemap = get_tree().root.get_node("Level").get_tilemap()
	animation_player = get_tree().root.get_node("Level").get_level_animations()
	animation_player.animation_finished.connect(_on_level_animation_finished)

func _input(_event: InputEvent) -> void:
	if Input.is_action_pressed("mouse_zoom_in"):
		$Camera2D.zoom += Vector2(wheel_zoom_speed, wheel_zoom_speed)
	elif Input.is_action_pressed("mouse_zoom_out"):
		# If statement prevents "Zoom level must be different
		# from 0 (can be negative)" errors
		if $Camera2D.zoom.x > .4:
			$Camera2D.zoom -= Vector2(wheel_zoom_speed, wheel_zoom_speed)

func _process(_delta: float) -> void:
	if hp <= 0 and play_anim:
		hp = 0
		can_move = false
		animation_player.play("death")
	
	# Movement inputs ------------------------------------------
	if can_move and !bump:
		move_x = false
		move_y = false
		
		# left/right
		if Input.is_action_pressed("left"):
			move_x = true
			
			if check_collision(Vector2(position.x-64, position.y)) == 0:
				if hunger <= 0:
					hunger = 0
					hp -= hunger_damage
				else:
					hunger -= hunger_drain
				
				if thirst <= 0:
					thirst = 0
					hp -= thirst_damage
				else:
					thirst -= thirst_drain
				
				target_pos = position.x - move_distance
				can_move = false
				$MoveCooldown.start()
			else:
				target_pos = position.x - bump_distance
				bump = true
				bump_dir = 1
				$BumpCooldown.start()
		elif Input.is_action_pressed("right"):
			move_x = true
			
			if check_collision(Vector2(position.x+64, position.y)) == 0:
				if hunger <= 0:
					hunger = 0
					hp -= hunger_damage
				else:
					hunger -= hunger_drain
				
				if thirst <= 0:
					thirst = 0
					hp -= thirst_damage
					hunger -= hunger_drain
				else:
					thirst -= thirst_drain
				
				target_pos = position.x + move_distance
				can_move = false
				$MoveCooldown.start()
			else:
				target_pos = position.x + bump_distance
				bump = true
				bump_dir = -1
				$BumpCooldown.start()
		# up/down
		elif Input.is_action_pressed("up"):
			move_y = true
			
			if check_collision(Vector2(position.x, position.y-64)) == 0:
				if hunger <= 0:
					hunger = 0
					hp -= hunger_damage
				else:
					hunger -= hunger_drain
				
				if thirst <= 0:
					thirst = 0
					hp -= thirst_damage
				else:
					thirst -= thirst_drain
				
				target_pos = position.y - move_distance
				can_move = false
				$MoveCooldown.start()
			else:
				target_pos = position.y - bump_distance
				bump = true
				bump_dir = 1
				$BumpCooldown.start()
		elif Input.is_action_pressed("down"):
			move_y = true
			
			if check_collision(Vector2(position.x, position.y+64)) == 0:
				if hunger <= 0:
					hunger = 0
					hp -= hunger_damage
				else:
					hunger -= hunger_drain
				
				if thirst <= 0:
					thirst = 0
					hp -= thirst_damage
				else:
					thirst -= thirst_drain
				
				target_pos = position.y + move_distance
				can_move = false
				$MoveCooldown.start()
			else:
				target_pos = position.y + bump_distance
				bump = true
				bump_dir = -1
				$BumpCooldown.start()
	
	# Movement -------------------------------------------------
	if !can_move:
		if move_x:
			position.x = move_toward(position.x, target_pos, 4.5)
		elif move_y:
			position.y = move_toward(position.y, target_pos, 4.5)
	# Bumping --------------------------------------------------
	elif bump:
		if move_x:
			if $BumpCooldown.time_left >= $BumpCooldown.wait_time/2:
				# move forward
				$TempSprite.global_position.x = move_toward($TempSprite.global_position.x, target_pos, 4.5)
			else:
				#move backward
				$TempSprite.global_position.x = move_toward($TempSprite.global_position.x, target_pos + (bump_dir * bump_distance), 4.5)
		elif move_y:
			if $BumpCooldown.time_left >= $BumpCooldown.wait_time/2:
				# move forward
				$TempSprite.global_position.y = move_toward($TempSprite.global_position.y, target_pos, 4.5)
			else:
				#move back
				$TempSprite.global_position.y = move_toward($TempSprite.global_position.y, target_pos + (bump_dir * bump_distance), 4.5)
	
	if Input.is_action_pressed("zoom_in"):
		$Camera2D.zoom += Vector2(button_zoom_speed, button_zoom_speed)
	elif Input.is_action_pressed("zoom_out"):
		$Camera2D.zoom -= Vector2(button_zoom_speed, button_zoom_speed)
	
	$Camera2D.zoom.x = clampf($Camera2D.zoom.x, .3, 3)
	$Camera2D.zoom.y = clampf($Camera2D.zoom.y, .3, 3)

# == Signals ===================================================
func _on_move_cooldown_timeout() -> void:
	can_move = true

func _on_bump_cooldown_timeout() -> void:
	bump = false

func _on_item_pickup(item : WorldItem) -> void:
	Inventory.add_item(item)
	item.queue_free()

func _on_level_animation_finished(anim : String):
	if anim == "death":
		play_anim = false
		can_move = false
