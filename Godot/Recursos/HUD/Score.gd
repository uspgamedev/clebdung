extends Sprite

onready var fase = find_parent("Fase*")
var score

func _ready():
	score = 4

func update_score():
	score += 1
	get_node("AnimationPlayer").play("Score_" + str(score))
	if score == 5:
		fase.unblock()
