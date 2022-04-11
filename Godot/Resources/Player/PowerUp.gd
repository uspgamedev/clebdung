extends Sprite

onready var player_sprite = get_parent()

func _process(_delta):
	frame = player_sprite.frame
