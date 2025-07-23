extends Node2D

@export var tile_size := Vector2(64, 32) # Isometric tile size
@export var grid_size := Vector2i(20, 20) # How big your grid is
@export var astar: Node2D
@export var show_path := false
var current_path: Array[Vector2i] = []

func _draw():
	if astar == null:
		return

	for x in grid_size.x:
		for y in grid_size.y:
			var pos = Vector2i(x, y)
			var screen_pos = map_to_iso(pos)

			var color := Color.GREEN
			if astar.is_point_solid(pos):
				color = Color.RED
			elif show_path and current_path.has(pos):
				color = Color.YELLOW

			draw_rect(Rect2(screen_pos - Vector2(4, 4), Vector2(8, 8)), color)

# Helper to convert grid to isometric position
func map_to_iso(pos: Vector2i) -> Vector2:
	var x = pos.x
	var y = pos.y
	return Vector2(
		(x - y) * tile_size.x / 2,
		(x + y) * tile_size.y / 2
	)

func set_path(path: Array[Vector2i]):
	current_path = path
	show_path = true
	queue_redraw()
