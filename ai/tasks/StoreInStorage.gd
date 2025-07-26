extends BTAction

func _tick(delta: float) -> Status:
	var npc:NPC = agent
	npc.deliver_resource()
	return SUCCESS
		
