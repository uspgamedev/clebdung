extends Area2D

onready var animPlayer = get_parent().get_node("AnimationPlayer")

func _on_AnimArea2D_body_entered(body):
	if body.get_name() == "Player" and \
	animPlayer.get_current_animation() == "Light_Unblocked":
		get_parent().get_node("AnimationPlayer").play("WinAnimation")
