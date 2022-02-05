extends Node2D

onready var player = get_node("YSort/Player")
onready var HUD = get_node("HUD")
onready var ghosts = get_tree().get_nodes_in_group("Ghosts")
onready var win_animplayer = get_node("Saida/AnimationPlayer")
var init = false

func _ready():
	#Bloqueia temporariamente input do jogador e simula caminhar à direita
	player.target_position = player.global_position + Vector2(32,0)
	player.direction = Vector2(1,0)
	yield(get_tree().create_timer(3.5), "timeout")
	# Bloqueia fantasmas
	for g in ghosts:
		g.set_physics_process(false)
	player.input_enabled = true

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
	get_tree().call_group("Ghosts","f_chaos")
	win_animplayer.play("Unblocked")

func win():
	# Desativa input do jogador e simula caminhar à direita
	player.input_enabled = false
	player.direction = Vector2(1,0)
	# Espera o jogador avançar um pouco no caminho da saída
	yield(get_tree().create_timer(4), "timeout")
	# Desativa o modo chaos dos fantasmas
	get_tree().call_group("Ghosts","f_chaos")
	# Retira o HUD
	HUD.finish()
	# Toca a transição
	HUD.transition()
	# Aguarda e troca de cena
	yield(get_tree().create_timer(3), "timeout")
	get_tree().change_scene("res://Recursos/Fase 2/Fase2.tscn")
