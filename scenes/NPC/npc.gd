extends CharacterBody2D

@export var speed: float = 80.0
@export var cell_size: Vector2 = Vector2(64, 64) # Tile size
@export var tilemap_position: Vector2 = Vector2.ZERO # TileMap world offset

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var tile_map: TileMapLayer
var path: Array[Vector2i] = []

var direction: Vector2i = Vector2i.ZERO

func set_path(new_path: Array[Vector2i], new_tile_map: TileMapLayer) -> void:
	path = new_path
	tile_map = new_tile_map


func _process(delta: float) -> void:
	if path.is_empty() or tile_map == null:
		velocity = Vector2.ZERO
		_update_animation(Vector2.ZERO)
		return

	var avoidance = _avoid_npcs(GameManager.npc)
	var target_tile = path.front()
	var target_world_pos: Vector2 = tile_map.map_to_local(target_tile)
	
	# Compute desired direction and velocity
	var desired_direction = (target_world_pos - global_position).normalized()
	var desired_velocity = desired_direction * speed
	
	# Safe velocity (applying avoidance force)
	var safe_velocity = (desired_direction + avoidance).normalized() * speed
	velocity = safe_velocity

	# Arrived at target tile
	if global_position.distance_to(target_world_pos) < 4.0:
		path.pop_front()
		if path.is_empty():
			velocity = Vector2.ZERO

	_update_animation(velocity)

func _physics_process(delta: float) -> void:
	move_and_slide()

func _update_animation(movement: Vector2) -> void:
	if movement.length() == 0:
		animated_sprite.stop()
		return

	if abs(movement.x) > abs(movement.y):
		animated_sprite.play("moving_right" if movement.x > 0 else "moving_left")
	else:
		animated_sprite.play("moving_down" if movement.y > 0 else "moving_top")

func _avoid_npcs(npcs: Array) -> Vector2:
	var avoidance_force = Vector2.ZERO
	for npc in npcs:
		if npc == self:
			continue
		var to_npc = global_position - npc.global_position
		var distance = to_npc.length()
		if distance < 32.0 and distance > 0:
			# Avoid stronger the closer the npc
			avoidance_force += to_npc.normalized() / distance
	return avoidance_force * 30.0 # Tune multiplier for strength
