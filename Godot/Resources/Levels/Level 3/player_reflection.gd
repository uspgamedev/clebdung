extends Sprite

onready var player_sprite = get_parent().get_node("YSort/Player/PlayerSprite")


func _ready():
	# Inicia invisível
	get_material().set_shader_param("mask", 0)

func _process(_delta):
	# Atualiza a posição e o frame do sprite de reflexo
	position = player_sprite.global_position + Vector2(0,4)
	frame = player_sprite.frame
