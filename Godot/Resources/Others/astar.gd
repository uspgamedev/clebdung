extends TileMap

# The Tilemap node doesn't have clear bounds so we're defining the map's limits here.
export(Vector2) var map_size = Vector2.ONE * 33

# The path start and end variables use setter methods.
# You can find them at the bottom of the script.
var path_start_position = Vector2() setget _set_path_start_position
var path_end_position = Vector2() setget _set_path_end_position

var _point_path = []

# You can only create an AStar node from code, not from the Scene tab.
onready var astar_node = AStar.new()
var obstacles
onready var _half_cell_size = cell_size / 2


func _ready():
	# get_used_cells_by_id is a method from the TileMap node.
	# Here the id 0 corresponds to the obstacles.
	obstacles = get_used_cells_by_id(1)
	var walkable_cells_list = astar_add_walkable_cells(obstacles)
	astar_connect_walkable_cells(walkable_cells_list)

# Loops through all cells within the map's bounds and
# adds all points to the astar_node, except the obstacles.
func astar_add_walkable_cells(obstacle_list = []):
	var points_array = []
	for y in range(map_size.y):
		for x in range(map_size.x):
			var point = Vector2(x, y)
			if point in obstacle_list:
				continue

			points_array.append(point)
			# The AStar class references points with indices.
			# Using a function to calculate the index from a point's coordinates
			# ensures we always get the same index with the same input point.
			var point_index = calculate_point_index(point)
			# AStar works for both 2d and 3d, so we have to convert the point
			# coordinates from and to Vector3s.
			astar_node.add_point(point_index, Vector3(point.x, point.y, 0.0))
	return points_array

# Once you added all points to the AStar node, you've got to connect them.
# The points don't have to be on a grid: you can use this class
# to create walkable graphs however you'd like.
# It's a little harder to code at first, but works for 2d, 3d,
# orthogonal grids, hex grids, tower defense games...
func astar_connect_walkable_cells(points_array):
	for point in points_array:
		var point_index = calculate_point_index(point)
		# For every cell in the map, we check the one to the top, right.
		# left and bottom of it. If it's in the map and not an obstalce.
		# We connect the current point with it.
		var points_relative = PoolVector2Array([
			point + Vector2.RIGHT,
			point + Vector2.LEFT,
			point + Vector2.DOWN,
			point + Vector2.UP,
		])
		for point_relative in points_relative:
			var point_relative_index = calculate_point_index(point_relative)
			if is_outside_map_bounds(point_relative):
				continue
			if not astar_node.has_point(point_relative_index):
				continue
			# Note the 3rd argument. It tells the astar_node that we want the
			# connection to be bilateral: from point A to B and B to A.
			# If you set this value to false, it becomes a one-way path.
			# As we loop through all points we can set it to false.
			astar_node.connect_points(point_index, point_relative_index, false)


func calculate_point_index(point):
	return point.x + map_size.x * point.y


func is_outside_map_bounds(point):
	return point.x < 0 or point.y < 0 or point.x >= map_size.x or point.y >= map_size.y


func get_astar_path(world_start, world_end):
	self.path_start_position = world_to_map(world_start)
	self.path_end_position = world_to_map(world_end)
	_recalculate_path()
	var path_world = []
	for point in _point_path:
		var point_world = map_to_world(Vector2(point.x, point.y)) + _half_cell_size
		path_world.append(point_world)
	return path_world


func _recalculate_path():
	var start_point_index = calculate_point_index(path_start_position)
	var end_point_index = calculate_point_index(path_end_position)
	# This method gives us an array of points. Note you need the start and
	# end points' indices as input.
	_point_path = astar_node.get_point_path(start_point_index, end_point_index)

# Setters for the start and end path values.
func _set_path_start_position(value):
	if value in obstacles:
		return
	if is_outside_map_bounds(value):
		return
	path_start_position = value
	if path_end_position and path_end_position != path_start_position:
		_recalculate_path()


func _set_path_end_position(value):
	if value in obstacles:
		return
	if is_outside_map_bounds(value):
		return
	path_end_position = value
	if path_start_position != value:
		_recalculate_path()


func remove_walkable_cells(cells : Array, delay : float):
	_modify_cells(cells, 1, delay)


func insert_walkable_cells(cells : Array, delay : float):
	_modify_cells(cells, 0, delay)


func _modify_cells(cells : Array, type : int, delay : float):
	if delay == 0.0:
		for cell in cells:
			set_cellv(cell, type)
		_ready()
	else:
		for cell in cells:
			set_cellv(cell, type)
			_ready()
			yield(get_tree().create_timer(delay), "timeout")
