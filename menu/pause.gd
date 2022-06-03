extends CanvasLayer


func _process(delta):
	if Input.is_action_just_pressed("pause") and Game.running:
		get_tree().paused = !get_tree().paused
		$ColorRect.visible = get_tree().paused
