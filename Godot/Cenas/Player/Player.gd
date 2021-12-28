extends KinematicBody2D

export(int) var speed = 85
var tile_size = 32

var direction = Vector2()
var last_position = Vector2()
var target_position = Vector2()

var input_enabled = false

func _ready():
	#Inicializar variáveis
	last_position = position
	target_position = position + Vector2(32,0)


func _process(_delta):
	animation()


func _physics_process(delta): 
	#MOVENDO
	#Colisão
	if $PlayerRayCast.is_colliding():
		position = last_position
		target_position = position
	else:
		#Mover-se
		move_and_collide(speed * direction * delta)
		
		if position.distance_to(last_position) >= tile_size - speed * delta:
			position = target_position
	
	#Parado
	if position == target_position:
		set_direction()
		last_position = position
		target_position += direction * tile_size


func set_direction():
	#Determinar direção
	var UP = Input.is_action_pressed("ui_up")
	var DOWN = Input.is_action_pressed("ui_down")
	var LEFT = Input.is_action_pressed("ui_left")
	var RIGHT = Input.is_action_pressed("ui_right")

	if input_enabled:
		direction.x = int(RIGHT) - int(LEFT)
		direction.y = int(DOWN) - int(UP)
	
	#Impedir movimento diagonal
	if direction.x != 0 && direction.y != 0:
		direction = Vector2(0,0)
	
	#Apontar Raycast
	if direction != Vector2():
		$PlayerRayCast.cast_to = direction * tile_size/2


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


func _on_PlayerArea2D_body_entered(body):
	if body.get_name().begins_with("Ghost"):
		get_tree().reload_current_scene()
