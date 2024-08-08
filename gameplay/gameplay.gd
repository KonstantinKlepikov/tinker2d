extends Node2D

var in_rect: bool = true
var path_node = preload("res://points/path_node.tscn")
var line: Line2D # current line path
var path: Array[Node] # current path except start and end


func _ready():
	line = Line2D.new()
	add_child(line)


func _process(_delta: float) -> void:
	
	# gui for add path nodes to map
	add_path_node()
	
	# get all path nodes
	var path_nodes_group = get_tree().get_nodes_in_group("path_nodes_group")
	
	# rebuild path if number of nodes changes
	if (
		len(path_nodes_group) != line.get_point_count() 
		and len(path_nodes_group) > 2
	):
		display_path()


func _on_texture_rect_mouse_entered():
	in_rect = true


func _on_texture_rect_mouse_exited():
	in_rect = false


func add_path_node() -> void:
	# add path nodes to map
	if (
		Input.is_action_just_pressed("add_node") 
		and get_tree().get_current_scene().get_name() == 'Strategic'
		and in_rect == true
	):
		var pn = path_node.instantiate()
		pn.position = to_local(get_global_mouse_position())
		add_child(pn)
		path.append(pn)


func display_path() -> void:
	# display path
	var p_to_n = "%s/Gameplay/%s"
	line.clear_points()
	line.add_point(get_tree().get_root().get_node(
		p_to_n % [get_tree().get_current_scene().get_name(), "StartNode"]
		).position)
	for p in path:
		line.add_point(p.position)
	line.add_point(get_tree().get_root().get_node(
		p_to_n % [get_tree().get_current_scene().get_name(), "EndNode"]
		).position)
