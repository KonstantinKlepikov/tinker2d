extends Area2D

@export var speed_coof: float


func _ready() -> void:
	var curve = $Path2D.curve
	var polygon = curve.get_baked_points()
	$Polygon2D.polygon = polygon
	$Line2D.points = polygon
	$CollisionPolygon2D.polygon = polygon
