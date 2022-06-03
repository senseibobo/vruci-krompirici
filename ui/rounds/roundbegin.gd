extends CanvasLayer


func _ready():
	if Game.deathmatch: $CenterContainer/VBoxContainer/Label2.visible = true
	$CenterContainer/VBoxContainer/Label.text = "Round " + str(Game.current_round)
	var tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	tween.tween_property($CenterContainer/VBoxContainer,"modulate",Color(1,1,1,0),1.0)
	tween.tween_callback(self,"queue_free")
