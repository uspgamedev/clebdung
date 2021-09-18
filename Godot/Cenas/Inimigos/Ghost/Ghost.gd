extends KinematicBody2D

enum States { RANDOM, FOLLOW, PATROL }

onready var astar = get_tree().get_root().get_node("Fase1").get_node("A*")
onready var player = get_tree().get_root().get_node("Fase1").get_node("YSort/Player")

var path = []
var speed = 60
var tile_size = 32
var direction = Vector2()
var last_position = Vector2()
var target_position = Vector2()

func _ready():
	$AnimationPlayer.play("Left")

	last_position = position
	target_position = position


func _process(delta):
	global_position += speed * direction * delta
		
	if position.distance_to(last_position) >= tile_size - speed * delta:
		position = target_position
	
	if position == target_position:
		set_direction()
		last_position = position
		target_position += direction * tile_size

func set_direction():
	_update_navigation_path(global_position, player.global_position)
	if len(path) > 1:
		direction = Vector2(path[1] - path[0]).normalized()
	else:
		direction = Vector2(0,0)

func _update_navigation_path(start_position, end_position):
	# It returns a PoolVector2Array of points that lead you
	# from the start_position to the end_position.
	path = astar.get_astar_path(start_position, end_position)
	# The first point is always the start_position.
	# We don't need it in this example as it corresponds to the character's position.
	#path.remove(0)
	if len(path) == 0:
		return
	#print(path)
	set_process(true)

