extends Sprite

onready var score = get_tree().get_root().get_node("Fase1").get_node("HUD/Score")

func _ready():
	$AnimationPlayer.play('crystal')

func _on_Area2D_body_entered(body):
	if body.get_name() == "Player":
		score.update_score()
		queue_free()
