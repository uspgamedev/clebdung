extends Control

var score

func _ready():
	score = 0
	yield(get_tree().create_timer(0.5), "timeout")
	get_node("AnimationPlayer").play("Score_0")

func _process(_delta):
	if score == 5:
		print("Ganhou")

func update_score():
	score += 1
	get_node("AnimationPlayer").play("Score_" + str(score))
