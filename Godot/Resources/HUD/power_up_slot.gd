extends TextureRect

export(int) var slot = 1
onready var root_node = find_parent("Level*")
onready var slot_node = root_node.get_node("YSort/Player/PowerUpManager/PowerUpSlot" + str(slot))

func _ready():
	slot_node.connect("used_slot", self, "useSlot")
	slot_node.connect("setted_slot", self, "setSlot")
	set_key()

func useSlot():
	$PowerUp.texture = null
	
func setSlot(id):
	$PowerUp.texture = load("res://Assets/HUD/PowerUps/" + id + ".png")

func set_key():
	for action in InputMap.get_action_list("power_up" + str(slot)):
		if action is InputEventKey:
			$Key.text = OS.get_scancode_string(action.scancode)
