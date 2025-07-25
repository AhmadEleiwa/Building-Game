extends Node2D

#@onready var panel: Panel = $CanvasLayer/BuilderManager/Panel
#@onready var panel: HBoxContainer = $CanvasLayer/BuilderManager/Panel/ScrollContainer2/HBoxContainer
@onready var panel: ScrollContainer = $CanvasLayer/Panel/CenterContainer/BuilderManager

@onready var builder_manager: Node2D = $"Builder Manager"

@onready var ground: NavigationTileMapLayer = $ground


@onready var panel_2: Panel = $CanvasLayer/Panel



func _ready():
	GameManager.on_construct_buidling.connect(on_construct_buidling)
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
			if npc is NPC:
				npc.set_target(mouse_pos)
				npc.current_task = NPC.Tasks.IDLE
				#navigation_region_2d.bake_navigation_polygon()


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
			if select not in GameManager.npc:
				#select.npc_moving.connect(update_npc_movement)

				GameManager.npc.append(select)
	
func update_npc_movement(last_pos:Vector2i,current_pos:Vector2i):
	pass
	#astar.getAStarGrid2D().set_point_solid(last_pos, false)
	#astar.getAStarGrid2D().set_point_solid(current_pos)
func on_construct_buidling(coords:Array[Vector2i]):
	ground.disable_tiles(coords)
	
