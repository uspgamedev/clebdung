extends Sprite

onready var power_up_slot = \
get_parent().get_parent().get_node("YSort/Player/PowerUpManager/PowerUpSlot" + str(slot))
export(int) var slot
var power_up_sprite
var empty = true


func _ready():
	power_up_slot.connect("used_slot", self, "updateSlot")
	power_up_slot.connect("setted_slot", self, "updateSlot")

func _process(_delta):
	if not empty:
		frame = power_up_sprite.frame

func updateSlot(_arg = null):
	if empty:
		power_up_sprite = power_up_slot.get_children()[0].get_node("Sprite")
		texture = power_up_sprite.texture
		empty = false
	else:
		texture = null
		empty = true
