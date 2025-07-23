extends Building

@export var Capicty = 250

func _constructionEvent():
	GameManager.StorageCapacity += Capicty
