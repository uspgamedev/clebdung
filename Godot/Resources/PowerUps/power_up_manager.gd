extends Node2D

var lock := false
onready var slots := get_children()


func _input(event):
	var slot_number := 0
	for slot in slots:
		slot_number += 1
		if (event.is_action_pressed("power_up" + str(slot_number)) and not lock):
			lock = true
			yield(slot.use_slot(), "completed")
			lock = false
			break


func connect_slot(external_slot : Node, slot_number : String):
	var slot_node := get_node("PowerUpSlot" + slot_number)
	slot_node.connect("used_slot", external_slot, "use_slot")
	slot_node.connect("setted_slot", external_slot, "set_slot")


func get_slot(slot_number : String):
	return get_node("PowerUpSlot" + slot_number)
