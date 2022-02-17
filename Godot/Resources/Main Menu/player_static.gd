extends KinematicBody2D

export(int) var speed = 85
var tile_size = 32

var direction = Vector2()
var last_position = Vector2()
var target_position = Vector2()
var anim_direc = "Right"

var input_enabled = false

var c = true
func _ready():
	#Inicializar variáveis
	last_position = position
	target_position = position



func _physics_process(delta): 
	#MOVENDO
	#Colisão
	set_direction()


func set_direction():
	#Determinar direção
	var animation
	
	
	if Input.is_action_pressed("ui_left") and c:
		anim_direc = "Left"
		c = false
		get_node("Timer").start(1.5)
	elif Input.is_action_pressed("ui_right") and c:
		anim_direc = "Right"
		c = false
		get_node("Timer").start(1.5)	
	animation = anim_direc + "_" + "Idle"

	get_node("AnimationPlayer").play(animation)
	








func _on_Timer_timeout():
	c = true
