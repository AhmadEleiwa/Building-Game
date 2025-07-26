extends BTAction


func _tick(delta: float) -> Status:

	if agent.current_task != NPC.Tasks.FARMER:
		return FAILURE
	
	var farm:Farm = agent.work_at_building
	if farm.current_stage == farm.FarmStage.LATE_STAGE:
		return SUCCESS
	return RUNNING
