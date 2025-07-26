extends BTAction
@export var rand_pos:StringName = &"rand_pos"
func _tick(delta: float) -> Status:
	agent.set_target(blackboard.get_var(rand_pos))
	if agent.nav_agent.is_navigation_finished():
		return SUCCESS
	return RUNNING
