extends Node2D

onready var player = get_node("YSort/Player")

func _ready():
	#Bloqueia temporariamente input do jogador e simula caminhar à direita
	player.direction = Vector2(1,0)
	yield(get_tree().create_timer(3.5), "timeout")
	player.input_enabled = true


func win():
	print("Ganhou")
