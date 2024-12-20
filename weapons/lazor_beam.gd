extends Node2D

@export var growth_time := 0.1 # duration of the tween animation in seconds
@export var max_width := 8 # max width of lazor beam

var is_casting := false
var tween : Tween
var enemy: Area2D # enemy to target


func _ready() -> void:
	$Line2D.points[0] = Vector2.ZERO
	$Line2D.points[1] = Vector2.ZERO
	$Line2D.width = 0


func _process(_delta: float) -> void:
	if is_casting and is_instance_valid(enemy):
		$Line2D.points[1] = to_local(enemy.position)
		# consume enemy health
		enemy.health -= get_parent().damage
		# consume energy
		#get_parent().get_parent().hero_energy -= get_parent().energy_rate
		
	if is_casting and not is_instance_valid(enemy):
		disappear()


func appear(target: Area2D) -> void:
	enemy = target
	is_casting = true
	# start consume hero energy
	get_parent().get_parent().get_parent().get_parent().energy_consume += \
	get_parent().energy_consume
	# cast beam
	if tween and tween.is_running():
		tween.kill()
	tween = create_tween()
	tween.tween_property(
		$Line2D, "width", max_width, growth_time).from_current()


func disappear() -> void:
	is_casting = false
	# stop consume hero energy
	get_parent().get_parent().get_parent().get_parent().energy_consume -= \
	get_parent().energy_consume
	# stop cast beam
	if tween and tween.is_running():
		tween.kill()
	tween = create_tween()
	tween.tween_property($Line2D, "width", 0, growth_time).from_current()
