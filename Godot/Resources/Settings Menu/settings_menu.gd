extends Popup

# Video Settings
onready var display_options = $SettingTabs/Video/MarginContainer/VideoSettings/DisplayOptions


# Audio Settings
onready var master_slider = $SettingTabs/Audio/MarginContainer2/AudioSettings/MasterSlider


func _ready():
	
	display_options.select(1 if Save.game_data.fullscreen_on else 0)
	GlobalSettings.toggle_fullscreen(Save.game_data.fullscreen_on)
	
	master_slider.value = Save.game_data.master_vol
	
func _on_OptionButton_item_selected(index):
	GlobalSettings.toggle_fullscreen(true if index == 1 else false)

	

func _on_MasterSlider_value_changed(value):
	GlobalSettings.update_master_vol(value)

