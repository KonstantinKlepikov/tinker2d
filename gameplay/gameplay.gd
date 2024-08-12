extends Node2D

var path_node = preload("res://points/path_node.tscn")
var line: Line2D # current line path
var path: Array[Node] # current path except start and end
var in_map: bool # is mouse in map
var in_node # node whrere is a mouse inside


func _ready():
	line = Line2D.new()
	add_child(line)
	in_node = false
	in_map = false


func _process(_delta: float) -> void:
	
	# gui for add path nodes to map 
	# node not be add upon another node
	if not in_node:
		add_path_node()
		
	# delete node
	if in_node:
		delete_path_node()
	
	# get all path nodes
	var path_nodes_group = get_tree().get_nodes_in_group("path_nodes_group")
	
	# rebuild path if number of nodes changes
	if (
		len(path_nodes_group) != line.get_point_count() 
		and len(path_nodes_group) > 2
	):
		display_path()


func _on_texture_rect_mouse_entered():
	# set is mouse in map
	in_map = true


func _on_texture_rect_mouse_exited():
	# set is mouse out of map
	in_map = false
	

func cant_act_in_node() -> void:
	# set is mouse inside node
	in_node = false
	
func can_act_in_node(node: Node) -> void:
	# set is mouse out of node
	in_node = node


func add_path_node() -> void:
	# add path nodes to map
	if (
		Input.is_action_just_pressed("add_node") 
		and get_tree().get_current_scene().get_name() == 'Strategic'
		and in_map == true
	):
		var pn = path_node.instantiate()
		pn.position = to_local(get_global_mouse_position())
		add_child(pn)
		pn.mouse_entered.connect(can_act_in_node.bind(pn))
		pn.mouse_exited.connect(cant_act_in_node)
		path.append(pn)


func delete_path_node():
	# delete path node
	if (
		Input.is_action_just_pressed("delete_node") 
		and get_tree().get_current_scene().get_name() == 'Strategic'
	):
		path.erase(in_node)
		remove_child(in_node)
		in_node.queue_free()


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
