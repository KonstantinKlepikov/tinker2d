extends Path2D

var current_speed_coef: float = Gamevars.TERRAIN_BASE_COEF
var current_bust_coef: float = 1.0
var hero_energy = Gamevars.HERO_START_ENERGY
var energy_consume: float = 0.0
var is_run := false # run or wait
var is_at_end := false
var is_busted := false
var main_weapon: Node2D
var weapons: Dictionary


func _ready():	
	build_hero_path()
	weapons['lazor'] = preload("res://weapons/lazor.tscn").instantiate()
	weapons['rocket'] = preload("res://weapons/rocket.tscn").instantiate()
	$PathFollow2D/Hero.add_child(weapons['lazor'])
	$PathFollow2D/Hero.add_child(weapons['rocket'])
	
	$PathFollow2D.progress_ratio += 0.0
	Gamevars.is_hero_on_start_or_end = true


func _process(delta: float) -> void:

	if is_run:
		Gamevars.is_hero_on_start_or_end = false
		$PathFollow2D.progress_ratio += (
			delta * Gamevars.HERO_SPEED * current_speed_coef * current_bust_coef
		)
		if $PathFollow2D.progress_ratio == 1.0:
			Gamevars.is_hero_on_start_or_end = true
			is_run = false
			is_at_end = true
		
	if is_run and hero_energy > 0:
		reduce_speed()
	
	if is_run and hero_energy <= 0:
		hero_energy = 0
		is_run = false
		Gamevars.is_hero_empty = true
			
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
