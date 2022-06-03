extends Control




func _on_play_pressed():
	Transition.transition()
	yield(Transition,"transitioned")
	get_tree().change_scene_to(Scenes.main)
	Game.initialize()


func _on_quit_pressed():
	get_tree().quit(-1)


func _on_settings_pressed():
	get_tree().change_scene_to(Scenes.settings)
