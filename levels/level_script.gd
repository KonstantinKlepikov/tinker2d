extends Node2D

var in_map: bool = false # is mouse in a map
@export var start_x: float
@export var start_y: float
@export var end_x: float
@export var end_y: float


func _ready():
	pass


func _process(_delta) -> void:
	pass


func _on_color_rect_mouse_entered() -> void:
	# set is mouse in map
	in_map = true


func _on_color_rect_mouse_exited() -> void:
		# set is mouse out of map
	in_map = false
