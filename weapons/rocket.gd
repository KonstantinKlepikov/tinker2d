extends Node2D


@export var attack_radius: float
@export var aiming_radius: float
@export var damage: float
@export var ammo: float
@export var rate: float # shot per second
@export var jamming_probability: float
@export var jamming_time: float


func _ready():	
	$AttackArea/CollisionShape2D.shape.radius = attack_radius
	$AimingArea/CollisionShape2D.shape.radius = aiming_radius

func _draw() -> void:
	draw_attack_radius()
	draw_aiming_radius()
	
	
func draw_aiming_radius() -> void:
	draw_circle(
		Vector2(0, 0), 
		aiming_radius, 
		Gamevars.AIMING_RADIUS_COLOR, 
		false
	)
	
func draw_attack_radius() -> void:
	draw_circle(
		Vector2(0, 0), 
		attack_radius, 
		Gamevars.ATTACK_RADIUS_COLOR, 
		false
	)
