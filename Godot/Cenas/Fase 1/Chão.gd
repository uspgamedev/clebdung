extends TileMap

onready var player = get_parent().get_node("YSort/Player")
onready var player_positionT1 = world_to_map(player.get_position())

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	player_positionT1 = world_to_map(player.get_position())
#	pass
