extends Sprite

onready var player_sprite = get_parent().get_node("YSort/Player/PlayerSprite")


func _ready():
	# Inicia completamente visível
	get_material().set_shader_param("mask", 1)

func _process(_delta):
	# Atualiza a posição e o frame do sprite
	position = player_sprite.global_position
	frame = player_sprite.frame
