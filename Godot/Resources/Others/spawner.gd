extends TileMap

export(String, FILE, "*.tscn") var spawn_scene
export(NodePath) var parent
export(Vector2) var offset
export(Dictionary) var parameters
export(bool) var random_spawn
export(int) var amount

var scene

func _ready():
	# Carrega a cena que será instanciada
	scene = load(spawn_scene)
	var used_cells = get_used_cells()
	
	# Spawn aleatório: instancia amount vezes a cena em células aleatórios
	if random_spawn:
		for counter in range(0,amount):
			randomize()
			var rand_cell = used_cells[randi() % used_cells.size()]
			instance_scene(rand_cell)
	# Instancia a cena em todos as células marcadas
	else:
		for cell in used_cells:
			instance_scene(cell)
			
	yield(get_tree().create_timer(0.5), "timeout")
	queue_free()

# Instanciar a cena na célula cell
func instance_scene(cell):
	var instance = scene.instance()
	get_node(parent).call_deferred("add_child", instance)
	instance.global_position = to_global(map_to_world(cell)) + offset
	for p in parameters:
		instance.set(p, parameters[p])
