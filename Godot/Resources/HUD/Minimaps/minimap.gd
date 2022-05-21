extends Control

onready var player : KinematicBody2D = Globals.current_level.get_player()
onready var player_marker := get_node("PlayerMarker")
onready var map_texture := get_node("MinimapTexture")
onready var tile_map := get_node("MinimapTileMap")


func _process(_delta):
	# Checar se o marcador saiu das fronteiras do minimapa
	if (
		player_marker.position.x < 2 
		or map_texture.texture.get_width() - 2 < player_marker.position.x
		or player_marker.position.y < 2 
		or map_texture.texture.get_height() - 2 < player_marker.position.y
	):
		player_marker.visible = false
	else:
		player_marker.visible = true
	
	# Obter posição do player no minimapa e atualizar marcador
	player_marker.position = player.global_position/16 + Vector2(2,0)
	
	# Rotacionar marcador
	match player.get_direction():
		Vector2(0,-1):
			player_marker.rotation_degrees = -90
		Vector2(0,1):
			player_marker.rotation_degrees = 90
		Vector2(-1,0):
			player_marker.rotation_degrees = -180
		Vector2(1,0):
			player_marker.rotation_degrees = 0
	
	# Obter tile do player no minimapa
	var playerpos_tile : Vector2 = tile_map.world_to_map(player_marker.position)
	# Deletar tiles próximos
	for x in range(playerpos_tile.x-2, playerpos_tile.x+3):
		for y in range (playerpos_tile.y-2, playerpos_tile.y+3):
				tile_map.set_cell(x, y, -1)
