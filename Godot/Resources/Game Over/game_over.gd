extends Control


func _ready():
	$Fade.fade_in()


func _on_MainMenu_pressed():
	$Fade.fade_out()
	yield(get_tree().create_timer($Fade.fade_out_time), "timeout")
	get_tree().change_scene("res://Resources/Main Menu/main_menu.tscn")


func _on_Quit_pressed():
	get_tree().quit()


func _on_Retry_pressed():
	$Fade.fade_out()
	yield(get_tree().create_timer($Fade.fade_out_time), "timeout")
