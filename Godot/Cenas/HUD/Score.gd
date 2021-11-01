extends Control

onready var win_animation = get_tree().get_root().get_node("Fase1").get_node("Win/AnimationPlayer")
var score

func _ready():
	score = 0
	yield(get_tree().create_timer(0.5), "timeout")
	get_node("AnimationPlayer").play("Score_0")

func update_score():
	score += 1
	get_node("AnimationPlayer").play("Score_" + str(score))
	if score == 5:
		get_tree().call_group("Ghosts","enter_chaos")
		win_animation.play("WinAnimation")
