extends Area2D


func _ready() -> void:
	var curve = $Path2D.curve
	var polygon = curve.get_baked_points()
	$Polygon2D.polygon = polygon # for displaying shape
	$Polygon2D.position = $Path2D.position
