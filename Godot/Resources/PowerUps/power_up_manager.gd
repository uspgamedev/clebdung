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


func set_slots(equiped_power_ups : Array):
	for i in range(0,3):
		slots[i].set_slot(equiped_power_ups[i])


func get_equiped():
	var equiped := []
	for slot in slots:
		if slot.power_up_node == null:
			equiped.append("power_up0")
		else:
			equiped.append(slot.power_up_node.id)
	return equiped
