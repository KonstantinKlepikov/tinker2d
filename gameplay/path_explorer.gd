extends Node2D

var hero_and_path: Path2D
var lvl: Node2D # map


func _ready():
	
	lvl = Gamevars.current_map
	add_child(lvl)

	hero_and_path = preload("res://actors/hero_path.tscn").instantiate()
	lvl.add_child(hero_and_path)
	
	# TODO: fixme
	$CanvasLayer/Bar/Weapon1.text = 'lazor'
	$CanvasLayer/Bar/Weapon2.text = 'rocket'
	hero_and_path.main_weapon = hero_and_path.weapons['lazor']
	hero_and_path.main_weapon.visible = true


func _process(_delta: float) -> void:
	$CanvasLayer/GameInfo/SpeedCoef.text = (
		"Speed coef: " + \
		str(hero_and_path.current_speed_coef  * \
		hero_and_path.current_bust_coef)
	)
	$CanvasLayer/GameInfo/EnergyConsume.text = (
		"Consume: " + str(snappedf(hero_and_path.energy_consume, 0.01))
	)
	$CanvasLayer/GameInfo/HeroEnergy.text = (
		"Energy: " + str(int(hero_and_path.hero_energy))
	)
	if hero_and_path.is_busted:
		$CanvasLayer/GameInfo/CanBust.text = "Cant bust"
	else:
		$CanvasLayer/GameInfo/CanBust.text = "Bust available"


func _on_run_pressed():
	if hero_and_path.hero_energy > 0 and not hero_and_path.is_at_end:
		hero_and_path.is_run = true


func _on_stop_pressed():
	hero_and_path.is_run = false


func _on_bust_pressed():
	if hero_and_path.hero_energy > 0 \
			and not hero_and_path.is_at_end \
			and not hero_and_path.is_busted:
		hero_and_path.is_busted = true
		hero_and_path.current_bust_coef = Gamevars.BUST_COEF
		hero_and_path.hero_energy -= Gamevars.BUST_ENERGY_REDUCE
		await get_tree().create_timer(Gamevars.BUST_DURATION).timeout
		hero_and_path.current_bust_coef = 1.0
		await get_tree().create_timer(Gamevars.BUST_TIMEOUT).timeout
		hero_and_path.is_busted = false


func _on_weapon_1_toggled(toggled_on: bool) -> void:
	# switch to lazor
	if toggled_on:
		hero_and_path.weapons['lazor'].visible = true
		hero_and_path.weapons['rocket'].visible = false
		hero_and_path.main_weapon = hero_and_path.weapons['lazor']
		$CanvasLayer/Bar/Weapon2.set_pressed_no_signal(false)
	else:
		$CanvasLayer/Bar/Weapon2.toggled(true)


func _on_weapon_2_toggled(toggled_on: bool) -> void:
	# switch to rocket
	if toggled_on:
		hero_and_path.weapons['lazor'].visible = false
		hero_and_path.weapons['rocket'].visible = true
		hero_and_path.main_weapon = hero_and_path.weapons['rocket']
		$CanvasLayer/Bar/Weapon1.set_pressed_no_signal(false)
	else:
		$CanvasLayer/Bar/Weapon1.toggled(true)
