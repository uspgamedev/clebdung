extends TileMap

onready var player_marker = get_parent().get_node("PlayerMarker")
onready var player_positionT1 = get_tree().get_root().get_node("Fase1").get_node("Chão").get("player_positionT1")
onready var player_positionT2 = Vector2(player_positionT1.x + 1, player_positionT1.y)



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	player_positionT1 = get_tree().get_root().get_node("Fase1").get_node("Chão").get("player_positionT1")
	player_positionT2 = Vector2(player_positionT1.x + 1, player_positionT1.y)
	player_marker.position = (player_marker.position.linear_interpolate(map_to_world(player_positionT2) + Vector2(1,1), 0.1))
	print(player_marker.position)
	for x in range(player_positionT2.x-3, player_positionT2.x+4):
		for y in range (player_positionT2.y-3, player_positionT2.y+4):
			set_cell(x, y, -1)
