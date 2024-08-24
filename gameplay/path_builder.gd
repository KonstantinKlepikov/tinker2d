extends Node2D

var map_node = preload("res://levels/level_1.tscn")
var line: Line2D # current line path
var lvl: Node2D # map


func _ready():

	Gamevars.map_node = map_node
	lvl = map_node.instantiate()
	add_child(lvl)
	
	line = Line2D.new()
	add_child(line)


func _process(_delta: float) -> void:
	if len(lvl.path) != line.get_point_count():
		display_path()


func display_path() -> void:
	# display path
	line.clear_points()
	line.add_point(lvl.get_node("StartNode").position)
	for p in lvl.path:
		line.add_point(p.position)
	line.add_point(lvl.get_node("EndNode").position)
	if len(lvl.path) == 0:
		line.default_color = Color(1, 1, 1, 0)
	else:
		line.default_color = Color(1, 1, 1, 1)

	var line_positions: Array[Vector2] = []
	for i in range(line.get_point_count()):
		line_positions.append(line.get_point_position(i))
		Gamevars.line_positions = line_positions
