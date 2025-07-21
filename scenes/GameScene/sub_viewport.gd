extends SubViewport
@onready var camera_2d: Camera2D = $"../../../Camera2D"


func _ready() -> void:
	world_2d =get_tree().root.world_2d
	
func _physics_process(delta: float) -> void:
	$Camera2D2.position = camera_2d.position
