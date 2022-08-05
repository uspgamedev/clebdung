extends Control

export(String, FILE, "*.tscn") var first_level_path
onready var settings_menu = $SettingsMenu

func _ready():
	$Fade.fade_in(1)

func _on_NewGame_pressed():
	SaveManager.create_new_game()
	$Fade.fade_out(1)
	yield(get_tree().create_timer($Fade.fade_out_time), "timeout")
	get_tree().change_scene(first_level_path)

func _on_Levels_pressed():
	$Fade.fade_out(1)
	yield(get_tree().create_timer($Fade.fade_out_time), "timeout")

func _on_Quit_pressed():
	get_tree().quit()

func _on_SETTINGS_pressed():
	settings_menu.popup_centered()

func _on_Continue_pressed():
	var saved_level: String = str(SaveManager.load_save()["level"])
	var level_path = "res://Resources/Levels/Level " + saved_level + "/level" + saved_level + ".tscn"
	$Fade.fade_out(1)
	yield(get_tree().create_timer($Fade.fade_out_time), "timeout")
	get_tree().change_scene(level_path)
