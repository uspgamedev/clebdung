extends Node2D

var k := 0
var on_stairs := false
var on_area := false
var remove_astar_cells := [
	Vector2(16,18), 
	Vector2(15,18), 
	Vector2(17,18)
]
var insert_astar_cells := [
	Vector2(15,15), 
	Vector2(15,16), 
	Vector2(16,15), 
	Vector2(17,15),
	Vector2(17,16),
]
onready var level : LevelRoot = Globals.current_level
onready var astar = level.get_astar()
onready var player = level.get_player()
onready var animplayer = get_node("AnimationPlayer")


func _process(_delta):
	# Desbloqueia a saída e retira o Astar onde o bloco é movido
	if on_area and k == 0 and animplayer.get_current_animation() == "Unblocked":
		animplayer.play("WinAnimation")
		# O Astar é retirado "em cima da hora" e gradualmente, 
		# para evitar bugs
		yield(get_tree().create_timer(1.0), "timeout")
		astar.remove_walkable_cells(remove_astar_cells, 0.4)
		k = 1
	# Caso o jogador esteja andando em direção às escadas
	# após o desbloqueio, encerrar fase
	if on_stairs and player.get_direction() == Vector2(0,1):
		level.win()


# (Área só funciona após coleta dos 5 cristais)
func _on_AnimArea2D_body_entered(_body):
	on_area = true


func _on_AnimationPlayer_animation_changed(old_name, _new_name):
	# Ativa Astar próximo à escada após desbloqueio da saída
	if old_name == "WinAnimation":
		astar.insert_walkable_cells(insert_astar_cells, 0)

# (Área só funciona após desbloqueio da saída)
func _on_StairsArea2D_body_entered(_body):
	on_stairs = true

# (Área só funciona após desbloqueio da saída)
func _on_StairsArea2D_body_exited(_body):
	on_stairs = false


func _on_AnimArea2D_body_exited(_body):
	on_area = false
