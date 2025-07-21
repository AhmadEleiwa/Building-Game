extends CanvasLayer

var screen_size;



@onready var fps: Label = $FPS

func _process(delta: float) -> void:
	fps.text = str(Engine.get_frames_per_second()) + " FPS"


func _on_button_pressed() -> void:
	print("test")
