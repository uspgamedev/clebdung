extends Area2D

onready var BUFF: PackedScene = load("res://Resources/PowerUps/Dash/DashBuff.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_Self_body_entered(body):
	if body.get_name() == "Player":
		var buff = BUFF.instance()
		buff.set_base_speed(body.speed)
		body.add_child(buff)
		queue_free()
