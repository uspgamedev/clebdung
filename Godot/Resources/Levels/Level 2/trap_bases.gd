extends TileMap

func _ready():
	var cells = get_parent().get_node("TrapSpawner").get_used_cells()
	for cell in cells:
		set_cellv(cell, 0)
