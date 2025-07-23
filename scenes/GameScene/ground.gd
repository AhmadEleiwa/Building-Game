extends TileMapLayer

@onready var tree_layer: TileMapLayer = $"../Obstacles/Tree Layer"
@onready var buldings: Node2D = $"../Obstacles/buldings"



func _use_tile_data_runtime_update(coords: Vector2i) -> bool:
	
	if coords in tree_layer.get_used_cells_by_id(4):
		return true
	else:
		return false
func _tile_data_runtime_update(coords: Vector2i, tile_data: TileData) -> void:
	print( GameManager.buildings_coords)
	if coords in tree_layer.get_used_cells_by_id(4):
		tile_data.set_navigation_polygon(0, null)

		
