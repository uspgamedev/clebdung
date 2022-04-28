extends Node2D

export (int) var value

onready var power_up_node = null

signal used_slot
signal setted_slot(powerup)

func useSlot():
	var delay = 0.1
	if !isEmpty():
		delay = power_up_node.get_duration()
		power_up_node.usePowerUp()
		power_up_node = null
<<<<<<< HEAD
	yield(get_tree().create_timer(delay), "timeout")
	emit_signal("used_slot")
	return
=======
		yield(get_tree().create_timer(delay), "timeout")
		emit_signal("used_slot")
	get_parent().lock = false

>>>>>>> c921019c4a9d5874d7a53823100a9334f1444b06

func setSlot(id):
	var node = load("res://Resources/PowerUps/Scenes/" + id + ".tscn")
	power_up_node = node.instance()
	add_child(power_up_node)
	emit_signal("setted_slot", id)

func isEmpty():
	return power_up_node == null
