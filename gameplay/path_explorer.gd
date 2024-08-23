extends Node2D

var line: Line2D # current line path
var lvl: Node2D # map


func _ready():
	lvl = Gamevars.map_node.instantiate()
	add_child(lvl)
	
	line = Line2D.new()
	add_child(line)
	display_path()


func _process(_delta: float) -> void:
	pass


func display_path() -> void:
	for p in Gamevars.line_positions:
		line.add_point(p)
	if line.get_point_count() == 2:
		line.default_color = Color(1, 1, 1, 0)
	else:
		line.default_color = Color(1, 1, 1, 1)
