extends Node2D
#@onready var panel: Panel = $CanvasLayer/BuilderManager/Panel
#@onready var panel: HBoxContainer = $CanvasLayer/BuilderManager/Panel/ScrollContainer2/HBoxContainer
@onready var panel: ScrollContainer = $CanvasLayer/Panel/CenterContainer/BuilderManager

@onready var builder_manager: Node2D = $"Builder Manager"

@onready var ground: TileMapLayer = $ground
@onready var astar: AStar2DNode = $AStar2D

@onready var panel_2: Panel = $CanvasLayer/Panel



func _ready():
	# Get all buttons under the VBoxContainer and connect them
	for button in panel.get_child(0).get_children():
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
		var offset = 0
		for npc in GameManager.selected_npc:
			var mouse_pos = get_global_mouse_position()
			var grid_start = ground.local_to_map(npc.global_position)
			var grid_end = ground.local_to_map(Vector2(mouse_pos.x + offset, mouse_pos.y+offset))
			offset += 32
			if astar.getAStarGrid2D().is_in_bounds(grid_end.x, grid_end.y) and astar.getAStarGrid2D().get_point_weight_scale(grid_end) > 0.0:
				var path = astar.getAStarGrid2D().get_id_path(grid_start, grid_end)
				if path.size() > 0:
					npc.set_path(path, ground)
				else:
					print("No path found")
	
func _on_builder_manager_on_structure_change_state(value:GameManager.StrucutureState) -> void:
	pass


func _on_selection_selected(selections: Array[Node2D]) -> void:
	if not selections.is_empty():
		panel_2.get_child(0).get_child(1).show()
		panel_2.get_child(0).get_child(0).hide()
	else:
		panel_2.get_child(0).get_child(1).hide()
		panel_2.get_child(0).get_child(0).show()
	GameManager.selected_npc = []
	for select in selections:
		if select.is_in_group("npc"):
			GameManager.selected_npc.append(select)
			if select in GameManager.npc:
				GameManager.npc.append(selections)
	print(selections)
	
