extends Building

var time_accumulator := 0.0
@export var gather_time: int = 5
func _process(delta: float) -> void:
	time_accumulator += delta
	if time_accumulator >= gather_time:
		collect_wood()
		time_accumulator = 0.0	
func collect_wood():
	print("fk")
	if state == GameManager.StrucutureState.CONSTRUCTION:	
		GameManager.add_wood(50)
