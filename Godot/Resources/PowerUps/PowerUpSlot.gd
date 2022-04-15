extends Node2D

var lock_slot
export(int) var Slot

onready var power_up_node = null
onready var player_sprite = get_parent().get_node("PlayerSprite")

signal used_slot
signal setted_slot(powerup)

func _input(event):
	if event.is_action_pressed("power_up" + str(Slot)) and not lock_slot:
		useSlot()

func useSlot():
	lock_slot = true
	get_parent().get_node("PowerUpSlot2").lock_slot = true
	get_parent().get_node("PowerUpSlot3").lock_slot = true
	var delay
	if power_up_node != null:
		delay = power_up_node.getTime()
		power_up_node.usePowerUp()
		power_up_node = null
	yield(get_tree().create_timer(delay), "timeout")
	lock_slot = false
	get_parent().get_node("PowerUpSlot2").lock_slot = false
	get_parent().get_node("PowerUpSlot3").lock_slot = false
	emit_signal("used_slot")

func setSlot(id):
	var node = load("res://Resources/PowerUps/Scenes/" + id + ".tscn")
	power_up_node = node.instance()
	add_child(power_up_node)
	emit_signal("setted_slot", id)

func isEmpty():
	return power_up_node == null
