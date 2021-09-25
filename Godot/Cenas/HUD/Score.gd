extends Control

var score

func _ready():
	score = 0

func _process(_delta):
	if score == 5:
		print("Ganhou")

func update_score():
	score += 1
	get_node("Score").frame += 1
