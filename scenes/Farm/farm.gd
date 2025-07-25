extends Building
class_name Farm
const EALRY_STAGE = 0;
const LATE_STAGE = 1;

@export var current_stage:int = 0

## Time to grow and move to the next stage
@export var growth_time:int = 10; 

var time_accumulator := 0.0
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D

func _process(delta: float) -> void:
	time_accumulator += delta
	if time_accumulator >= growth_time:
		switch_stage()
		time_accumulator = 0.0	
func switch_stage():
	GameManager.add_food(100)
	if current_stage == EALRY_STAGE:
		current_stage = 1
		sprite_2d.play("lvl2")
	else:
		current_stage = 0
		sprite_2d.play("lvl1")
		
