extends Node2D
class_name AStar2DNode
var astar := AStarGrid2D.new()
var cell_size := Vector2(64, 32)  # common isometric tile size (width > height)
var region_size := Vector2i(100, 100)
var offset := Vector2i(100, 100)
@onready var tree_layer: TileMapLayer = $"../Obstacles/Tree Layer"

@onready var ground: TileMapLayer = $"../ground"

func _ready():
	var used_rect = ground.get_used_rect()
	
	
	astar.region = used_rect
	
	astar.cell_size = cell_size
	astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_ONLY_IF_NO_OBSTACLES
	astar.jumping_enabled  = true
	astar.cell_shape = AStarGrid2D.CELL_SHAPE_ISOMETRIC_DOWN
	
		# Add all ground tiles to AStarGrid as non-solid
	astar.update()
	for x in range(used_rect.position.x , used_rect.position.x + used_rect.size.x):
		for y in range(used_rect.position.y , used_rect.position.y + used_rect.size.y):
			var coords = Vector2i(x, y)
			if tree_layer.get_cell_source_id(coords) != -1:
				astar.set_point_solid(coords, true)
			elif ground.get_cell_source_id( coords) != -1: # or check by layer or source if needed
				astar.set_point_solid(coords, false)
			else:
				astar.set_point_solid(coords, true) # No tile = solid
	
	GameManager.on_construct_buidling.connect(disable_tiles_at.bind(GameManager.buildings_coords))
	queue_redraw()

func grid_to_iso(grid_pos: Vector2i) -> Vector2:
	var offset = grid_pos - astar.region.position
	var iso_x = (offset.x - offset.y) * (cell_size.x / 2)
	var iso_y = (offset.x + offset.y) * (cell_size.y / 2)
	return Vector2(iso_x, iso_y)

func _draw():
	if astar and astar.region:
		var region := astar.region
		var pos := region.position
		var size := region.size

		# Get 4 corners in tile coordinates
		var top_left := pos
		var top_right := pos + Vector2i(size.x, 0)
		var bottom_right := pos + size
		var bottom_left := pos + Vector2i(0, size.y)

		# Convert to local (world) positions using TileMap
		var p1 := ground.map_to_local(top_left)
		var p2 := ground.map_to_local(top_right)
		var p3 := ground.map_to_local(bottom_right)
		var p4 := ground.map_to_local(bottom_left)

		# Draw outline as polygon (in order)
		var points := [p1, p2, p3, p4, p1]
		draw_polyline(points, Color.YELLOW, 2.0)
func getAStarGrid2D()->AStarGrid2D:
	return astar
func disable_tiles_at(coords: Array[Vector2i]) -> void:
	for coord in coords:
		if astar.region.has_point(coord):
			astar.set_point_solid(coord, true)
func enable_tiles_at(coords: Array[Vector2i]) -> void:
	for coord in coords:
		if astar.region.has_point(coord):
			astar.set_point_solid(coord, false)
