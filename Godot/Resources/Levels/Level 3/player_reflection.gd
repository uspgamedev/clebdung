extends Sprite

onready var player_sprite = Globals.current_level.get_player().get_sprite()


func _ready():
	# Inicia invisível
	get_material().set_shader_param("mask", 0)


func _process(_delta):
	# Atualiza a posição e o frame do sprite de reflexo
	position = player_sprite.global_position + Vector2(0,4)
	frame = player_sprite.frame
