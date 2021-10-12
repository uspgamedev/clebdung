extends KinematicBody2D

export(int) var speed = 85
var tile_size = 32

var direction = Vector2()
var last_position = Vector2()
var target_position = Vector2()

func _ready():
	
	#Play animação luz
	$AnimationPlayerL.play("Light")
	
	#Inicializar variáveis
	last_position = position
	target_position = position

func _process(delta):
	#MOVENDO
	if $PlayerRayCast.is_colliding():
		#COLIDIU
		position = last_position
		target_position = position
	else:
		#Mover-se
		position += speed * direction * delta
		
		if position.distance_to(last_position) >= tile_size - speed * delta:
			position = target_position
	
	#Parado
	if position == target_position:
		set_direction()
		last_position = position
		target_position += direction * tile_size
	animation()

func set_direction():
	#Determinar direção
	var UP = Input.is_action_pressed("ui_up")
	var DOWN = Input.is_action_pressed("ui_down")
	var LEFT = Input.is_action_pressed("ui_left")
	var RIGHT = Input.is_action_pressed("ui_right")

	direction.x = int(RIGHT) - int(LEFT)
	direction.y = int(DOWN) - int(UP)
	
	#Impedir movimento diagonal
	if direction.x != 0 && direction.y != 0:
		direction = Vector2(0,0)
	
	#Apontar Raycast
	if direction != Vector2():
		$PlayerRayCast.cast_to = direction * tile_size * 1.8
		
func animation():
	var anim_direc
	var anim_modo
	var animation
	
	match $PlayerRayCast.cast_to.normalized():
		Vector2(0,-1):
			anim_direc = "Up"
		Vector2(0,1):
			anim_direc = "Down"
		Vector2(-1,0):
			anim_direc = "Left"
		Vector2(1,0):
			anim_direc = "Right"
		Vector2(0,0):
			anim_direc = "Null"
	
	if direction != Vector2(0,0):
		anim_modo = "Walk"
	else:
		anim_modo = "Idle"
		
	animation = anim_direc + "_" + anim_modo 
	get_node("AnimationPlayer").play(animation)
	
