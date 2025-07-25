extends Building
class_name WoodCutter

func _ready() -> void:
	print("fking nigga")


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		GameManager.selected_npc[0].work_at_building = self
		GameManager.selected_npc[0].current_task = NPC.Tasks.WOOD_CUTEER
