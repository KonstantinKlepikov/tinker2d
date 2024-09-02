extends Node2D

var in_map: bool = false # is mouse in a map
@export var start_x: float
@export var start_y: float
@export var end_x: float
@export var end_y: float
var line_inside_impass := 0


func _on_color_rect_mouse_entered() -> void:
	# set is mouse in map
	in_map = true


func _on_color_rect_mouse_exited() -> void:
	# set is mouse out of map
	in_map = false


func _on_terrain_impass_area_entered(area):
	# mark impossible line enter
	if area.name == "LinePathArea2D":
		line_inside_impass += 1


func _on_terrain_impass_area_exited(area):
	# mark impossible line exit
	if area.name == "LinePathArea2D":
		line_inside_impass -= 1
