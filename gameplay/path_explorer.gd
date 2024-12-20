extends Node2D

var hero_and_path: Path2D
var lvl: Node2D # map


func _ready():
	# level
	lvl = Gamevars.current_map
	add_child(lvl)

	# hero
	hero_and_path = load("res://actors/hero_path.tscn").instantiate()
	lvl.add_child(hero_and_path)
	
	hide_strategic()
	
	# weapons
	# TODO: get names from a weapons dict and add programaticaluy
	# buttons and signals
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
	
	# display speed multiplication coef
	$CanvasLayer/GameInfo/SpeedCoef.text = (
		"Speed coef: " + \
		str(hero_and_path.current_speed_coef  * \
		hero_and_path.current_bust_coef)
	)
	# display energy consume rate
	$CanvasLayer/GameInfo/EnergyConsume.text = (
		"Consume: " + str(snappedf(hero_and_path.energy_consume, 0.01))
	)
	# display current energy
	$CanvasLayer/GameInfo/HeroEnergy.text = (
		"Energy: " + str(int(hero_and_path.hero_energy))
	)
		
	# change aiming cross
	if Gamevars.current_mouse_in_enemy:
		$CanvasLayer/Cross.global_position = get_viewport().get_mouse_position()
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		$CanvasLayer/Cross.visible = true
	else:
		$CanvasLayer/Cross.visible = false
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		Input.set_custom_mouse_cursor(null)
	
	clean_death()
	display_aiming()


func _on_run_pressed():
	if hero_and_path.hero_energy > 0 and not hero_and_path.is_at_end:
		hero_and_path.is_run = true
		$CanvasLayer/Bar/Run.disabled = true
		if not hero_and_path.is_busted:
			$CanvasLayer/Bar/Bust.disabled = false
		$CanvasLayer/Bar/Stop.disabled = false


func _on_stop_pressed():
	hero_and_path.is_run = false
	$CanvasLayer/Bar/Run.disabled = false
	$CanvasLayer/Bar/Stop.disabled = true
	$CanvasLayer/Bar/Bust.disabled = true


func _on_bust_pressed():
	if hero_and_path.hero_energy > 0 \
			and not hero_and_path.is_at_end \
			and not hero_and_path.is_busted:
		hero_and_path.is_busted = true
		$CanvasLayer/Bar/Bust.disabled = true
		$CanvasLayer/GameInfo/CanBust.text = "Boosted"
		
		# set bust energy consume and speed coef
		hero_and_path.current_bust_coef = Gamevars.BUST_COEF
		hero_and_path.current_hero_bust_energy_consume = Gamevars.BUST_ENERGY_CONSUME
		await get_tree().create_timer(Gamevars.BUST_DURATION).timeout
		
		# unset bust energy consume and speed coef
		hero_and_path.current_bust_coef = 1.0
		hero_and_path.current_hero_bust_energy_consume = 0.0
		$CanvasLayer/GameInfo/CanBust.text = "Boost coldown"
		
		# unset bust coldown
		await get_tree().create_timer(Gamevars.BUST_TIMEOUT).timeout
		hero_and_path.is_busted = false
		$CanvasLayer/Bar/Bust.disabled = false
		$CanvasLayer/GameInfo/CanBust.text = "Boost available"


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


func _on_game_pause_pressed():
	$CanvasLayer._pause()


func hide_strategic() -> void:
	for n in lvl.get_children():
		if (
			"path_nodes_group" in n.get_groups() 
			and n.name != "StartNode" 
			and n.name != "EndNode"
			) or "spawn_zone" in n.get_groups():
			n.visible = false


func display_aiming() -> void:
	# for each enemy display aiming
	var all_enemies = lvl.find_children("*Enemy*")
	for enemy in all_enemies:
		if is_instance_valid(enemy):
			enemy.get_node("AimingLabel").text = ""
		
	var keys = Gamevars.aiming_queue.keys()
	for key in Gamevars.aiming_queue:
		var node = Gamevars.aiming_queue[key]
		if is_instance_valid(node):
			var label = node.get_node("AimingLabel")
			if label.text == "":
				label.text = "%s: %s" % [key.split(",")[1], keys.find(key) + 1]
			else:
				label.text = label.text + \
				"\n%s: %s" % [key.split(",")[1], keys.find(key) + 1]
		else:
			Gamevars.aiming_queue.erase(key)


func clean_death() -> void:
	# remove all death enemy
	var all_enemies = lvl.find_children("*Enemy*")
	for enemy in all_enemies:
		if is_instance_valid(enemy) and enemy.health <= 0:
			enemy.queue_free()
