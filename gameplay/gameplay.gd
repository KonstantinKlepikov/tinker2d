extends Node2D

var path_node = preload("res://points/path_node.tscn")
var line: Line2D # current line path
var path: Array[Node] # current path except start and end
var in_map: bool # is mouse in a map
var in_node # node where a mouse inside
var dragged # node to drag
const p_to_n := "%s/Gameplay/%s"


func _ready():
	line = Line2D.new()
	add_child(line)
	if get_tree().get_current_scene().get_name() == 'Tactic':
		for p in Gamevars.line:
			line.add_point(p)
			
	if get_tree().get_current_scene().get_name() == 'Strategic':
		in_node = false
		in_map = false
		dragged = false


func _process(_delta: float) -> void:	
	if (
		in_map == true 
		and get_tree().get_current_scene().get_name() == 'Strategic'
	):	
		# gui for add path nodes to map 
		# node not be add upon another node
		if Input.is_action_just_pressed("add_node") and not in_node:
			add_path_node()

		# delete node
		if Input.is_action_just_pressed("delete_node") and in_node:
			delete_path_node()

		# drag and drop node
		if Input.is_action_just_pressed("add_node") and in_node:
			dragged = in_node

		if Input.is_action_pressed("add_node") and dragged:
			drag()
			
		if Input.is_action_just_released("add_node") and dragged:
			dragged = false

	# display path
	if (
		get_tree().get_current_scene().get_name() == 'Strategic' 
		and len(path) != line.get_point_count()
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
	var pn = path_node.instantiate()
	pn.position = to_local(get_global_mouse_position())
	add_child(pn)
	pn.mouse_entered.connect(can_act_in_node.bind(pn))
	pn.mouse_exited.connect(cant_act_in_node)
	path.append(pn)


func delete_path_node():
	# delete path node
	path.erase(in_node)
	remove_child(in_node)
	in_node.queue_free()
	in_node = false
	
	
func drag():
	dragged.position = to_local(get_global_mouse_position())


func display_path() -> void:
	# display path
	line.clear_points()
	line.add_point(get_tree().get_root().get_node(
		p_to_n % [get_tree().get_current_scene().get_name(), "StartNode"]
		).position)
	for p in path:
		line.add_point(p.position)
	line.add_point(get_tree().get_root().get_node(
		p_to_n % [get_tree().get_current_scene().get_name(), "EndNode"]
		).position)
	if len(path) == 0:
		line.default_color = Color(1, 1, 1, 0)
	else:
		line.default_color = Color(1, 1, 1, 1)
	
	# save line path to dispaly in tactic
	if get_tree().get_current_scene().get_name() == 'Strategic':
		var line_positions: Array[Vector2] = []
		for i in range(line.get_point_count()):
			line_positions.append(line.get_point_position(i))
			Gamevars.line = line_positions
