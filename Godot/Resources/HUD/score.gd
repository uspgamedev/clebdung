extends Sprite

onready var level = find_parent("Level*")
var score

func _ready():
	score = 0

func update_score():
	score += 1
	get_node("AnimationPlayer").play("Score_" + str(score))
	if score == 5:
		level.unblock()
