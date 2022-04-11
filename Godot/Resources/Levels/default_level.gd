extends Node

class_name LevelRoot

onready var player
onready var ghosts
onready var HUD
onready var fade
onready var guide
onready var level_music
onready var win_animplayer
var init_level = false

# Importa as referências da fase
func create_ref():
	player = self.get_node("YSort/Player")
	ghosts = get_tree().get_nodes_in_group("Ghosts")
	HUD = self.get_node("HUD")
	guide = self.get_node("Guide")
	fade = self.get_node("Fade")
	level_music = self.get_node("LevelMusic")

# Inicia a fase
func init(init_time, init_direction):
	# Toca a transição de tela
	fade.fade_in()
	# Bloqueia temporariamente input do jogador e simula caminhar
	# à uma direção determinada
	player.target_position = player.global_position + Vector2(32,0)
	player.direction = init_direction
	yield(get_tree().create_timer(init_time), "timeout")
	# Bloqueia fantasmas
	for g in ghosts:
		g.set_physics_process(false)
	player.input_enabled = true


func detect_move():
	# Assim que o primeiro movimento for feito, desbloqueia fantasmas
	# e retira o nome da fase da tela
	if init_level == false and player.input_enabled and \
	(Input.is_action_pressed("ui_up") or \
	Input.is_action_pressed("ui_down") or \
	Input.is_action_pressed("ui_left") or \
	Input.is_action_pressed("ui_right")):
		init_level = true
		for g in ghosts:
			g.set_physics_process(true)
		HUD.undisplay_name()
		HUD.init_map_score()

# Desbloqueia a saída após coleta dos cristais
func unblock():
	# Ativa o modo caos
	get_tree().call_group("Ghosts","f_chaos")
	# Atualiza o estado do bloqueio da saída
	win_animplayer.play("Unblocked")
	# Ativa o guia
	guide.enable()

# Trava o jogador em direção à saída
func lock_player(finish_direction):
	# Desativa input do jogador e simula caminhar à uma direção
	# determinada
	player.input_enabled = false
	player.direction = finish_direction
	# Desativa o guia
	guide.disable()
	# Toca a música final
	level_music.finish_music()

# Finaliza o level e troca de cena
func finish_level(next_scene_path):
	# Retira o HUD
	HUD.finish()
	# Toca a transição de tela
	fade.fade_out()
	# Desativa o modo chaos dos fantasmas
	get_tree().call_group("Ghosts","f_chaos")
	# Aguarda e troca de cena
	yield(get_tree().create_timer(3), "timeout")
	get_tree().change_scene(next_scene_path)
