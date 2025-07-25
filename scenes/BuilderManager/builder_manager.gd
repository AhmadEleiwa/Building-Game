extends Node2D
@export var tileMap: TileMapLayer;

@onready var base_grid: AnimatedSprite2D = $base_grid
@onready var label: Label = $CanvasLayer/Container/Label

signal on_structure_change_state(value:GameManager.StrucutureState)

@export var target: Node2D;
@export var can_build:bool = true;
var selected:Node2D = null;
var other_colisions:int = 0
var structure_name:String = ""
const structures = {
	"House":preload("res://scenes/House/house.tscn"),
	"WoodCutter":preload("res://scenes/woodcutter/woodcutter.tscn"),
	"Storage": preload("res://scenes/Storage/storage.tscn"),
	"Farm" : preload("res://scenes/Farm/farm.tscn")
}
func get_tile_under_mouse(tilemap: TileMapLayer) -> Vector2i:
	var mouse_pos = tilemap.get_local_mouse_position()
	return tilemap.local_to_map(mouse_pos)
func _input(event) -> void:
	if event is InputEventMouseButton :
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if  can_build == true and selected != null:
				GameManager.construct(structure_name)
				var coord = tileMap.local_to_map(tileMap.to_local(selected.global_position))
				GameManager.add_building(selected,coord)
				selected.changeState(GameManager.StrucutureState.CONSTRUCTION)
				selected.get_node('Area2D').get_node('CollisionShape2D').disabled  = false
				selected =null
				on_structure_change_state.emit(GameManager.StrucutureState.CONSTRUCTION)
				
			if can_build == false  and selected != null:
				label.show()
		elif event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
				if selected != null:
					selected.queue_free()

func _process(delta):
	var tile = get_tile_under_mouse(tileMap)
	var world_pos = tileMap.map_to_local(tile)
	if selected != null:
		base_grid.show()
		base_grid.position = world_pos - $Pivot.position
		selected.position = world_pos
	else:
		base_grid.hide()
		

func build(struct_name:String ):
	var structure = structures[struct_name]
	structure_name = struct_name
	if selected  != null:
		selected.queue_free()
	selected = structure.instantiate()

	selected.get_node('Area2D').get_node('CollisionShape2D').disabled  = true
	base_grid.scale = selected.get_node('Area2D').scale
	selected.get_node('base_grid').hide()
	var pivot = selected.get_node("Pivot")
	selected.position = tileMap.map_to_local(get_tile_under_mouse(tileMap)) - pivot.position
	target.add_child(selected)

func _on_area_2d_body_entered(body: Node2D) -> void:
	other_colisions+=1
	base_grid.play("cant_build")
	print(body)
	can_build = false


func _on_area_2d_body_exited(body: Node2D) -> void:
	other_colisions-=1
	if other_colisions == 0:
		base_grid.play("can_build")

		can_build = true
		label.hide()
