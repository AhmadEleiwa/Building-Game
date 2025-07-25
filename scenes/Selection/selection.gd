extends Area2D
@onready var shape: Shape2D = $CollisionShape2D.shape
@onready var color_rect: ColorRect = $ColorRect
@onready var collision_shape_2d_2: CollisionShape2D = $CollisionShape2D2
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var start_pos := Vector2.ZERO
var dragging := false
@export var enable_filtering:bool = true
@export var is_in_group:String = "npc"
@export var raycast_areas :bool = false
@export var raycast_bodies:bool = true

signal selected(selections:Array[Node2D])
func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				start_pos = get_global_mouse_position()
				collision_shape_2d_2.disabled= false
				collision_shape_2d.disabled= false
				collision_shape_2d_2.global_position = start_pos
				select_npcs()
				dragging = true
				show()
				color_rect.global_position = start_pos
				color_rect.size = Vector2.ZERO
			else:
				dragging = false
				select_npcs()
				shape.extents = Vector2.ZERO
				hide()
				collision_shape_2d_2.disabled= true
				collision_shape_2d.disabled= true
				

	elif event is InputEventMouseMotion and dragging:
		var current_pos = get_global_mouse_position()
		var rect = Rect2(start_pos, current_pos - start_pos).abs()
		global_position = rect.position + rect.size / 2.0
		shape.extents = rect.size / 2.0
		color_rect.global_position = rect.position - rect.size /2
		color_rect.size = rect.size*2

func select_npcs():
	var selections = []
	if enable_filtering:
		if raycast_bodies:
			for body in get_overlapping_bodies():
				if body.is_in_group(is_in_group):
					selections.append(body)
		if raycast_areas:
			for area in get_overlapping_areas():
				if area.is_in_group(is_in_group):
					selections.append(area)
	else:
		if raycast_bodies:
			selected.emit(get_overlapping_bodies())
		if raycast_areas:
			selected.emit(get_overlapping_areas())

	selected.emit(selections)
	#GameManager.selected_npc = []
	#var h_box_container = scrol_view.get_child(0)
	#var children = h_box_container.get_children()
	#for c in range(children.size()):
		#children[c].queue_free()
	#var bodis = 
	#for c in range(bodis.size()):
		#if bodis[c].is_in_group(is_in_group):
			#GameManager.selected_npc.append( bodis[c])
			#h_box_container.add_child(ITEM.instantiate())
			#if  bodis[c] not in GameManager.npc:
				#GameManager.npc.append( bodis[c])
	#
