extends TileMapLayer
class_name NavigationTileMapLayer

@onready var tree_layer: TileMapLayer = $"../Obstacles/Tree Layer"


func _ready() -> void:
	for coords in tree_layer.get_used_cells_by_id(4):
		var alt = get_cell_atlas_coords(coords)
		set_cell(coords, 0, alt, 0)
		
func disable_tile(coord:Vector2i):
	var alt = get_cell_atlas_coords(coord)
	set_cell(coord, 0, alt, 0)
func enable_tile(coord:Vector2i):
	var alt = get_cell_atlas_coords(coord)
	set_cell(coord, 0, alt, 0)
func disable_tiles(coords:Array[Vector2i]):
	for coord in coords:
		var alt = get_cell_atlas_coords(coord)
		set_cell(coord, 0, alt, 0)
