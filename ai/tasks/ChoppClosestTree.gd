extends BTAction
@export var closest_tree:StringName = &"closest_tree"
@export var was_chopping:StringName = &"was_chopping"


func _tick(delta: float) -> Status:
	if agent.current_task != agent.Tasks.WOOD_CUTEER:
		return FAILURE
	var tile_pos = agent.tree_tilemap.local_to_map(blackboard.get_var(closest_tree))
	var tile_id = agent.tree_tilemap.get_cell_source_id( tile_pos)
	if tile_id == -1:
		return FAILURE
	
	blackboard.set_var(was_chopping, true)
	agent.tree_tilemap.set_cell(tile_pos, -1)
	return SUCCESS
