extends Node2D

onready var player = get_node("YSort/Player")
onready var HUD = get_node("HUD")
onready var ghosts = get_tree().get_nodes_in_group("Ghosts")
onready var win_animplayer = get_node("Exit/AnimationPlayer")
onready var guide = get_node("Guide")
export(String, FILE, "*.tscn") var next_scene_path
var default_code = load("res://Resources/Levels/default_level.gd").new()

func _ready():
	# Código padrão
	default_code.import_ref(player, ghosts, HUD, win_animplayer, guide, get_tree())
	default_code.init(3.5, Vector2(1,0))

func _process(_delta):
	# Código padrão
	default_code.detect_move()

# Desbloqueia a saída após coleta dos 5 cristais
func unblock():
	# Código padrão
	default_code.unblock()

# Ganha a fase (animação final)
func win():
	# Código padrão
	default_code.lock_player(Vector2(1,0))
	# Espera o jogador avançar um pouco no caminho da saída
	yield(get_tree().create_timer(4), "timeout")
	# Código padrão
	default_code.finish_level(next_scene_path)
