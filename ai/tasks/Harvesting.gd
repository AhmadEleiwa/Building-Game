extends BTAction

func _tick(delta: float) -> Status:
	if agent.current_task != NPC.Tasks.FARMER:
		return FAILURE
	var npc:NPC = agent
	var x = agent.work_at_building.collect()
	print(x)
	npc.inventory.put_resource(ResourceData.ResourceType.FOOD, x) 
	return SUCCESS
