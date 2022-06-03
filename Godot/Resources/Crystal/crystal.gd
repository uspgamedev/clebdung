extends Sprite

signal collected_crystal
onready var animplayer := get_node("AnimationPlayer")


func _ready():
	add_to_group("Crystals")


# Caso o jogador "colida" com o cristal, apague-o do mapa e emita um sinal:
func _on_CollectionArea_body_entered(_body):
	emit_signal("collected_crystal")
	queue_free()

# Se a distância até o jogador for pequena
func _on_CloseArea_body_entered(_body):
	_play_crystal_light_anim()


# Se a distância até o jogador for MUITO pequena
func _on_TooCloseArea_body_entered(_body):
	_play_crystal_anim()

# Se a distância até o jogador voltar a ser pequena e não MUITO pequena
func _on_TooCloseArea_body_exited(_body):
	_play_crystal_light_anim()


# Se o jogador se distanciar completamente do cristal
func _on_CloseArea_body_exited(_body):
	_stop_anim()


func _play_crystal_anim():
	# Espera terminar animação anterior, caso houver
	if animplayer.is_playing():
		yield(animplayer, "animation_changed")
	# Limpa a fila de animações e toca a animação padrão
	animplayer.clear_queue()
	animplayer.play("Crystal")


func _play_crystal_light_anim():
	# Espera terminar animação anterior, caso houver
	if animplayer.is_playing():
		yield(animplayer, "animation_changed")
	# Limpa a fila de animações e toca a animação de dica
	animplayer.clear_queue()
	animplayer.play("Crystal_Light")


func _stop_anim():
	# Espera terminar animação anterior, caso houver
	if animplayer.is_playing():
		yield(animplayer, "animation_changed")
	# Limpa a fila de animações
	animplayer.clear_queue()
