extends CharacterBody2D  # or Node2D

@export var speed := 80.0
@export var cell_size := Vector2(64, 64)  # tile size (for converting tile to world pos)

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@export var tilemap_position := Vector2.ZERO  # the position of the TileMap node in world coordinates

var tileMap:TileMapLayer;
var path: Array = []
var current_path_index: int = 0
#var velocity: Vector2 = Vector2.ZERO

func set_path(new_path: Array, tile_map) -> void:
	path = new_path
	current_path_index = 0
	tileMap = tile_map
func _process(delta: float) -> void:
	if path.is_empty() or tileMap == null:
		velocity = Vector2.ZERO
		_update_animation(velocity)
		return
	# Convert tile coords to world position:
	var target_pos: Vector2 = tileMap.map_to_local(path.front())
	global_position = global_position.move_toward(target_pos,delta*speed)

	if global_position == target_pos:
		path.pop_front()
	
	move_and_slide()
	var direction: Vector2 = target_pos - global_position
	_update_animation(direction)

func _update_animation(direction: Vector2) -> void:
	if direction.length() == 0:
		animated_sprite.stop()
		return

	if abs(direction.x) > abs(direction.y):
		if direction.x > 0:
			animated_sprite.play("moving_right")
		else:
			animated_sprite.play("moving_left")
	else:
		if direction.y > 0:
			animated_sprite.play("moving_down")
		else:
			animated_sprite.play("moving_top")
