extends Node2D

var map_node = preload("res://levels/level_1.tscn")
var path_node = preload("res://levels/path_nodes/path_node.tscn")
var line: Line2D # current line path
var lvl: Node2D # map
var in_node := false # node where a mouse inside
var current_node: StaticBody2D
var dragged: bool = false # node to drag
var path: Array[StaticBody2D] # current path except start and end
var start: StaticBody2D
var end: StaticBody2D


func _ready():

	Gamevars.map_node = map_node
	lvl = map_node.instantiate()
	add_child(lvl)
	
	line = Line2D.new()
	lvl.add_child(line)
	
	start = path_node.instantiate()
	start.set_name("StartNode")
	start.position = Vector2(lvl.start_x, lvl.start_y)
	lvl.add_child(start)
	
	end = path_node.instantiate()
	end.set_name("EndNode")
	end.position = Vector2(lvl.end_x, lvl.end_y)
	lvl.add_child(end)


func _process(_delta: float) -> void:
	
	if get_tree().get_current_scene().get_name() == "Strategic" and lvl.in_map:
		# gui for add path nodes to map 
		# node not be add upon another node
		if Input.is_action_just_pressed("add_node") and not in_node:
			add_path_node()

		# delete node
		if Input.is_action_just_pressed("delete_node") and in_node:
			delete_path_node(current_node)

		# drag and drop node
		if Input.is_action_just_pressed("add_node") and in_node:
			dragged = true

		if Input.is_action_pressed("add_node") and dragged:
			drag(current_node)
			
		if Input.is_action_just_released("add_node") and dragged:
			dragged = false
	
	if len(path) != line.get_point_count():
		display_path()


func cant_act_in_node() -> void:
	# set is mouse inside node
	in_node = false


func can_act_in_node(node: StaticBody2D) -> void:
	# set is mouse out of node
	if node.name not in ["StartNode", "EndNode"]:
		in_node = true
		current_node = node


func add_path_node() -> void:
	# add path nodes to map
	var pn = path_node.instantiate()
	lvl.add_child(pn)
	pn.position = to_local(get_global_mouse_position())
	pn.mouse_entered.connect(can_act_in_node.bind(pn))
	pn.mouse_exited.connect(cant_act_in_node)
	path.append(pn)


func delete_path_node(node: StaticBody2D):
	# delete path node
	path.erase(node)
	lvl.remove_child(node)
	node.queue_free()
	in_node = false
	
	
func drag(node: StaticBody2D):
	node.position = to_local(get_global_mouse_position())


func display_path() -> void:
	# display path
	line.clear_points()
	line.add_point(start.position)
	for p in path:
		line.add_point(p.position)
	line.add_point(end.position)
	if len(path) == 0:
		line.default_color = Color(1, 1, 1, 0)
	else:
		line.default_color = Color(1, 1, 1, 1)

	var line_positions: Array[Vector2] = []
	for i in range(line.get_point_count()):
		line_positions.append(line.get_point_position(i))
		Gamevars.line_positions = line_positions
