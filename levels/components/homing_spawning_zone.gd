extends Area2D

@export var num_of_enemies: int
var size: Vector2
var center: Vector2


func _ready() -> void:
	var curve = $Path2D.curve
	var polygon = curve.get_baked_points()
	$Polygon2D.polygon = polygon # for displaying shape
	$Polygon2D.position = $Path2D.position
	size = $CollisionShape2D.shape.get_rect().size / 2.0
	center = to_global($CollisionShape2D.shape.get_rect().get_center())
	set_deferred("disabled", true)
