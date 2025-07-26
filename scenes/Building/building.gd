extends Node2D

class_name Building
@onready var area_2d: Area2D = $Area2D

func _ready() -> void:
	area_2d.input_event.connect(_on_area_2d_input_event)
@export var state= GameManager.StrucutureState.SELECTION
func changeState(new_state:GameManager.StrucutureState):

	if state != GameManager.StrucutureState.CONSTRUCTION:
		_constructionEvent()
	elif state != GameManager.StrucutureState.SELECTION:
		_selectionEvent()
	state = new_state

func _constructionEvent():
	pass
func _selectionEvent():
	pass
func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	pass
