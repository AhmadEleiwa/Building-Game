extends Node2D

class_name Building


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
