#extends RayCast2D
extends Node2D

@export var growth_time := 0.2 # duration of the tween animation in seconds
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
		
	if is_casting and not is_instance_valid(enemy):
		disappear()


func appear(target: Area2D) -> void:
	enemy = target
	is_casting = true
	if tween and tween.is_running():
		tween.kill()
	tween = create_tween()
	tween.tween_property(
		$Line2D, "width", max_width, growth_time).from_current()


func disappear() -> void:

	is_casting = false
	if tween and tween.is_running():
		tween.kill()
	tween = create_tween()
	tween.tween_property($Line2D, "width", 0, growth_time).from_current()
