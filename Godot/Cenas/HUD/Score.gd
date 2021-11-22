extends Sprite

onready var fase = find_parent("Fase*")
onready var win_animplayer = fase.get_node("Saida/AnimationPlayer")
var score

func _ready():
	score = 0

func update_score():
	score += 1
	get_node("AnimationPlayer").play("Score_" + str(score))
	if score == 5:
		get_tree().call_group("Ghosts","f_chaos")
		win_animplayer.play("WinAnimation")
