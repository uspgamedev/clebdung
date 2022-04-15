extends Sprite

onready var player = get_parent().get_node("YSort/Player")

func _ready():
	# Inicia invisível
	get_material().set_shader_param("mask", 0)

func _process(_delta):
	# Atualiza a posição e o frame do sprite de reflexo
	position = player.get_node("PlayerSprite").global_position + Vector2(0,4)
	frame = player.get_node("PlayerSprite").frame
