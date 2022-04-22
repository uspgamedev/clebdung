extends Node2D

export (int) var value

onready var power_up_node = null

signal used_slot
signal setted_slot(powerup)

func useSlot():
	if !isEmpty():
		var delay = power_up_node.get_duration()
		power_up_node.usePowerUp()
		power_up_node = null
		yield(get_tree().create_timer(delay), "timeout")
	get_parent().lock = false
	emit_signal("used_slot")

func setSlot(id):
	var node = load("res://Resources/PowerUps/Scenes/" + id + ".tscn")
	power_up_node = node.instance()
	add_child(power_up_node)
	emit_signal("setted_slot", id)

func isEmpty():
	return power_up_node == null
