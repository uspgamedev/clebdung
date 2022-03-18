extends StaticBody2D

onready var animPlayer = get_node("AnimationPlayer")

func _on_WinArea2D_body_entered(body):
	get_tree().get_root().get_node("Level1").win()


func _on_AnimArea2D_body_entered(body):
	if animPlayer.get_current_animation() == "Unblocked":
		animPlayer.play("WinAnimation")
