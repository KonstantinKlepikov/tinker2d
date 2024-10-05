extends Area2D

@export var speed := 150
@export var steer_force := 30.0
@export var activating_radius := 400.0
@export var damage: float = 200.0
@export var health: int = 200

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
	Gamevars.in_enemy = true
	queue_redraw()


func _on_mouse_exited():
	is_visible_range = false
	Gamevars.in_enemy = false
	queue_redraw()
