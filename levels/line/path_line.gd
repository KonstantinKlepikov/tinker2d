extends Line2D


func build_shape() -> void:
	# add point and shape
	for i in points.size() - 1:
		var new_shape = CollisionShape2D.new()
		$LinePathArea2D.add_child(new_shape)
		var rect = RectangleShape2D.new()
		new_shape.position = (points[i] + points[i + 1]) / 2
		new_shape.rotation = points[i].direction_to(points[i + 1]).angle()
		var length = points[i].distance_to(points[i + 1])
		rect.extents = Vector2(length / 2, 10)
		new_shape.shape = rect


func clear_shape() -> void:
	# remove points shape and new shape
	var children = $LinePathArea2D.get_children()
	for child in children:
		child.free()
