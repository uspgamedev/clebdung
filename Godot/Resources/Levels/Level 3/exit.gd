extends StaticBody2D

onready var level : LevelRoot = Globals.current_level
onready var anim_player := get_node("AnimationPlayer")


func _on_WinArea2D_body_entered(_body):
	level.win()


func _on_AnimArea2D_body_entered(_body):
	if anim_player.get_current_animation() == "Unblocked":
		anim_player.play("WinAnimation")
