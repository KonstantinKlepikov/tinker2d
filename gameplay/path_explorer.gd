extends Node2D

var hero_and_path: Path2D
var lvl: Node2D # map


func _ready():
	
	# level
	lvl = Gamevars.current_map
	add_child(lvl)

	# hero
	hero_and_path = preload("res://actors/hero_path.tscn").instantiate()
	lvl.add_child(hero_and_path)
	
	hide_strategic()
	
	# weapons
	$CanvasLayer/Bar/Weapon1.text = 'lazor'
	$CanvasLayer/Bar/Weapon2.text = 'rocket'
	hero_and_path.main_weapon = hero_and_path.weapons['lazor']
	hero_and_path.main_weapon.visible = true
	
	# enemies
	for enemy in lvl.find_children("*Enemy*"):
		enemy.visible = true
		enemy.set_process(true)


func _process(_delta: float) -> void:
	# global hero position for enemy targets
	Gamevars.hero_pos = hero_and_path.get_node("PathFollow2D/Hero").global_position
	
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
		
	# change aiming cross
	if Gamevars.current_enemy:
		$CanvasLayer/Cross.global_position = get_viewport().get_mouse_position()
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		$CanvasLayer/Cross.visible = true
	else:
		$CanvasLayer/Cross.visible = false
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		Input.set_custom_mouse_cursor(null)
	
	# aiming of enemy
	if Input.is_action_just_pressed("left") and Gamevars.current_enemy:
		aim_enemy(Gamevars.current_enemy)


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
		_on_weapon_2_toggled(true)
		$CanvasLayer/Bar/Weapon2.set_pressed_no_signal(true)


func _on_weapon_2_toggled(toggled_on: bool) -> void:
	# switch to rocket
	if toggled_on:
		hero_and_path.weapons['lazor'].visible = false
		hero_and_path.weapons['rocket'].visible = true
		hero_and_path.main_weapon = hero_and_path.weapons['rocket']
		$CanvasLayer/Bar/Weapon1.set_pressed_no_signal(false)
	else:
		_on_weapon_1_toggled(true)
		$CanvasLayer/Bar/Weapon1.set_pressed_no_signal(true)
		
		
func hide_strategic() -> void:
	for n in lvl.get_children():
		if (
			"path_nodes_group" in n.get_groups() 
			and n.name != "StartNode" 
			and n.name != "EndNode"
			) or "spawn_zone" in n.get_groups():
			n.visible = false
			

func aim_enemy(enemy: Area2D) -> void:
	# add target enemy to aiming queue or remove it from queue
	var enemy_ind = hero_and_path.main_weapon.aiming_queue.find(enemy)
	if enemy_ind != -1:
		hero_and_path.main_weapon.aiming_queue.remove_at(enemy_ind)
	else:
		hero_and_path.main_weapon.aiming_queue.append(enemy)
