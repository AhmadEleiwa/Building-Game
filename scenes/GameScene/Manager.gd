extends Node2D
#@onready var panel: Panel = $CanvasLayer/BuilderManager/Panel
@onready var panel: HBoxContainer = $CanvasLayer/BuilderManager/Panel/ScrollContainer2/HBoxContainer

@onready var builder_manager: Node2D = $"Builder Manager"
const structures = {
	"House":preload("res://scenes/House/house.tscn"),
	"WoodCutter":preload("res://scenes/woodcutter/woodcutter.tscn"),
	"Storage": preload("res://scenes/Storage/storage.tscn")
}
func _ready():
	# Get all buttons under the VBoxContainer and connect them
	for button in panel.get_children():
		var name = button.name
		if button is Button:
			button.pressed.connect(on_button_pressed.bind(name))



	
func on_button_pressed(name):
	if builder_manager.ghostedHouse == null:
		builder_manager.build(structures[name])
	else:
		builder_manager.ghostedHouse=null
	
