extends VFlowContainer

func _ready() -> void:
	get_children()[0].grab_focus()
	
	if !OS.has_feature("pc"):
		$Quit.hide()

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_settings_pressed() -> void:
	get_tree().change_scene_to_packed(preload("res://settings/settings.tscn"))

func _on_start_pressed() -> void:
	get_tree().change_scene_to_packed(preload("res://gameplay/strategic.tscn"))
