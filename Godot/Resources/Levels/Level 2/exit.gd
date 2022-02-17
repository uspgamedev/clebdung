extends Node2D

onready var animPlayer = get_node("AnimationPlayer")
onready var astar = get_tree().get_root().get_node("Level2/A*")
onready var player = get_parent().get_node("Player")
var k = 0
var on_area = false

func _process(_delta):
	if on_area and player.direction == Vector2(0,1):
		get_tree().get_root().get_node("Level2").win()

func _on_AnimArea2D_body_entered(body):
	if k == 0 and \
	body.get_name() == "Player" and \
	animPlayer.get_current_animation() == "Unblocked":
		for x in range(15,18):
			for y in range(18,20):
				astar.set_cell(x,y,1)
		astar._ready()
		animPlayer.play("WinAnimation")
		k = 1

func _on_AnimationPlayer_animation_changed(old_name, _new_name):
	if old_name == "WinAnimation":
		for x in range (15,18):
			for y in range (15,17):
				if x != 16 or y != 16:
					astar.set_cell(x,y,0)
		astar._ready()

func _on_WinArea2D_body_entered(_body):
	on_area = true

func _on_WinArea2D_body_exited(_body):
	on_area = false
