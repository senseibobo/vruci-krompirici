extends Control


func _ready():
	$"%Volume".value = Settings.volume

func _exit_tree():
	Settings.save_settings()



func _on_Back_pressed():
	get_tree().change_scene_to(Scenes.main_menu)


func _on_Volume_value_changed(value):
	Settings.volume = value
	print(value)


func _on_Fullscreen_pressed():
	OS.window_fullscreen = !OS.window_fullscreen
