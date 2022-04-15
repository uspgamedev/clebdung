extends LevelRoot

func _ready():
	# Cria referências aos nós
	win_animplayer = get_node("YSort/Exit/AnimationPlayer")
	create_ref()
	
	player.input_enabled = true
