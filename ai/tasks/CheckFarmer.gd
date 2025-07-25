extends BTCondition


func _tick(delta: float) -> Status:
	if agent.work_at_building is Farm and agent.current_task == NPC.Tasks.FARMER:
		return SUCCESS
	return FAILURE
