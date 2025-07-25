extends BTCondition


func _tick(delta: float) -> Status:
	if  agent.work_at_building is WoodCutter and agent.current_task == NPC.Tasks.WOOD_CUTEER:
		return SUCCESS
	return FAILURE
