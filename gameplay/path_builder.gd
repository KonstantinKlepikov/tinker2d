extends Node2D

var path_node = preload("res://levels/path_nodes/path_node.tscn")
var map_node = preload("res://levels/level_1.tscn")
var line: Line2D # current line path
var path: Array[Node] # current path except start and end
var dragged: bool # node to drag
var lvl: Node2D # map


func _ready():

	Gamevars.map_node = map_node
	lvl = map_node.instantiate()
	add_child(lvl)
	
	line = Line2D.new()
	add_child(line)

	dragged = false


func _process(_delta: float) -> void:
	if lvl.in_map:
		# gui for add path nodes to map 
		# node not be add upon another node
		if Input.is_action_just_pressed("add_node") and not lvl.in_node:
			add_path_node()

		# delete node
		if Input.is_action_just_pressed("delete_node") and lvl.in_node:
			delete_path_node()

		# drag and drop node
		if Input.is_action_just_pressed("add_node") and lvl.in_node:
			dragged = true

		if Input.is_action_pressed("add_node") and dragged:
			drag()
			
		if Input.is_action_just_released("add_node") and dragged:
			dragged = false

	if len(path) != line.get_point_count():
		display_path()


func add_path_node() -> void:
	# add path nodes to map
	var pn = path_node.instantiate()
	pn.position = to_local(get_global_mouse_position())
	pn.mouse_entered.connect(lvl.can_act_in_node.bind(pn))
	pn.mouse_exited.connect(lvl.cant_act_in_node)
	lvl.add_child(pn)
	path.append(pn)


func delete_path_node():
	# delete path node
	path.erase(lvl.in_node)
	remove_child(lvl.in_node)
	lvl.in_node.queue_free()
	lvl.in_node = false
	
	
func drag():
	lvl.in_node.position = to_local(get_global_mouse_position())


func display_path() -> void:
	# display path
	line.clear_points()
	line.add_point(lvl.get_node("StartNode").position)
	for p in path:
		line.add_point(p.position)
	line.add_point(lvl.get_node("EndNode").position)
	if len(path) == 0:
		line.default_color = Color(1, 1, 1, 0)
	else:
		line.default_color = Color(1, 1, 1, 1)

	var line_positions: Array[Vector2] = []
	for i in range(line.get_point_count()):
		line_positions.append(line.get_point_position(i))
		Gamevars.line = line_positions
