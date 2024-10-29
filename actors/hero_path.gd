extends Path2D

@export var current_speed_coef: float = Gamevars.TERRAIN_BASE_COEF
@export var hero_energy: float = Gamevars.HERO_START_ENERGY

var current_bust_coef: float = 1.0
var current_hero_bust_energy_consume: float = 0.0
var energy_consume: float = 0.0
var is_run := false # run or wait
var is_at_end := false
var is_busted := false
var main_weapon: Node2D
var weapons: Dictionary


func _ready():	
	# TODO: make a more flexible way to add weapons
	weapons['lazor'] = preload("res://weapons/lazor.tscn").instantiate()
	weapons['rocket'] = preload("res://weapons/rocket.tscn").instantiate()
	$PathFollow2D/Hero.add_child(weapons['lazor'])
	$PathFollow2D/Hero.add_child(weapons['rocket'])
	build_hero_path()


func _process(delta: float) -> void:
	if is_run:
		Gamevars.is_hero_on_start_or_end = false
		$PathFollow2D.progress_ratio += (
			delta * Gamevars.HERO_SPEED * current_speed_coef * current_bust_coef
		)
		# stop at end node
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
		
	# aiming of enemy
	if Input.is_action_just_pressed("left") and Gamevars.current_mouse_in_enemy:
		aim_enemy(Gamevars.current_mouse_in_enemy)
	
	fire_with_each_weapon()


func build_hero_path():
	curve.clear_points()
	for i in Gamevars.line_points:
		curve.add_point(i)
	$PathFollow2D.progress_ratio += 0.0
	Gamevars.is_hero_on_start_or_end = true
	Gamevars.is_hero_empty = false
	Gamevars.aiming_queue.clear()


func reduce_speed():
	energy_consume = Gamevars.HERO_SPEED_REDUCER - current_speed_coef \
	+ current_hero_bust_energy_consume
	if energy_consume > 0:
		hero_energy -= energy_consume
	else:
		hero_energy -= Gamevars.MIN_HERO_SPEED


func aim_enemy(enemy: Area2D) -> void:
	# add or remove enemy to aiming_queue
	var key = enemy.name + "," + main_weapon.name
	var enemy_in_q = Gamevars.aiming_queue.get(key)
	if enemy_in_q:
		Gamevars.aiming_queue.erase(key)
	else:
		if enemy in main_weapon.in_aiming_range:
			Gamevars.aiming_queue[key] = enemy


func fire_with_each_weapon() -> void:
	if is_run and hero_energy > 0:
		# fire with each weapon
		for weapon in weapons.values():
			# fire only to first enemy in queue
			for key in Gamevars.aiming_queue.keys():
				if weapon.name in key:
					weapon.fire(Gamevars.aiming_queue[key])
					break
