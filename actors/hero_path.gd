extends Path2D

var current_speed_coef: float = Gamevars.TERRAIN_BASE_COEF
var current_bust_coef: float = 1.0
var hero_energy = Gamevars.HERO_START_ENERGY
var energy_consume: float = 0.0
var is_run := false # run or wait
var is_at_end := false
var is_first_run := true # init first placement of hero
var is_busted := false
var main_weapon: Node2D


func _ready():	
	build_hero_path()
	main_weapon = preload("res://weapons/lazor.tscn").instantiate()
	$PathFollow2D/Hero.add_child(main_weapon)


func _process(delta: float) -> void:
	# check can hero run and calculate speed of shift and energy redundance
	if is_first_run:
		$PathFollow2D.progress_ratio += 0.0
		is_first_run = false
	if is_run:
		$PathFollow2D.progress_ratio += (
			delta * Gamevars.HERO_SPEED * current_speed_coef * current_bust_coef
		)
		if $PathFollow2D.progress_ratio == 1.0:
			is_at_end = true
			is_run = false
		
	if is_run and hero_energy > 0:
		reduce_speed()
		if hero_energy <= 0:
			hero_energy = 0
			is_run = false
			
	if not is_run:
		energy_consume = 0.0


func build_hero_path():
	# build path from line vector
	for i in Gamevars.line.points:
		curve.add_point(i)
		

func reduce_speed():
	energy_consume = Gamevars.HERO_SPEED_REDUCER - current_speed_coef
	if energy_consume > Gamevars.MIN_HERO_SPEED:
		hero_energy -= energy_consume
	else:
		hero_energy -= Gamevars.MIN_HERO_SPEED
