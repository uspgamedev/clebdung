extends TextureRect

onready var slot_number : String = get_name().trim_prefix("PowerUpSlot")


func _ready():
	set_key()


func use_slot():
	$PowerUp.texture = null


func set_slot(id):
	$PowerUp.texture = load("res://Assets/HUD/PowerUps/power_up" + id + ".png")


func set_key():
	for action in InputMap.get_action_list("power_up" + slot_number):
		if action is InputEventKey:
			$Key.text = OS.get_scancode_string(action.scancode)
