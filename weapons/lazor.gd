extends Node2D

@export var attack_radius: float
@export var aiming_radius: float
@export var damage: float
@export var ammo: float
@export var rate: float # shot per second
@export var jamming_probability: float
@export var jamming_time: float

var in_aiming_range: Array[Area2D] = []
var in_attack_range: Array[Area2D] = []


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
	

func fire() -> void:
	$LazorBeam.is_casting = true


func _on_attack_area_area_entered(area: Area2D) -> void:
	# add enemy to attack range
	if "enemy" in area.get_groups():
		in_attack_range.append(area)


func _on_attack_area_area_exited(area: Area2D) -> void:
	# remove enemy from attack range
	if "enemy" in area.get_groups():
		in_attack_range.erase(area)


func _on_aiming_area_area_entered(area: Area2D) -> void:
	# add enemy to aiming range
	if "enemy" in area.get_groups():
		in_aiming_range.append(area)


func _on_aiming_area_area_exited(area: Area2D) -> void:
	# remove enemy from aiming range
	if "enemy" in area.get_groups():
		in_aiming_range.erase(area)
