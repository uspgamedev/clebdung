extends Area2D

var id
export(int) var power_up


func _ready():
	$Sprite.texture = load("res://Assets/PowerUps/Collectables/power_up" + \
	str(power_up) + ".png")
	id = "power_up" + str(power_up)
	add_to_group("PowerUps")


func _on_Self_body_entered(body):
	if body.get_name() == "Player":
		var power_up_manager = body.get_node("PowerUpManager")
		for i in range(1, power_up_manager.get_child_count() + 1):
			var power_up_slot = power_up_manager.get_node("PowerUpSlot" + str(i))
			if power_up_slot.is_empty():
				power_up_slot.set_slot(id)
				queue_free()
				break
