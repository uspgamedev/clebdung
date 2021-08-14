extends TileMap

onready var player_marker = get_parent().get_node("PlayerMarker")
onready var player = get_tree().get_root().get_node("Fase1").get_node("YSort/Player")


func _process(_delta):
	#Obter posição do player no minimapa e atualizar marcador
	player_marker.position = player.position/16
	
	#Rotacionar marcador
	
	#Obter tile do player no minimapa
	var playerpos_tile = world_to_map(player_marker.position)
	
	#Deletar tiles próximos
	for x in range(playerpos_tile.x-3, playerpos_tile.x+4):
		for y in range (playerpos_tile.y-3, playerpos_tile.y+4):
				set_cell(x, y, -1)
	
	
	
