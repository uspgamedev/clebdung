extends Area2D

var id
export(int) var power_up

func _ready():
	$Sprite.texture = load("res://Assets/PowerUps/Collectables/power_up" + \
	str(power_up) + ".png")
	id = "power_up" + str(power_up)

func _on_Self_body_entered(body):
	if body.get_name() == "Player":
		for i in range(1,4):
			var power_up_slot = body.get_node("PowerUpSlot" + str(i))
			if power_up_slot.isEmpty():
				power_up_slot.setSlot(id)
				queue_free()
				break
