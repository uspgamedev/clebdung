extends Sprite

var score := 0


func update_score():
	score += 1
	$AnimationPlayer.play("Score_" + str(score))
	return score == 5
