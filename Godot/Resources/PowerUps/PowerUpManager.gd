extends Node2D

var lock: bool = false

onready var slots = get_children()

func _input(event):
	for slot in slots:
		if event.is_action_pressed("power_up" + str(slot.value)) and not lock:
			lock = true
			yield(slot.useSlot(), "completed")
			lock = false
			break
