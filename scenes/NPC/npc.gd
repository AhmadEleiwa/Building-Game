extends CharacterBody2D
class_name NPC
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@export var speed: float = 100.0
@onready var bt_player: BTPlayer = $BTPlayer
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

@export var tree_tilemap:TileMapLayer;
@export var work_at_building: Building

enum Tasks{
	IDLE,
	WOOD_CUTEER,
	FARMER
}
@export var current_task:Tasks= Tasks.IDLE
func _ready() -> void:
	# Optional callback if you use it
	nav_agent.velocity_computed.connect(_on_velocity_computed)

func _physics_process(delta: float) -> void:
	if nav_agent.is_navigation_finished():
		return
	else:
		var direction = (nav_agent.get_next_path_position() -global_position).normalized()
		var indended_velocity = direction * speed
		nav_agent.set_velocity(indended_velocity)
		
		play_animation(direction)
	#move_and_slide()
func play_animation(direction: Vector2):
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
func set_target(pos: Vector2) -> void:
	nav_agent.target_position = pos
	
func is_npc_moving() -> bool:
	if nav_agent.is_navigation_finished():
		return false
	#nav_agent.neighbor_distance
	var next_path_pos = nav_agent.get_next_path_position()
	return not global_position.is_equal_approx(next_path_pos)

func _on_velocity_computed(safe_velocity: Vector2) -> void:
	# You can use this instead of manual movement if you prefer:
	velocity = safe_velocity
	move_and_slide()
func find_closest_tree() -> Vector2:
	var closest_position: Vector2 = Vector2.ZERO
	var shortest_distance: float = INF

	var origin_tile = tree_tilemap.local_to_map(tree_tilemap.to_local(global_position))

	# Loop over all used cells in the tilemap
	for tile in tree_tilemap.get_used_cells():  # Assuming layer 0
		var tile_data = tree_tilemap.get_cell_tile_data( tile)
		if tile_data == null:
			continue
		
		var tile_world_pos = tree_tilemap.to_global(tree_tilemap.map_to_local(tile))
		var dist = global_position.distance_squared_to(tile_world_pos)

		if dist < shortest_distance:
			shortest_distance = dist
			closest_position = tile_world_pos

	return closest_position
