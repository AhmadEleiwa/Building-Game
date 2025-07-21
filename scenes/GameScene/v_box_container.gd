extends Control




@onready var timer: Timer = $"../../save label/Timer"

@onready var save_label: Label = $"../../save label"
@onready var color_rect: ColorRect = $"../../ColorRect"

func exit() -> void:
	get_tree().quit()
func save() -> void:
	save_label.show()
	timer.start()
		
func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ESCAPE:
			if visible == true:
				hide()
				color_rect.hide()
				get_tree().paused = false
			else:
				show()
				color_rect.show()
				
				get_tree().paused = true
				
				


func _on_timer_timeout() -> void:
	save_label.hide()
