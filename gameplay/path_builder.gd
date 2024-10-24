extends Node2D

@export var tactic_scene: PackedScene

var start_map = preload("res://levels/level_1.tscn")
var path_node = preload("res://levels/path_nodes/path_node.tscn")
var line: Line2D # current line path
var lvl: Node2D # current map
var current_node: StaticBody2D # node where we operate (delete and drag)
var dragged: bool = false # is node dragged
var path: Array[StaticBody2D] # current path except start and end
var start: StaticBody2D # start node
var end: StaticBody2D # end node


func _ready():

	# add level	
	lvl = start_map.instantiate()
	add_child(lvl)
	
	# add path line
	line = preload("res://levels/line/path_line.tscn").instantiate()
	line.default_color = Color(1, 1, 1, 0)
	lvl.add_child(line)
	
	# start and end nodes
	start = path_node.instantiate()
	start.set_name("StartNode")
	start.position = Vector2(lvl.start_x, lvl.start_y)
	lvl.add_child(start)
	
	end = path_node.instantiate()
	end.set_name("EndNode")
	end.position = Vector2(lvl.end_x, lvl.end_y)
	lvl.add_child(end)
	
	# enemy
	for enemy in lvl.find_children("*Enemy*"):
		enemy.visible = false
		enemy.set_process(false)


func _process(_delta: float) -> void:
	
	if (
		get_tree().get_current_scene().get_name() == "Strategic" 
		and Gamevars.in_map
		):
		# gui for add path nodes to map 
		# node not be add upon another node
		if Input.is_action_just_pressed("right") and not Gamevars.in_node:
			add_path_node()

		# delete node
		if (
			Input.is_action_just_pressed("delete_node")
			or Input.is_action_just_pressed("right")
			and Gamevars.in_node
			):
			delete_path_node(current_node)

		# drag and drop node
		if Input.is_action_just_pressed("left") and Gamevars.in_node:
			dragged = true

		if Input.is_action_pressed("left") and dragged:
			drag(current_node)

		if Input.is_action_just_released("left") and dragged:
			dragged = false

	if line.get_point_count() <= 2:
		line.default_color = Color(1, 1, 1, 0)
		
	else:
		if lvl.line_inside_impass > 0:
			line.default_color = Color.CRIMSON
		else:
			line.default_color = Color.WHITE_SMOKE


func cant_act_in_node() -> void:
	# set is mouse inside node
	Gamevars.in_node = false


func can_act_in_node(node: StaticBody2D) -> void:
	# set is mouse out of node
	if node.name not in ["StartNode", "EndNode"]:
		Gamevars.in_node = true
		current_node = node


func add_path_node() -> void:
	# add path nodes to map
	var pn = path_node.instantiate()
	lvl.add_child(pn)
	pn.position = to_local(get_global_mouse_position())
	pn.mouse_entered.connect(can_act_in_node.bind(pn))
	pn.mouse_exited.connect(cant_act_in_node)
	path.append(pn)
	display_path()
	reshape_path()


func delete_path_node(node: StaticBody2D):
	# delete path node
	path.erase(node)
	lvl.remove_child(node)
	node.queue_free()
	Gamevars.in_node = false
	display_path()
	reshape_path()
	
	
func drag(node: StaticBody2D):
	node.position = to_local(get_global_mouse_position())
	display_path()
	reshape_path()


func display_path() -> void:
	# display path
	line.clear_points()
	line.add_point(start.position)
	for p in path:
		line.add_point(p.position)
	line.add_point(end.position)


func _on_clear_pressed():
	# clear the line
	for p in path:
		lvl.remove_child(p)
		p.queue_free()
	path.clear()
	display_path()
	reshape_path()


func _on_to_tactic_pressed():
	# change current game mode
	if lvl.line_inside_impass > 0 or line.get_point_count() <= 2:
		$CanvasLayer/ToTacticAlert.visible = true
		await get_tree().create_timer(3.0, false, false, true).timeout
		$CanvasLayer/ToTacticAlert.visible = false
	else:
		remove_child(lvl)
		Gamevars.current_map = lvl
		Gamevars.line = line
		Gamevars.in_node = false
		Gamevars.is_draging = false
		get_tree().change_scene_to_packed(tactic_scene)


func reshape_path() -> void:
	# reshape line path
	line.clear_shape()
	line.build_shape()
