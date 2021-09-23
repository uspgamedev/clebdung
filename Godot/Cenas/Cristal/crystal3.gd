extends Sprite

onready var astar = get_tree().get_root().get_node("Fase1").get_node("A*")
var LimitsI = Vector2(16,21)
var LimitsJ = Vector2(30,31)
var x_rand = Vector2()
var y_rand = Vector2()

var rng = RandomNumberGenerator.new()

func _ready():
	$AnimationPlayer.play('crystal')
	generate()
	while astar.get_cell(x_rand,y_rand) != 0:
		generate()
	global_position = astar.map_to_world(Vector2(x_rand,y_rand)) + Vector2(12,12)
	
func generate():
	rng.randomize()
	x_rand = int(rng.randf_range(LimitsI.x, LimitsJ.x))
	y_rand = int(rng.randf_range(LimitsI.y, LimitsJ.y))

func _on_Area2D_body_entered(body):
	if body.get_name() == "Player":
		#get_parent().score += 1
		queue_free()
