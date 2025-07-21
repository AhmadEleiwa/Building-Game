extends Node2D
@export var tileMap: TileMapLayer;

@onready var base_grid: AnimatedSprite2D = $base_grid
@onready var label: Label = $CanvasLayer/Container/Label

var ghostedHouse:Node2D = null;
var other_colisions:int = 0
@export var target: Node2D;
@export var can_build:bool = true;
func get_tile_under_mouse(tilemap: TileMapLayer) -> Vector2i:
	var mouse_pos = tilemap.get_local_mouse_position()
	return tilemap.local_to_map(mouse_pos)
func _input(event) -> void:
	if event is InputEventMouseButton :
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if  can_build == true and ghostedHouse != null:
				ghostedHouse.get_node('Area2D').get_node('CollisionShape2D').disabled  = false
		
				ghostedHouse =null
			if can_build == false  and ghostedHouse != null:
				print("hi")
				label.show()

func _process(delta):
	var tile = get_tile_under_mouse(tileMap)
	var world_pos = tileMap.map_to_local(tile)
	if ghostedHouse != null:
		base_grid.show()
		base_grid.position = world_pos - $Pivot.position
		ghostedHouse.position = world_pos
	else:
		base_grid.hide()
		

func build(structure:PackedScene ):
	ghostedHouse = structure.instantiate()

	ghostedHouse.get_node('Area2D').get_node('CollisionShape2D').disabled  = true
	base_grid.scale = ghostedHouse.get_node('Area2D').scale
	ghostedHouse.get_node('base_grid').hide()
	var pivot = ghostedHouse.get_node("Pivot")
	ghostedHouse.position = tileMap.map_to_local(get_tile_under_mouse(tileMap)) - pivot.position
	target.add_child(ghostedHouse)






func _on_area_2d_body_entered(body: Node2D) -> void:
	other_colisions+=1
	print("aread 2d enteried")
	base_grid.play("cant_build")
	can_build = false


func _on_area_2d_body_exited(body: Node2D) -> void:
	other_colisions-=1
	print("aread 2d exited")
	if other_colisions == 0:
		base_grid.play("can_build")

		can_build = true
		label.hide()
