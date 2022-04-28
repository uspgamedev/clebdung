extends LevelRoot

onready var block = get_node("YSort/Exit/Exit1")
onready var ladder_sup = get_node("Stairs/Exit2")
export(String, FILE, "*.tscn") var next_scene_path

func _ready():
	# Cria referências aos nós
	win_animplayer = get_node("YSort/Exit/AnimationPlayer")
	create_ref()
	# Código padrão
	init(2.8, Vector2(1,0))
	# Esconde os power ups do HUD
	HUD.get_node("Control/PowerUpSlot1").visible = false
	HUD.get_node("Control/PowerUpSlot2").visible = false
	HUD.get_node("Control/PowerUpSlot3").visible = false

func _process(_delta):
	# Código padrão
	detect_move()

func win():
	# Código padrão
	lock_player(Vector2(0,1))
	# Desativa a luz do jogador
	player.get_node("AnimationPlayerL").play("Light_FadeOut")
	# Retira colisões e conserta as camadas dos sprites da saída
	block.get_node("Exit1").z_index = 1
	block.get_node("CollisionShape2D").disabled = true
	ladder_sup.get_node("Exit2").z_index = 1
	ladder_sup.get_node("CollisionShape2D").disabled = true
	# Código padrão
	finish_level(next_scene_path)
