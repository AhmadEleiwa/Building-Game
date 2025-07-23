extends Control
@onready var storage_capcity_count: Label = $Panel/StorageCapicityBar/StorageCapcityCount
@onready var food_count: Label = $Panel/FoodBar/FoodCount
@onready var wood_count: Label = $Panel/WoodBar/WoodCount


func _process(delta: float) -> void:
	food_count.text = str(GameManager.CurrentFood)
	wood_count.text = str(GameManager.CurrentWood)
	storage_capcity_count.text =str(GameManager.get_total_in_stotage()) + "/" + str(GameManager.StorageCapacity)
