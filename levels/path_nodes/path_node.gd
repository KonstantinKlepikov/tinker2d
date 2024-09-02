extends StaticBody2D


func _ready():
	pass


func _process(_delta):
	pass


func _on_mouse_entered():
	scale = Vector2(1.5, 1.5)


func _on_mouse_exited():
	scale = Vector2(1, 1)
