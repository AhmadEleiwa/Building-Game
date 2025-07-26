extends BTAction
@export var building_pos:StringName = &"building_pos"

func _tick(delta: float) -> Status:
	if agent.current_task != NPC.Tasks.FARMER:
		return FAILURE
	
	for building in GameManager.buildings:
		if building is Storage:
			blackboard.set_var(building_pos, building.global_position)
			return SUCCESS
	return FAILURE
