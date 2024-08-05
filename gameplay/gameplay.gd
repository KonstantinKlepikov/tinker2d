extends Node2D

var in_rect: bool = true


func _process(_delta: float) -> void:
	pass


func _on_texture_rect_mouse_entered():
	in_rect = true


func _on_texture_rect_mouse_exited():
	in_rect = false
