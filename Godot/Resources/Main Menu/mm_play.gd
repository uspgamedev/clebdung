extends Button

export(String, FILE, "*.tscn") var next_level_path

func _on_Play_pressed():
	get_tree().change_scene(next_level_path)
