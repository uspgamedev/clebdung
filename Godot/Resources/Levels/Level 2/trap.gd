extends Node2D

var mode = "idle"
var on_area = false
onready var player = get_parent().get_node("Player")

func _process(_delta):
	if mode == "idle":
		animation()
	elif mode == "active":
		if on_area:
			player.die()

func animation():
	get_node("AnimationPlayer").play("idle")

func _on_TimerTrigger_timeout():
	get_node("AnimationPlayer").play("active")
	get_node("TimerRetract").set_wait_time(5)
	get_node("TimerRetract").start()

func _on_TimerRetract_timeout():
	get_node("AnimationPlayer").play("retract")

# Só arrumar o tempo que o player morre, uma vez que ele so morre quando a animação dos espinhos acaba
func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "retract":
		mode = "idle"
	if anim_name == "active":
		mode = "active"

func _on_Area2D_body_entered(body):
	if body.get_name() == "Player":
		on_area = true
		if mode == "idle":
			get_node("TimerTrigger").set_wait_time(1)
			get_node("TimerTrigger").start()
			mode = "starting"

func _on_Area2D_body_exited(body):
	if body.get_name() == "Player":
		on_area = false
