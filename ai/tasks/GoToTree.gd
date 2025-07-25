extends BTAction

@export var closest_tree:StringName = &"closest_tree"


func _tick(delta: float) -> Status:
	if agent.current_task != agent.Tasks.WOOD_CUTEER:
		return FAILURE
	if not agent.is_npc_moving():
		agent.set_target(blackboard.get_var(closest_tree))
	if agent.nav_agent.is_navigation_finished() and agent.nav_agent.distance_to_target() < 64:
		return SUCCESS
	
	else:
		return RUNNING
