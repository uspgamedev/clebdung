extends TileMap

onready var player_marker = get_parent().get_node("PlayerMarker")
onready var player = get_tree().get_root().get_node("Fase1").get_node("YSort/Player")


func _process(_delta):
	#Obter posição do player no minimapa e atualizar marcador
	player_marker.position = player.position/16
	
	#Rotacionar marcador
	match player.direction:
		Vector2(0,-1):
			player_marker.rotation_degrees = -90
		Vector2(0,1):
			player_marker.rotation_degrees = 90
		Vector2(-1,0):
			player_marker.rotation_degrees = -180
		Vector2(1,0):
			player_marker.rotation_degrees = 0
	
	#Obter tile do player no minimapa
	var playerpos_tile = world_to_map(player_marker.position)
	
	#Deletar tiles próximos
	for x in range(playerpos_tile.x-2, playerpos_tile.x+3):
		for y in range (playerpos_tile.y-2, playerpos_tile.y+3):
				set_cell(x, y, -1)
	
	
	
