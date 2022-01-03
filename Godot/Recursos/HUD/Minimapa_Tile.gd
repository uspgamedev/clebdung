extends TileMap

onready var fase = find_parent("Fase*")
onready var player = fase.get_node("YSort/Player")
onready var player_marker = get_parent().get_node("PlayerMarker")
onready var mapa = get_parent()


func _process(_delta):
	if player_marker.position.x < 2 or mapa.texture.get_width() - 2 < player_marker.position.x:
		player_marker.visible = false
	else:
		player_marker.visible = true
	#Obter posição do player no minimapa e atualizar marcador
	player_marker.position = player.position/16 + Vector2(2,0)
	
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
	
	
	
