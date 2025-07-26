extends Building
class_name Farm
const EALRY_STAGE = 0;
const LATE_STAGE = 1;

enum FarmStage{
	EALRY_STAGE,
	LATE_STAGE
}
@export var current_stage:FarmStage = EALRY_STAGE
@export var total_food:int = 100;
@export var amount_of_food_per_time = 50;

var current_supply_food:int =total_food
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D



func _process(delta: float) -> void:
	if current_stage == FarmStage.EALRY_STAGE:
		sprite_2d.play("lvl1")
	else:
		sprite_2d.play("lvl2")
	
	
func start_farm():
	$Timer.start()
func is_finished():
	return $Timer.is_stopped()
func collect():
	current_supply_food -= amount_of_food_per_time
	if current_supply_food <= 0:
		current_stage=FarmStage.EALRY_STAGE		
	return amount_of_food_per_time
func switch_stage():
	current_stage=FarmStage.LATE_STAGE		
	current_supply_food=total_food
func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		if GameManager.selected_npc.is_empty():
			return
		print(GameManager.selected_npc[0], " is a Farmer now at ", self)
		GameManager.selected_npc[0].work_at_building = self
		GameManager.selected_npc[0].current_task = NPC.Tasks.FARMER


func _on_timer_timeout() -> void:
	print("tick")
	if current_stage == FarmStage.EALRY_STAGE:
		switch_stage()
	$Timer.stop()
