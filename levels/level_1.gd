extends Node2D

var in_map: bool # is mouse in a map
var in_node # node where a mouse inside


func _ready():
	in_map = false
	in_node = false


func _process(_delta):
	pass
	

func cant_act_in_node() -> void:
	# set is mouse inside node
	in_node = false


func can_act_in_node(node: Node) -> void:
	# set is mouse out of node
	in_node = node


func _on_color_rect_mouse_entered():
	# set is mouse in map
	in_map = true


func _on_color_rect_mouse_exited():
		# set is mouse out of map
	in_map = false
