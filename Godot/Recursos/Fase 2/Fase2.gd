extends Node2D

onready var player = get_node("YSort/Player")
onready var HUD = get_node("HUD")
onready var ghosts = get_tree().get_nodes_in_group("Ghosts")
onready var win_animplayer = get_node("YSort/Saida/AnimationPlayer")
onready var block = get_node("YSort/Saida/Bloco")
onready var ladder_sup = get_node("SaidaAbaixo/SupEscada")

var init = false

func _ready():
	#Bloqueia temporariamente input do jogador e simula caminhar à direita
	player.target_position = player.global_position + Vector2(32,0)
	player.direction = Vector2(1,0)
	yield(get_tree().create_timer(2.8), "timeout")
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
	#get_tree().call_group("Ghosts","f_chaos")
	win_animplayer.play("Unblocked")

func win():
	# Desativa input do jogador e simula caminhar à direita
	player.input_enabled = false
	player.direction = Vector2(0,1)
	player.get_node("AnimationPlayerL").play("Light_FadeOut")
	# Retira colisões e conserta as camadas dos sprites da saída
	block.get_node("Saida1").z_index = 1
	block.get_node("CollisionShape2D").disabled = true
	ladder_sup.get_node("Saida2").z_index = 1
	ladder_sup.get_node("CollisionShape2D").disabled = true
	# Espera o jogador avançar um pouco no caminho da saída
	# yield(get_tree().create_timer(0.2), "timeout")
	# Retira o HUD
	HUD.finish()
	# Toca a transição
	HUD.transition()
	# yield(get_tree().create_timer(0.8), "timeout")
	# player.direction = Vector2(0,0)
	# Desativa o modo chaos dos fantasmas
	# get_tree().call_group("Ghosts","f_chaos")


	# Aguarda e troca de cena
