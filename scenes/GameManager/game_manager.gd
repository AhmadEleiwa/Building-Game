extends Node2D

const STRUCTURES_REQUIRMENTS = {
	"House": {"wood": 50, "food":0, "required_buildings":["Storage"] },
	"Storage": {"wood": 100, "food":0, "required_buildings":null },
	"WoodCutter": {"wood": 50, "food":0, "required_buildings":["Storage"]},
	"Farm": {"wood": 100, "food":50, "required_buildings":["Storage"]},
}
var buildings = []
var buildings_coords:Array[Vector2i] = []
var building_states = {
	"House":{"number":0},
	"Storage":{"number":0},
	"WoodCutter":{"number":0},
	"Farm":{"number":0}
}
var npc: Array[CharacterBody2D] = []
var selected_npc: Array[CharacterBody2D] = []
enum StrucutureState{
	CONSTRUCTION,
	SELECTION
}
var StorageCapacity:int = 300;

var CurrentFood:int = 100;
var CurrentWood:int = 200;


func is_building_exist(struct_name:String):
	return STRUCTURES_REQUIRMENTS.get(struct_name) != null

func get_total_in_stotage()->int:
	return CurrentFood + CurrentWood
func is_storage_full()->bool:
	return StorageCapacity == get_total_in_stotage()
func get_total_resources() -> int:
	return CurrentFood + CurrentWood

func add_food(amount: int) -> void:
	var available_space = StorageCapacity - get_total_resources()
	CurrentFood += min(amount, available_space)

func lose_food(amount: int) -> void:
	CurrentFood = max(CurrentFood - amount, 0)

func add_wood(amount: int) -> void:
	var available_space = StorageCapacity - get_total_resources()
	CurrentWood += min(amount, available_space)

func lose_wood(amount: int) -> void:
	CurrentWood = max(CurrentWood - amount, 0)

signal on_construct_buidling(coords:Array[Vector2i])
## take structure_name and return a massage and the status
## {massage:String, status:bool}
func is_strucutures_match_requirment(structure_name:String) -> Dictionary :
	var structure = STRUCTURES_REQUIRMENTS[structure_name];
	if structure['wood'] <= CurrentWood and structure['food'] <= CurrentFood :
		var buildings = structure['required_buildings']
		if buildings != null:
			for building in buildings:
				if building_states[building]['number'] == 0:
					return {"message":"This building require: "+ str(buildings),'status':false};
		return {"message": "", 'status':true}
	var text = "This building require: " 
	if structure['food'] != 0 and  structure['food']  > CurrentFood:
		text += str(structure['food'] -CurrentFood)  + "foods"
	if structure['wood'] != 0 and  structure['wood']  > CurrentFood:
		text += " and "+ str(structure['wood'] -CurrentFood)  + "woods"
	return  {"message": "This building require: " + text, 'status':false}
	"res://scenes/GameScene/node_2d.tscn"
func construct(structure_name:String):
	if is_building_exist(structure_name):
		lose_food(STRUCTURES_REQUIRMENTS[structure_name]['food'])
		lose_wood(STRUCTURES_REQUIRMENTS[structure_name]['wood'])
		building_states[structure_name]['number'] += 1

func add_building(building:Building, coords:Vector2i):
	buildings.append(building)
	
	var size= building.get_node('base_grid').global_scale

	var coords_to:Array[Vector2i]=  []
	var new_size = Vector2i(size.x*2, size.y*2)
	for x in range(0, new_size.x,1):
		for y in range(0, new_size.y,1):
			var coord = Vector2i(coords.x -x+size.x-1, coords.y-y+size.y-1)
			buildings_coords.append(coord)
			coords_to.append(coord)
	on_construct_buidling.emit(coords_to)
		
