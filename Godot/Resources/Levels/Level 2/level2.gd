extends LevelRoot

onready var block = get_node("YSort/Exit/Exit1")
onready var ladder_sup = get_node("Stairs/Exit2")


func _ready():
	# Esconde os power ups do HUD
	hud.get_node("Control/PowerUpSlot1").visible = false
	hud.get_node("Control/PowerUpSlot2").visible = false
	hud.get_node("Control/PowerUpSlot3").visible = false


func win():
	# Desativa a Area2D da escada
	get_node("Stairs/StairsArea2D").monitoring = false
	# Código padrão de LevelRoot
	lock_player()
	# Desativa a luz do jogador
	player.get_node("AnimationPlayerL").play("Light_FadeOut")
	# Retira colisões e conserta as camadas dos sprites da saída
	block.get_node("Exit1").z_index = 1
	block.get_node("CollisionShape2D").disabled = true
	ladder_sup.get_node("Exit2").z_index = 1
	ladder_sup.get_node("CollisionShape2D").disabled = true
	# Código padrão de LevelRoot
	finish_level()
