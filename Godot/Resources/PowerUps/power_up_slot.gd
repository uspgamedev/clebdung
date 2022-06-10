extends Node2D

signal used_slot
signal setted_slot(powerup)
onready var power_up_node : Node = null


func use_slot():
	var delay := 0.1
	if !is_empty():
		delay = power_up_node.get_duration()
		power_up_node.use_power_up()
		power_up_node = null
	yield(get_tree().create_timer(delay), "timeout")
	emit_signal("used_slot")
	return


func set_slot(id):
	var node := load("res://Resources/PowerUps/Scenes/" + id + ".tscn")
	power_up_node = node.instance()
	add_child(power_up_node)
	emit_signal("setted_slot", id)


func is_empty():
	return power_up_node == null

func get_sprite():
	return get_children()[0].get_node("Sprite")
