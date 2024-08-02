extends FlowContainer

@export var tactic_scene: PackedScene


func _on_to_tactic_pressed():
	get_tree().change_scene_to_packed(tactic_scene)
