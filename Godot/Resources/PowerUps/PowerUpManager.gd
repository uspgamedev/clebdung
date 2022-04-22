extends Node2D

var lock: bool = false


func _input(event):
	var slots = get_children()
	for slot in slots:
		if event.is_action_pressed("power_up" + str(slot.value)) and not lock:
			lock = true
			slot.useSlot()
			break
