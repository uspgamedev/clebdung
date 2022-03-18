extends Node2D

var mode = "idle"
var on_area = false
onready var player = get_parent().get_parent().get_node("YSort/Player")
onready var particles = load("res://Resources/Levels/Level 2/sand_particles.tscn")

func _process(_delta):
	if mode == "idle":
		animation()
	elif mode == "trigger":
		if on_area:
			if $Spritesheet.frame > 4:
				player.speed = 0
				$StaticBody2D/CollisionShape2D.disabled = false
				player.die()
		else:
			$StaticBody2D/CollisionShape2D.disabled = false

func animation():
	get_node("AnimationPlayer").play("idle")

func _on_TimerTrigger_timeout():
	get_node("AnimationPlayer").play("active")
	particles_spawn()
	get_node("TimerRetract").set_wait_time(5)
	get_node("TimerRetract").start()
	mode = "trigger"

func _on_TimerRetract_timeout():
	get_node("AnimationPlayer").play("retract")


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
		
func particles_spawn():
	var scene_instance = particles.instance()
	scene_instance.set_name("particles")
	add_child(scene_instance)

