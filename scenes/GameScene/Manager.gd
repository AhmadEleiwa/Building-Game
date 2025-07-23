extends Node2D
#@onready var panel: Panel = $CanvasLayer/BuilderManager/Panel
@onready var panel: HBoxContainer = $CanvasLayer/BuilderManager/Panel/ScrollContainer2/HBoxContainer

@onready var builder_manager: Node2D = $"Builder Manager"
@onready var npc: CharacterBody2D = $Obstacles/NPCs/NPC
@onready var ground: TileMapLayer = $ground
@onready var astar: AStar2DNode = $AStar2D

var path: Array = []
var speed := 100.0
var current_index := 0

func _ready():
	# Get all buttons under the VBoxContainer and connect them
	for button in panel.get_children():
		var name = button.name
		if button is Button:
			button.pressed.connect(on_button_pressed.bind(name))
			

func on_button_pressed(name):
	var res = GameManager.is_strucutures_match_requirment(name)
	if res.status:
	
		builder_manager.build(name)
	else:
		print(res)
	

func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		var mouse_pos = get_global_mouse_position()
		var grid_start = ground.local_to_map(npc.global_position)
		var grid_end = ground.local_to_map(mouse_pos)

		if astar.getAStarGrid2D().is_in_bounds(grid_end.x, grid_end.y) and astar.getAStarGrid2D().get_point_weight_scale(grid_end) > 0.0:
			var path = astar.getAStarGrid2D().get_id_path(grid_start, grid_end)
			if path.size() > 0:
				npc.set_path(path, ground)
			else:
				print("No path found")
			current_index = 0
		
func _on_builder_manager_on_structure_change_state(value:GameManager.StrucutureState) -> void:
	pass
