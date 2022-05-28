extends CanvasLayer

var restartable: bool = false

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
		get_tree().reload_current_scene()
	
func _ready():
	$CenterContainer.modulate = Color(1.0,1.0,1.0,0.0)
	$CenterContainer/VBoxContainer/Label2.modulate = Color(1,1,1,0)
	var tween = Tween.new()
	add_child(tween)
	tween.interpolate_property(
		$CenterContainer,"modulate",$CenterContainer.modulate, Color.white,2.0)
	tween.start()
	yield(tween,"tween_all_completed")
	tween.interpolate_property(
		$CenterContainer/VBoxContainer/Label2,
		"modulate",Color(1,1,1,0),Color.white,1.0)
	tween.start()
	yield(tween,"tween_all_completed")
	restartable = true
