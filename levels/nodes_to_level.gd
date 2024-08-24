extends Node2D

var path_node = preload("res://levels/path_nodes/path_node.tscn")
var in_map: bool = false # is mouse in a map
var in_node = false # node where a mouse inside
var dragged: bool = false # node to drag
var path: Array[Node] # current path except start and end


func _ready():
	pass


func _process(_delta) -> void:
	if get_tree().get_current_scene().get_name() == "Strategic" and in_map:
		# gui for add path nodes to map 
		# node not be add upon another node
		if Input.is_action_just_pressed("add_node") and not in_node:
			add_path_node()

		# delete node
		if Input.is_action_just_pressed("delete_node") and in_node:
			delete_path_node()

		# drag and drop node
		if Input.is_action_just_pressed("add_node") and in_node:
			dragged = true

		if Input.is_action_pressed("add_node") and dragged:
			drag()
			
		if Input.is_action_just_released("add_node") and dragged:
			dragged = false


func cant_act_in_node() -> void:
	# set is mouse inside node
	in_node = false


func can_act_in_node(node: Node) -> void:
	# set is mouse out of node
	in_node = node


func _on_color_rect_mouse_entered() -> void:
	# set is mouse in map
	in_map = true


func _on_color_rect_mouse_exited() -> void:
		# set is mouse out of map
	in_map = false
	
	
func add_path_node() -> void:
	# add path nodes to map
	var pn = path_node.instantiate()
	add_child(pn)
	pn.position = to_local(get_global_mouse_position())
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
	in_node.position = to_local(get_global_mouse_position())
