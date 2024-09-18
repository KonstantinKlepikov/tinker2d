extends Camera2D

var zoom_target: Vector2
var mouse_start_position = Vector2.ZERO
var camera_start_position = Vector2.ZERO


func _ready():
	zoom_target = zoom


func _process(delta):
	make_zoom(delta)
	camera_drag()


func make_zoom(delta) -> void:
	# camera zoom
	if Input.is_action_just_pressed("zoom_in"):
		zoom_target *= 1.1
	if Input.is_action_just_pressed("zoom_out"):
		zoom_target *= 0.9		
	zoom = zoom.slerp(zoom_target, 10* delta)


func camera_drag():
	# camera drag
	if (
		!Gamevars.is_draging 
		and Input.is_action_just_pressed("left") 
		and !Gamevars.in_node
		and Gamevars.in_map
		):
		mouse_start_position = get_viewport().get_mouse_position()
		camera_start_position = position
		Gamevars.is_draging = true

	if Gamevars.is_draging and Input.is_action_just_released("left"):
		Gamevars.is_draging = false

	if Gamevars.is_draging:
		var move_vector = get_viewport().get_mouse_position() - mouse_start_position
		position = camera_start_position - move_vector * 1/zoom.x
