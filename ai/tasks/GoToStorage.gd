extends BTAction
@export var building_pos:StringName = &"building_pos"

func _tick(delta: float) -> Status:
	if agent.current_task != NPC.Tasks.FARMER:
		return FAILURE
	var pos:Vector2 = blackboard.get_var(building_pos)
	agent.set_target(pos)
	if agent.nav_agent.is_navigation_finished() and agent.nav_agent.distance_to_target() < 75 and not GameManager.is_storage_full():
		print("reached_target")
		return SUCCESS	
	return RUNNING
