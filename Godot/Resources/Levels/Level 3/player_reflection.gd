extends Sprite

onready var player = get_parent().get_node("YSort/Player")

func _ready():
	get_material().set_shader_param("mask", 0)

func _process(_delta):
	position = player.get_node("PlayerSprite").global_position + Vector2(0,3)
	frame = player.get_node("PlayerSprite").frame
