extends Node2D

var hero_path_base = preload("res://actors/hero_path.tscn")
var hero_path: Path2D
var lvl: Node2D # map


func _ready():
	
	lvl = Gamevars.current_map
	add_child(lvl)

	hero_path = hero_path_base.instantiate()
	lvl.add_child(hero_path)

	build_hero_path()
	
	
func _process(_delta: float) -> void:
	# move a hero
	hero_path.speed_coef = lvl.speed_coef
	# change speed and energy and display
	if lvl.speed_coef:
		$CanvasLayer/GameInfo/SpeedCoef.text = "Speed: " + str(lvl.speed_coef)
		if hero_path.run and lvl.energy > 0:
			lvl.energy -= lvl.speed_coef
			if lvl.energy <= 0:
				lvl.energy = 0
				hero_path.run = false
	$CanvasLayer/GameInfo/HeroEnergy.text = "Energy: " + str(lvl.energy)
	
		
func build_hero_path():
	for i in Gamevars.line.points:
		hero_path.curve.add_point(i)


func _on_run_pressed():
	if lvl.energy > 0:
		hero_path.run = true


func _on_stop_pressed():
	hero_path.run = false
