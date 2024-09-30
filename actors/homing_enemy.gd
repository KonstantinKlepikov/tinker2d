extends Area2D

@export var speed := 150
@export var steer_force := 30.0
@export var activating_radius := 400
@export var damage: float

var velocity = Vector2.ZERO
var acceleration = Vector2.ZERO
var is_act := false


func _ready() -> void:
	# get start velocity
	velocity = transform.x * speed
	$ActivatingArea/CollisionShape2D.shape.radius = activating_radius


func _physics_process(delta: float) -> void:
	# calculate direction and new position, closest to target
	if not Gamevars.is_hero_on_start_or_end and is_act:
		acceleration += retarget()
		velocity += acceleration * delta
		velocity = velocity.limit_length(speed)
		rotation = velocity.angle()
		position += velocity * delta
		

func _draw() -> void:
	draw_aiming_radius()


func retarget() -> Vector2:
	# retarget to hero position
	var desired = (Gamevars.hero_pos - position).normalized() * speed
	return (desired - velocity).normalized() * steer_force


func _on_hero_body_entered(body: Node2D) -> void:
	# explode whrn collide with hero
	if "hero" in body.get_groups():
		explode()
		

func _on_activating_area_hero_body_entered(body: Node2D) -> void:
	# activate if enemy in range
	if "hero" in body.get_groups():
		print("here")
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
