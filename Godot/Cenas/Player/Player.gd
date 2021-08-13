extends Sprite

var speed = 100
var tile_size = 32

var direction = Vector2()
var last_position = Vector2()
var target_position = Vector2()

func _ready():
	
	#RESETAR VARIÁVEIS
	last_position = position
	target_position = position

func _process(delta):
	#MOVER-SE
	if position != target_position:
		position += speed * direction * delta
		
		if position.distance_to(last_position) >= tile_size - speed* delta:
			position = target_position
	
	#PARADO
	if position == target_position:
		set_direction()
		last_position = position
		target_position += direction * tile_size
	

func set_direction():
	#DETERMINAR DIREÇÃO	
	var UP = Input.is_action_pressed("ui_up")
	var DOWN = Input.is_action_pressed("ui_down")
	var LEFT = Input.is_action_pressed("ui_left")
	var RIGHT = Input.is_action_pressed("ui_right")

	direction.x = int(RIGHT) - int(LEFT)
	direction.y = int(DOWN) - int(UP)
	
	#IMPEDIR MOVIMENTO DIAGONAL
	if direction.x != 0 && direction.y != 0:
		direction = Vector2(0,0)
	
