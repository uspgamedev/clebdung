extends LevelRoot


func _ready():
	# Esconde os power ups do HUD
	hud.get_node("Control/PowerUpSlot1").visible = false
	hud.get_node("Control/PowerUpSlot2").visible = false
	hud.get_node("Control/PowerUpSlot3").visible = false
