extends BTAction


func _tick(delta: float) -> Status:
	if agent.current_task != NPC.Tasks.FARMER:
		return FAILURE
	agent.set_target(agent.work_at_building.global_position)
	if agent.nav_agent.is_navigation_finished() and agent.nav_agent.distance_to_target() < 64 and not GameManager.is_storage_full():
		print("reached_target")
		if agent.work_at_building.is_finished() and agent.work_at_building.current_stage == Farm.FarmStage.EALRY_STAGE:
			print("start farming")
			agent.work_at_building.start_farm()
		return SUCCESS	

	return RUNNING
