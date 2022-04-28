extends LevelRoot

export(String, FILE, "*.tscn") var next_scene_path

func _ready():
	# Cria referências aos nós
	win_animplayer = get_node("Exit/AnimationPlayer")
	create_ref()
	# Código padrão
	init(3.25, Vector2(1,0))
	# Esconde os power ups do HUD
	HUD.get_node("Control/PowerUpSlot1").visible = false
	HUD.get_node("Control/PowerUpSlot2").visible = false
	HUD.get_node("Control/PowerUpSlot3").visible = false

func _process(_delta):
	# Código padrão
	detect_move()

# Ganha a fase (animação final)
func win():
	# Código padrão
	lock_player(Vector2(1,0))
	# Espera o jogador avançar um pouco no caminho da saída
	yield(get_tree().create_timer(4), "timeout")
	# Código padrão
	finish_level(next_scene_path)
