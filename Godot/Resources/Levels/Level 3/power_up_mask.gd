extends Sprite

onready var power_up_manager = Globals.current_level.get_power_up_manager()
onready var slot_number : String = get_name().trim_prefix("PowerUpMask")
var power_up_sprite : Sprite
var empty := true


func _ready():
	power_up_manager.connect_slot(self, slot_number)


func _process(_delta):
	if not empty:
		frame = power_up_sprite.frame


func use_slot():
	texture = null
	empty = true


func set_slot():
	power_up_sprite = power_up_manager.get_slot(slot_number).get_node("Sprite")
	texture = power_up_sprite.texture
	empty = false
