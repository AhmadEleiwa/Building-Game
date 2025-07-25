extends BTAction
@export var closes_tree_var:StringName = &"closest_tree"

func _tick(delta: float) -> Status:
	if agent.current_task != agent.Tasks.WOOD_CUTEER:
		return FAILURE
	var closest_tree:Vector2 = agent.find_closest_tree()
	if not closest_tree:
		return FAILURE
	blackboard.set_var(closes_tree_var, closest_tree)
	return SUCCESS
