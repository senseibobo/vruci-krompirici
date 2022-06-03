extends CanvasLayer

var restartable: bool = false
var quittable: bool = false

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept") and restartable:
		var reset_game: bool = false
		for p in Game.player_lives:
			if Game.player_lives[p] == 0:
				reset_game = true
		
		if reset_game:
			Game.initialize()
		else:
			Game.start()
		Transition.transition()
		yield(Transition,"transitioned")
		get_tree().change_scene_to(Scenes.main)
		var roundbegin = Scenes.round_begin.instance()
		Game.add_child(roundbegin)
	elif event.is_action_pressed("ui_cancel") and quittable:
		get_tree().change_scene_to(Scenes.main_menu)
	
func _ready():
	$CenterContainer/VBoxContainer/Label.text = "Player " + str(Game.last_player_win) + " wins!"
	$CenterContainer/VBoxContainer/Label2.text = "Press space to begin round " + str(Game.current_round)
	$CenterContainer.modulate = Color(1.0,1.0,1.0,0.0)
	$CenterContainer/VBoxContainer/Label2.modulate = Color(1,1,1,0)
	var tween = create_tween()
	tween.tween_property($CenterContainer,"modulate", Color.white,2.0)
	tween.tween_property($CenterContainer/VBoxContainer/Label2,"modulate",Color.white,1.0)
	tween.tween_property(self,"restartable",true,0.0)
