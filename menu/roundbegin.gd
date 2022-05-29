extends CanvasLayer


func _ready():
	var tween = Tween.new()
	add_child(tween)
	tween.interpolate_property($CenterContainer/VBoxContainer/Label,"modulate",Color.white,Color(1,1,1,0),1.0,Tween.TRANS_CUBIC,Tween.EASE_IN)
	tween.start()
	yield(tween,"tween_all_completed")
	queue_free()
