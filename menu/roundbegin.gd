extends CanvasLayer


func _ready():
	var tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	tween.tween_property($CenterContainer/VBoxContainer/Label,"modulate",Color(1,1,1,0),1.0)
	tween.tween_callback(self,"queue_free")
