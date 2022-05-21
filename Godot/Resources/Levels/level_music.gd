extends Node2D

export (Resource) var intro_music
export (Resource) var loop_music
export (Resource) var end_music
export (float) var volume
onready var intro_player = get_node("LevelIntro")
onready var loop_player = get_node("LevelLoop")
onready var end_player = get_node("LevelEnd")


func _ready():
	intro_player.stream = intro_music
	loop_player.stream = loop_music
	end_player.stream = end_music
	intro_player.playing = true


func _on_LevelIntro_finished():
	loop_player.playing = true


func finish_music():
	$Tween.interpolate_property(loop_player, "volume_db", 1*volume,\
	 -80, 0.5, Tween.EASE_IN)
	$Tween.start()
	end_player.playing = true
