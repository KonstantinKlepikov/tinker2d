extends Node2D

var hero_path = preload("res://actors/hero_path.tscn")
var hero_path_in: Path2D
var line: Line2D # for display path of hero
var lvl: Node2D # map
var run:= false # run or stop gameplay


func _ready():
	lvl = Gamevars.map_node.instantiate()
	add_child(lvl)
	
	line = Line2D.new()
	lvl.add_child((line))

	hero_path_in = hero_path.instantiate()
	lvl.add_child(hero_path_in)

	display_line()
	
	
func _process(_delta: float) -> void:
	hero_path_in.speed_coef = lvl.speed_coef
	if lvl.speed_coef:
		$CanvasLayer/SpeedCoef.text = "Speed coef: " + str(lvl.speed_coef)


func display_line() -> void:
	for p in Gamevars.line_positions:
		line.add_point(p)
		hero_path_in.curve.add_point(p)


func _on_run_pressed():
	hero_path_in.run = true


func _on_stop_pressed():
	hero_path_in.run = false
