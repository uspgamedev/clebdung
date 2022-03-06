extends TileMap

export(String, FILE, "*.tscn") var spawn_scene
export(NodePath) var parent
export(Vector2) var offset


func _ready():
	var scene = load(spawn_scene)
	var used_cells = get_used_cells()
	for cell in used_cells:
		var instance = scene.instance()
		get_node(parent).call_deferred("add_child", instance)
		instance.global_position = to_global(map_to_world(cell)) + offset
