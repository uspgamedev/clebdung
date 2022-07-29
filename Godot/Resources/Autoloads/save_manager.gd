extends Node

const SAVE_DIR = "user://saves/"
const SAVE_PATH = SAVE_DIR + "save.dat"


func load_save():
	var file = File.new()
	if file.file_exists(SAVE_PATH):
		var error = file.open(SAVE_PATH, File.READ)
		if error == OK:
			var save_dict = file.get_var()
			file.close()
			return save_dict
	else:
		save_game(1, 1, ["power_up0", "power_up0", "power_up0"], \
		[Vector2(176, 496)], [])
		return load_save()


func save_game(level : int, torchs_counter : int, \
equiped_power_ups : Array, saved_torchs : Array, saved_power_ups : Array):
	var save_dict = {
		"level" : level,
		"torchs_counter" : torchs_counter,
		"equiped_power_ups" : equiped_power_ups,
		"saved_torchs" : saved_torchs,
		"saved_power_ups" : saved_power_ups,
	}
	
	var dir = Directory.new()
	if !dir.dir_exists(SAVE_DIR):
		dir.make_dir_recursive(SAVE_DIR)
	
	var file = File.new()
	var error = file.open(SAVE_PATH, File.WRITE)
	if error == OK:
		file.store_var(save_dict)
		file.close()


func get_last_level():
	var file = File.new()
	if file.file_exists(SAVE_PATH):
		var error = file.open(SAVE_PATH, File.READ)
		if error == OK:
			var dict = file.get_var()
			file.close()
			return dict["level"]
