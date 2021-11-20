extends Area2D

func _on_Area2DWin_body_entered(body):
	if body.get_name() == "Player":
		get_tree().get_root().get_node("Fase1").win()
