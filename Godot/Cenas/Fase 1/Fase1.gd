extends Node2D

onready var player = get_node("YSort/Player")
onready var HUD = get_node("HUD")

func _ready():
	#Bloqueia temporariamente input do jogador e simula caminhar à direita
	player.direction = Vector2(1,0)
	yield(get_tree().create_timer(3.5), "timeout")
	player.input_enabled = true


func win():
	# Desativa input do jogador e simula caminhar à direita
	player.input_enabled = false
	player.direction = Vector2(1,0)
	# Desativa o modo chaos dos fantasmas
	# Espera o jogador avançar um pouco no caminho da saída
	yield(get_tree().create_timer(3), "timeout")
	get_tree().call_group("Ghosts","f_chaos")
	# Toca a animação para desligar luz dos fantasmas
	var ghosts = get_tree().get_nodes_in_group("Ghosts")
	for g in ghosts:
		g.get_node("AnimationPlayerL").play("Light_FadeOut")
	# Espera a animação da luz terminar
	yield(get_tree().create_timer(1), "timeout")
	# Deixa a luz dos fantasmas invisível
	for g in ghosts:
		g.get_node("Light2D").visible = false
	# Toca a animação para desligar luz do jogador
	player.get_node("AnimationPlayerL").play("Light_FadeOut")
	# Retira o HUD
	HUD.finish()
	# Espera a animação da luz terminar
	yield(get_tree().create_timer(2.5), "timeout")
	# Troca de cena
	print("Ganhou")
