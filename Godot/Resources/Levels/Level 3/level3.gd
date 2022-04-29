extends LevelRoot

func _ready():
	# Cria referências aos nós
	win_animplayer = get_node("YSort/Exit/AnimationPlayer")
	create_ref()
	init(1, Vector2(0,0))

func _process(_delta):
	# Código padrão
	detect_move()
