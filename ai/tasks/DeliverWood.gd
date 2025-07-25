extends BTAction
@export var wood_amount:int = 10

func _tick(delta: float) -> Status:
	if agent.current_task != agent.Tasks.WOOD_CUTEER:
		return FAILURE
	GameManager.add_wood(wood_amount)
	return SUCCESS
