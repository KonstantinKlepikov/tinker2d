extends Node2D

var in_rect: bool = true
var path_node = preload("res://points/path_node.tscn")


func _process(_delta: float) -> void:
	add_path_node()


func _on_texture_rect_mouse_entered():
	in_rect = true


func _on_texture_rect_mouse_exited():
	in_rect = false


func add_path_node():
	if (
		Input.is_action_just_pressed("add_node") 
		and get_tree().get_current_scene().get_name() == 'Strategic'
		and in_rect == true
	):
		var pn = path_node.instantiate()
		pn.position = to_local(get_global_mouse_position())
		add_child(pn)
