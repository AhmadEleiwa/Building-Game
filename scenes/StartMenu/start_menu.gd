extends CanvasLayer

var screen_size;


@onready var label: Label = $Label



func start_game() -> void:
	get_tree().change_scene_to_file('res://scenes/GameScene/node_2d.tscn')


func exit() -> void:
	get_tree().quit()
