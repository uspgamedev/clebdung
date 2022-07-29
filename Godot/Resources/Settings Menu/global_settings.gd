extends Node

signal fps_displayed(value)
signal bloom_toggled(value)
signal brightness_updated(value)
signal fov_updated(value)
signal mouse_sens_updated(value)


func toggle_fullscreen(toggle):
	OS.window_fullscreen = toggle
	SaveSettings.game_data.fullscreen_on = toggle
	SaveSettings.save_data()
	
	
func toggle_vsync(toggle):
	OS.vsync_enabled = toggle
	SaveSettings.game_data.vsync_on = toggle
	SaveSettings.save_data()
	
	
func toggle_fps_display(toggle):
	emit_signal("fps_displayed", toggle)
	SaveSettings.game_data.display_fps = toggle
	SaveSettings.save_data()
	
	
func set_max_fps(value):
	Engine.target_fps = value if value < 500 else 0
	SaveSettings.game_data.max_fps = Engine.target_fps if value < 500 else 500
	SaveSettings.save_data()
	
	
func toggle_bloom(value):
	emit_signal("bloom_toggled", value)
	SaveSettings.game_data.bloom_on = value
	SaveSettings.save_data()
	
	
func update_brightness(value):
	emit_signal("brightness_updated", value)
	SaveSettings.game_data.brightness = value
	SaveSettings.save_data()
	
	
func update_master_vol(vol):
	AudioServer.set_bus_volume_db(0, vol)
	SaveSettings.game_data.master_vol = vol
	SaveSettings.save_data()
	
	
func update_music_vol(vol):
	AudioServer.set_bus_volume_db(1, vol)
	
		
func update_sfx_vol(vol):
	AudioServer.set_bus_volume_db(2, vol)
	
	
func update_fov(value):
	emit_signal("fov_updated", value)
	SaveSettings.game_data.fov = value
	SaveSettings.save_data()
	
	
func update_mouse_sens(value):
	emit_signal("mouse_sens_updated", value)
	SaveSettings.game_data.mouse_sens = value
	SaveSettings.save_data()
	

