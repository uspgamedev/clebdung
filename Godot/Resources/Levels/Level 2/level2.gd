extends Node2D

onready var player = get_node("YSort/Player")
onready var HUD = get_node("HUD")
onready var ghosts = get_tree().get_nodes_in_group("Ghosts")
onready var win_animplayer = get_node("YSort/Exit/AnimationPlayer")
onready var guide = get_node("Guide")
onready var block = get_node("YSort/Exit/Exit1")
onready var ladder_sup = get_node("Stairs/Exit2")
export(String, FILE, "*.tscn") var next_scene_path
var init = false
var default_code = load("res://Resources/Levels/default_level.gd").new()

func _ready():
	# Código padrão
	default_code.import_ref(player, ghosts, HUD, win_animplayer, guide, get_tree())
	default_code.init(2.8, Vector2(1,0))

func _process(_delta):
	# Assim que o primeiro movimento for feito, desbloqueia fantasmas
	if init == false and player.input_enabled and \
	(Input.is_action_pressed("ui_up") or \
	Input.is_action_pressed("ui_down") or \
	Input.is_action_pressed("ui_left") or \
	Input.is_action_pressed("ui_right")):
		init = true
		for g in ghosts:
			g.set_physics_process(true)
			

func unblock():
	# Código padrão
	default_code.unblock()

func win():
	# Código padrão
	default_code.lock_player(Vector2(0,1))
	# Desativa a luz do jogador
	player.get_node("AnimationPlayerL").play("Light_FadeOut")
	# Retira colisões e conserta as camadas dos sprites da saída
	block.get_node("Exit1").z_index = 1
	block.get_node("CollisionShape2D").disabled = true
	ladder_sup.get_node("Exit2").z_index = 1
	ladder_sup.get_node("CollisionShape2D").disabled = true
	# Código padrão
	default_code.finish_level(next_scene_path)
