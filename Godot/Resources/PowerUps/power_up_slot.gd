extends Node2D

signal used_slot
signal setted_slot(powerup)
onready var power_up_node : Node = null


func use_slot():
	if is_empty():
		yield(get_tree().create_timer(0.01), "timeout")
		return
	yield(power_up_node.use_power_up(), "completed")
	power_up_node = null
	emit_signal("used_slot")
	return


func set_slot(id):
	if id == "power_up0":
		return
	var node := load("res://Resources/PowerUps/Scenes/" + id + ".tscn")
	power_up_node = node.instance()
	add_child(power_up_node)
	emit_signal("setted_slot", id)


func is_empty():
	return power_up_node == null


func get_sprite():
	return get_children()[0].get_node("Sprite")
