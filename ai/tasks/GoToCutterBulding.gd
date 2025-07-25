extends BTAction


func _tick(delta: float) -> Status:
	if agent.current_task != agent.Tasks.WOOD_CUTEER:
		return FAILURE
	if agent.work_at_building is not WoodCutter:
		return RUNNING
	agent.set_target(agent.work_at_building.global_position)	
	if agent.nav_agent.is_navigation_finished() and agent.nav_agent.distance_to_target() < 64:
		
		return SUCCESS
	print("waiting woodcutter be constructed")
	return RUNNING
