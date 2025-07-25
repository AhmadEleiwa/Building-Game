extends Node2D
class_name AStarGridNode2D

var astar := AStarGrid2D.new()
@export var cell_size := Vector2(64, 32)  # common isometric tile size (width > height)
@export var avoidance_layer: TileMapLayer
@export var grid_layer: TileMapLayer

func _ready():
	if not grid_layer:
		return
	
	var used_rect = grid_layer.get_used_rect()
	
	# Configure AStar grid
	astar.region = used_rect
	astar.cell_size = cell_size
	astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_ONLY_IF_NO_OBSTACLES
	astar.jumping_enabled = true
	astar.cell_shape = AStarGrid2D.CELL_SHAPE_ISOMETRIC_DOWN
	
	# Initialize the grid
	astar.update()
	
	# Set up walkable/solid tiles
	setup_walkable_tiles(used_rect)
	
	# Connect to building events if GameManager exists
	GameManager.on_construct_buidling.connect(_on_building_constructed)
	
	queue_redraw()

func setup_walkable_tiles(used_rect: Rect2i):
	var walkable_count = 0
	var solid_count = 0
	
	for x in range(used_rect.position.x, used_rect.position.x + used_rect.size.x):
		for y in range(used_rect.position.y, used_rect.position.y + used_rect.size.y):
			var coords = Vector2i(x, y)
			var is_solid = false
			
			# Check avoidance layer first (obstacles)
			if avoidance_layer and avoidance_layer.get_cell_source_id(coords) != -1:
				is_solid = true
			# Check if ground tile exists
			elif grid_layer.get_cell_source_id(coords) != -1:
				is_solid = false  # Walkable ground
			else:
				is_solid = true  # No tile = solid/unwalkable
			
			astar.set_point_solid(coords, is_solid)
			
			if is_solid:
				solid_count += 1
			else:
				walkable_count += 1
	

func getAStarGrid2D() -> AStarGrid2D:
	return astar

func grid_to_iso(grid_pos: Vector2i) -> Vector2:
	var offset = grid_pos - astar.region.position
	var iso_x = (offset.x - offset.y) * (cell_size.x / 2)
	var iso_y = (offset.x + offset.y) * (cell_size.y / 2)
	return Vector2(iso_x, iso_y)

func _draw():
	if not astar or not astar.region:
		return
	
	var region := astar.region
	var pos := region.position
	var size := region.size
	
	# Get 4 corners in tile coordinates
	var top_left := pos
	var top_right := pos + Vector2i(size.x, 0)
	var bottom_right := pos + size
	var bottom_left := pos + Vector2i(0, size.y)
	
	# Convert to local (world) positions using TileMap
	if grid_layer:
		var p1 := grid_layer.map_to_local(top_left)
		var p2 := grid_layer.map_to_local(top_right)
		var p3 := grid_layer.map_to_local(bottom_right)
		var p4 := grid_layer.map_to_local(bottom_left)
		
		# Draw outline as polygon (in order)
		var points := [p1, p2, p3, p4, p1]
		draw_polyline(points, Color.YELLOW, 2.0)

func disable_tiles_at(coords: Array[Vector2i]) -> void:
	var disabled_count = 0
	for coord in coords:
		if astar.region.has_point(coord):
			astar.set_point_solid(coord, true)
			disabled_count += 1

func enable_tiles_at(coords: Array[Vector2i]) -> void:
	var enabled_count = 0
	for coord in coords:
		if astar.region.has_point(coord):
			astar.set_point_solid(coord, false)
			enabled_count += 1

func is_point_walkable(coord: Vector2i) -> bool:
	if not astar.region.has_point(coord):
		return false
	return not astar.is_point_solid(coord)

func get_walkable_neighbors(coord: Vector2i) -> Array[Vector2i]:
	var neighbors: Array[Vector2i] = []
	var directions = [
		Vector2i(-1, 0), Vector2i(1, 0),   # Left, Right
		Vector2i(0, -1), Vector2i(0, 1),   # Up, Down
		Vector2i(-1, -1), Vector2i(1, -1), # Diagonals
		Vector2i(-1, 1), Vector2i(1, 1)
	]
	
	for dir in directions:
		var neighbor = coord + dir
		if is_point_walkable(neighbor):
			neighbors.append(neighbor)
	
	return neighbors

# NEW FUNCTION: Find nearest walkable tile to a solid tile
func find_nearest_walkable_to_solid(target_solid_coord: Vector2i, max_search_radius: int = 10) -> Vector2i:
	
	# Check if target is actually solid
	if not astar.region.has_point(target_solid_coord):
		return Vector2i(-999, -999)  # Invalid coordinate
	
	if not astar.is_point_solid(target_solid_coord):
		return target_solid_coord
	
	# Search in expanding radius
	for radius in range(1, max_search_radius + 1):
		var candidates: Array[Vector2i] = []
		
		# Check all tiles in the current radius
		for x in range(-radius, radius + 1):
			for y in range(-radius, radius + 1):
				# Only check tiles on the edge of current radius
				if abs(x) == radius or abs(y) == radius:
					var check_coord = target_solid_coord + Vector2i(x, y)
					
					if is_point_walkable(check_coord):
						candidates.append(check_coord)
		
		# If we found walkable tiles, return the closest one
		if candidates.size() > 0:
			# Sort by distance to target
			candidates.sort_custom(func(a, b): 
				var dist_a = (a - target_solid_coord).length_squared()
				var dist_b = (b - target_solid_coord).length_squared()
				return dist_a < dist_b
			)
			
			var result = candidates[0]
			return result
	
	return Vector2i(-999, -999)  # Invalid coordinate

# NEW FUNCTION: Get a safe path to near a solid target
func get_path_to_near_solid(start_world_pos: Vector2, target_solid_world_pos: Vector2, max_search_radius: int = 10) -> Array[Vector2i]:
	if not grid_layer:
		return []
	
	var start_grid = grid_layer.local_to_map(start_world_pos)
	var target_grid = grid_layer.local_to_map(target_solid_world_pos)
	
	
	# Find nearest walkable tile to the solid target
	var walkable_target = find_nearest_walkable_to_solid(target_grid, max_search_radius)

	if walkable_target == Vector2i(-999, -999):
		return []
	
	# Get normal path to the walkable target
	if astar.is_in_bounds(start_grid.x, start_grid.y) and astar.get_point_weight_scale(start_grid) > 0.0:
		var path = astar.get_id_path(start_grid, walkable_target)
		return path
	else:
		return []

# Handle building construction events
func _on_building_constructed(building_coords: Array[Vector2i]):
	#print("disabled")
	disable_tiles_at(building_coords)

# Debug function to print tile info
func debug_tile_info(coord: Vector2i):
	if not astar.region.has_point(coord):
		return
	
	var is_solid = astar.is_point_solid(coord)
	var weight = astar.get_point_weight_scale(coord)
	var has_ground = grid_layer.get_cell_source_id(coord) != -1
	var has_obstacle = avoidance_layer and avoidance_layer.get_cell_source_id(coord) != -1
	
