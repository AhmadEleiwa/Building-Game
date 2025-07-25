extends BTCondition
@export var closes_tree_var:StringName = &"closest_tree"
@export var was_chopping:StringName = &"was_chopping"
func _tick(delta: float) -> Status:
	var pos:Vector2= blackboard.get_var(closes_tree_var)
	if agent.tree_tilemap.get_cell_source_id(agent.tree_tilemap.local_to_map(pos)) != -1 or blackboard.get_var(was_chopping):
		return RUNNING
	return FAILURE
