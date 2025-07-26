extends Building
class_name  Storage
@export var Capicty = 250

func _constructionEvent():
	GameManager.StorageCapacity += Capicty
