extends Camera2D

var zoom_target: Vector2
var mouse_start_position = Vector2.ZERO
var camera_start_position = Vector2.ZERO
var is_draging: bool = false


func _ready():
	zoom_target = zoom


func _process(delta):
	Zoom(delta)
	CameraDrag()


func Zoom(delta) -> void:
	if Input.is_action_just_pressed("zoom_in"):
		zoom_target *= 1.1
	if Input.is_action_just_pressed("zoom_out"):
		zoom_target *= 0.9
		
	zoom = zoom.slerp(zoom_target, 10* delta)


func CameraDrag():
	if !is_draging and Input.is_action_just_pressed("camera_pan"):
		mouse_start_position = get_viewport().get_mouse_position()
		camera_start_position = position
		is_draging = true

	if is_draging and Input.is_action_just_released("camera_pan"):
		is_draging = false

	if is_draging:
		var move_vector = get_viewport().get_mouse_position() - mouse_start_position
		position = camera_start_position - move_vector * 1/zoom.x
