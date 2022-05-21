extends TileMap

var spawner_scene : PackedScene


func _enter_tree():
	spawner_scene = load("res://Resources/Others/spawner.tscn")
	for i in range(0,5):
		_create_crystal_spawner(i)


func _create_crystal_spawner(i):
	var crystal_spawner := spawner_scene.instance()
	var cells := get_used_cells_by_id(i)
	
	if cells == []:
		return
	
	crystal_spawner.spawn_scene = "res://Resources/Crystal/crystal.tscn"
	crystal_spawner.parent = ("../../YSort")
	crystal_spawner.random_spawn = true
	crystal_spawner.amount = 1
	
	randomize()
	var offset_x := rand_range(10, 20)
	randomize()
	var offset_y := rand_range(10, 20)
	crystal_spawner.offset = Vector2(offset_x, offset_y)
	
	randomize()
	var scale_x := rand_range(0.6, 0.75)
	randomize()
	var scale_y := rand_range(0.6, 0.75)
	crystal_spawner.parameters = {"scale" : Vector2(scale_x, scale_y)}
	
	for cell in cells:
		crystal_spawner.set_cellv(cell, 0)
	add_child(crystal_spawner)
