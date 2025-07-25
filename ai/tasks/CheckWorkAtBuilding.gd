extends BTCondition


func _tick(delta: float) -> Status:
	if agent.work_at_building is WoodCutter:
		return SUCCESS
	return FAILURE
