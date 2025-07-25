extends BTCondition

func _tick(delta: float) -> Status:
	if agent.tree_tilemap == null:
		return FAILURE
	return SUCCESS
