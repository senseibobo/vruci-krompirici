extends Node


var volume: float setget set_volume, get_volume

func _ready():
	load_settings()

func set_volume(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"),linear2db(value))

func get_volume():
	return db2linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master")))

func load_settings():
	var save_dict = Save.load_from_file("user://settings.json")
	if save_dict is Dictionary:
		self.volume = save_dict["volume"]
		OS.window_fullscreen = save_dict["fullscreen"]

func save_settings():
	var save_dict = {
		"volume": self.volume,
		"fullscreen": OS.window_fullscreen
	}
	Save.save_to_file(save_dict, "user://settings.json")


func _notification(what):
	if what == NOTIFICATION_WM_QUIT_REQUEST:
		save_settings()
		get_tree().quit()
