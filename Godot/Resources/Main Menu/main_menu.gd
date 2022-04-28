extends Control

export(String, FILE, "*.tscn") var next_level_path
onready var settings_menu = $SettingsMenu

func _ready():
	$Fade.fade_in()


func _on_Play_pressed():
	$Fade.fade_out()
	yield(get_tree().create_timer($Fade.fade_out_time), "timeout")
	get_tree().change_scene(next_level_path)


func _on_Levels_pressed():
	$Fade.fade_out()
	yield(get_tree().create_timer($Fade.fade_out_time), "timeout")
	pass


func _on_Quit_pressed():
	get_tree().quit()


func _on_SETTINGS_pressed():
	settings_menu.popup_centered()
