extends Camera2D

var dragging := false
var drag_start := Vector2.ZERO
var drag_speed := 0.5
var zoom_limit := Vector2(1, 2)

var target_zoom := Vector2(1, 1)
var zoom_speed := 5.0 # Smoothness factor

func _ready():
	zoom = target_zoom

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_MIDDLE and event.pressed:
			dragging = true
			drag_start = event.position
		elif event.button_index == MOUSE_BUTTON_MIDDLE and not event.pressed:
			dragging = false
		elif event.is_released():
			dragging = false
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
			var new_zoom = target_zoom + Vector2(0.1, 0.1)
			target_zoom = Vector2(
				clamp(new_zoom.x, zoom_limit.x, zoom_limit.y),
				clamp(new_zoom.y, zoom_limit.x, zoom_limit.y)
			)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			var new_zoom = target_zoom - Vector2(0.1, 0.1)
			target_zoom = Vector2(
				clamp(new_zoom.x, zoom_limit.x, zoom_limit.y),
				clamp(new_zoom.y, zoom_limit.x, zoom_limit.y)
			)

	elif event is InputEventMouseMotion and dragging:
		position -= event.relative * drag_speed  # Move camera opposite to drag direction

func _process(delta):
	# Smoothly interpolate the zoom
	zoom = lerp(zoom, target_zoom, delta * zoom_speed)

	#RenderingServer.global_shader_parameter_set(shader_param_name, get_local_mouse_position())
