extends Area2D


@export var speed := 150
@export var steer_force := 30.0

var velocity = Vector2.ZERO
var acceleration = Vector2.ZERO


func _ready():
	velocity = transform.x * speed


func _physics_process(delta: float) -> void:
	acceleration += retarget()
	velocity += acceleration * delta
	velocity = velocity.limit_length(speed)
	rotation = velocity.angle()
	position += velocity * delta


func retarget() -> Vector2:
	var desired = (Gamevars.hero_pos - position).normalized() * speed
	return (desired - velocity).normalized() * steer_force


func _on_hero_body_entered(body):
	explode()

func explode():
	#$Particles2D.emitting = false
	#set_physics_process(false)
	#$AnimationPlayer.play("explode")
	#await $AnimationPlayer.animation_finished
	queue_free()
