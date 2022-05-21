extends Node
class_name LevelRoot

export(String, FILE, "*.tscn") var next_scene_path
export(Vector2) var init_direction
export(float) var init_time
export(Vector2) var finish_direction
export(float) var finish_time
var init_level := false
onready var player := get_node("YSort/Player")
onready var hud := get_node("HUD")
onready var fade := get_node("Fade")
onready var guide := get_node("Guide")
onready var level_music := get_node("LevelMusic")
onready var win_animplayer := get_node("YSort/Exit/AnimationPlayer")
onready var ghosts : Array
onready var crystals : Array


func _enter_tree():
	Globals.current_level = self


func _ready():
	init()

# Retorna uma referência ao jogador
func get_player():
	return $YSort/Player

# Retorna uma referência ao Astar
func get_astar():
	return $"A*"

# Retorna uma referência ao Power Up Manager
func get_power_up_manager():
	return $YSort/Player/PowerUpManager

# Retorna a posição da saída
func get_exit_position():
	#return Vector2()
	return $YSort/Exit/ExitPosition2D.global_position

# Retorna o id numérico do level
func get_level_id():
	return int(get_name().trim_suffix("Level"))

# Inicia a fase
func init():
	# Toca a transição de tela
	fade.fade_in()
	# Bloqueia temporariamente input do jogador e simula caminhar
	# em uma direção determinada
	player.target_position = player.global_position + 32*init_direction
	player.direction = init_direction
	yield(get_tree().create_timer(init_time), "timeout")
	# Bloqueia fantasmas
	ghosts = get_tree().get_nodes_in_group("Ghosts")
	for g in ghosts:
		g.set_physics_process(false)
	player.input_enabled = true


func detect_move():
	# Assim que o primeiro movimento for feito, desbloqueia fantasmas
	# e retira o nome da fase da tela
	if (
		init_level == false 
		and player.input_enabled 
		and (Input.is_action_pressed("ui_up")
			 or Input.is_action_pressed("ui_down") 
			 or Input.is_action_pressed("ui_left") 
			 or Input.is_action_pressed("ui_right")
		)
	):
		init_level = true
		for g in ghosts:
			g.set_physics_process(true)
		hud.undisplay_name()
		hud.init_HUD()
		# Conecta os sinais dos cristais com o HUD
		crystals = get_tree().get_nodes_in_group("Crystals")
		for crystal in crystals:
			crystal.connect("collected_crystal", hud, "update_score")


func _process(_delta):
	# Código padrão
	detect_move()

# Desbloqueia a saída após coleta dos cristais
func unblock():
	# Ativa o modo caos
	get_tree().call_group("Ghosts","f_chaos")
	# Atualiza o estado do bloqueio da saída
	win_animplayer.play("Unblocked")
	# Ativa o guia
	guide.enable()

# Trava o jogador em direção à saída
func lock_player():
	# Desativa input do jogador e simula caminhar à uma direção determinada
	player.input_enabled = false
	player.direction = finish_direction
	# Desativa o guia
	guide.disable()
	# Toca a música final
	level_music.finish_music()

# Ganha a fase (animação final)
func win():
	# Código padrão
	lock_player()
	# Espera o jogador avançar um pouco no caminho da saída
	yield(get_tree().create_timer(finish_time), "timeout")
	# Código padrão
	finish_level()

# Finaliza o level e troca de cena
func finish_level():
	# Retira o HUD
	hud.finish()
	# Toca a transição de tela
	fade.fade_out()
	# Desativa o modo chaos dos fantasmas
	get_tree().call_group("Ghosts","f_chaos")
	# Aguarda e troca de cena
	yield(get_tree().create_timer(3), "timeout")
	get_tree().change_scene(next_scene_path)
