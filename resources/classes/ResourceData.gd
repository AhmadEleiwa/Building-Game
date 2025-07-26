class_name ResourceData
extends Resource

enum ResourceType{
	WOOD,
	FOOD,
	NONE
}

@export var type:ResourceType = ResourceType.NONE
@export var amount: int = 0
func _init(p_type:ResourceType = ResourceType.NONE, p_amount: int = 0):
	type = p_type
	amount = p_amount
func put_resource(new_type :ResourceType= ResourceType.NONE, new_amount:int=0):
	type = new_type
	amount = new_amount
func clear():
	put_resource()
