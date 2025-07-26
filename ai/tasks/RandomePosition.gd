extends BTAction

@export var rand_pos: StringName = &"rand_pos"
@export var step_distance: float = 80.0  # Max movement step toward (0, 0)

func _tick(delta: float) -> Status:
	if agent == null or blackboard == null:
		push_warning("Agent or blackboard is null")
		return FAILURE

	if not agent.nav_agent.is_navigation_finished():
		return FAILURE

	var direction_to_origin = (Vector2.ZERO - agent.global_position).normalized()
	var random_factor = randf_range(0.5, 1.0)  # Slight randomness in magnitude
	var random_offset = direction_to_origin * step_distance * random_factor

	# Optional: Add slight jitter to make it less robotic
	random_offset = random_offset+ Vector2(randi_range(-10, 10), randi_range(-10, 10))

	var target_position = agent.global_position + random_offset
	blackboard.set_var(rand_pos, target_position)

	return SUCCESS
