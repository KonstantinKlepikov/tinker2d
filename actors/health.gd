extends Label


func _process(_delta) -> void:
	var par := get_parent().get_parent()
	if par.health >= 0.0:
		text = str(par.health)
	else:
		text = str(0)
