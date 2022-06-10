extends Sprite

var pos_offset = Vector2()
onready var player_sprite = Globals.current_level.get_player().get_sprite()


func _ready():
	if get_name().trim_prefix("Player") == "Mask":
		# Inicia completamente visível
		get_material().set_shader_param("mask", 1)
	else:
		# Inicia invisível
		get_material().set_shader_param("mask", 0)
		pos_offset = Vector2(0,4)


func _process(_delta):
	# Atualiza a posição e o frame do sprite
	position = player_sprite.global_position + pos_offset
	frame = player_sprite.frame


func interpolate_shader(final_value : float, time : float, delay : float):
	$Tween.interpolate_property(get_material(), "shader_param/mask", \
	get_material().get_shader_param("mask"), final_value, time, \
	Tween.TRANS_LINEAR, Tween.EASE_IN, delay)
	$Tween.start()
