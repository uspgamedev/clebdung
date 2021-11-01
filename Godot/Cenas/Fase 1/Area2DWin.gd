extends Area2D

func _on_Area2DWin_body_entered(body):
	if body.get_name() == "Player":
		print("Ganhou")
