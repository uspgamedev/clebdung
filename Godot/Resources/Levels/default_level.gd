extends Node

var player
var ghosts
var HUD
var win_animplayer
var guide
var tree
var init = false

# Importa as referências da fase
func import_ref(player_arg, ghosts_arg, HUD_arg, win_animplayer_arg, guide_arg, tree_arg):
	player = player_arg
	ghosts = ghosts_arg
	HUD = HUD_arg
	win_animplayer = win_animplayer_arg
	guide = guide_arg
	tree = tree_arg
	
# Inicia a fase
func init(init_time, init_direction):
	# Bloqueia temporariamente input do jogador e simula caminhar
	# à uma direção determinada
	player.target_position = player.global_position + Vector2(32,0)
	player.direction = init_direction
	yield(tree.create_timer(2.8), "timeout")
	# Bloqueia fantasmas
	for g in ghosts:
		g.set_physics_process(false)
	player.input_enabled = true

func detect_move():
	# Assim que o primeiro movimento for feito, desbloqueia fantasmas
	# e retira o nome da fase da tela
	if init == false and player.input_enabled and \
	(Input.is_action_pressed("ui_up") or \
	Input.is_action_pressed("ui_down") or \
	Input.is_action_pressed("ui_left") or \
	Input.is_action_pressed("ui_right")):
		init = true
		for g in ghosts:
			g.set_physics_process(true)
		HUD.undisplay_name()

# Desbloqueia a saída após coleta dos cristais
func unblock():
	# Ativa o modo caos
	tree.call_group("Ghosts","f_chaos")
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

# Finaliza o level e troca de cena
func finish_level(next_scene_path):
	# Retira o HUD
	HUD.finish()
	# Toca a transição
	HUD.transition()
	# Desativa o modo chaos dos fantasmas
	tree.call_group("Ghosts","f_chaos")
	# Aguarda e troca de cena
	yield(tree.create_timer(3), "timeout")
	tree.change_scene(next_scene_path)
	
