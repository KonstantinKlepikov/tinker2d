extends Area2D

@export var speed: float = Gamevars.HOMING_ENEMY_SPEED
@export var steer_force: float = Gamevars.HOMING_ENEMY_STEER_FORCE
@export var activating_radius: float = Gamevars.HOMING_ENEMY_ACTIVATION_RADIUS
@export var damage: float = Gamevars.HOMING_ENEMY_DAMAGE
@export var health: int = Gamevars.HOMING_ENEMY_HEALTH

var velocity = Vector2.ZERO
var acceleration = Vector2.ZERO
var is_act := false
var is_visible_range := false


func _ready() -> void:
	# get start velocity
	velocity = transform.x * speed
	$ActivatingArea/CollisionShape2D.shape.radius = activating_radius


func _process(delta: float) -> void:
	# calculate direction and new position, closest to target
	if (
		not Gamevars.is_hero_on_start_or_end 
		and is_act 
		and not Gamevars.is_hero_empty
		):
		acceleration += retarget()
		velocity += acceleration * delta
		velocity = velocity.limit_length(speed)
		rotation = velocity.angle()
		position += velocity * delta
		

func _draw() -> void:
	if is_visible_range:
		draw_aiming_radius()


func retarget() -> Vector2:
	# retarget to hero position
	var desired = (Gamevars.hero_pos - position).normalized() * speed
	return (desired - velocity).normalized() * steer_force


func _on_hero_body_entered(body: Node2D) -> void:
	# impact and explode when collide with hero
	if "hero" in body.get_groups():
		body.get_parent().get_parent().hero_energy -= damage
		explode()
		

func _on_activating_area_hero_body_entered(body: Node2D) -> void:
	# activate if enemy in range
	if "hero" in body.get_groups() and not Gamevars.is_hero_on_start_or_end:
		is_act = true


func explode() -> void:
	#$Particles2D.emitting = false
	#set_physics_process(false)
	#$AnimationPlayer.play("explode")
	#await $AnimationPlayer.animation_finished
	queue_free()
	
	
func draw_aiming_radius() -> void:
	draw_circle(
		Vector2(0, 0), 
		activating_radius, 
		Gamevars.AIMING_RADIUS_COLOR, 
		false
	)


func _on_mouse_entered():
	is_visible_range = true
	Gamevars.current_mouse_in_enemy = self
	queue_redraw()


func _on_mouse_exited():
	is_visible_range = false
	Gamevars.current_mouse_in_enemy = null
	queue_redraw()
