extends Node2D

onready var player = get_node("YSort/Player")

func _ready():
	player.input_enabled = true

