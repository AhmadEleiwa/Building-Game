extends BTCondition

func _tick(delta: float) -> Status:
	if agent.tree_tilemap == null:
		print("not exist")
		return FAILURE
	return SUCCESS
