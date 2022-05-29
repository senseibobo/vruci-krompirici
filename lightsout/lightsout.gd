extends ColorRect


func _ready():
	Game.connect("game_over",self,"queue_free")
	var tween = Tween.new()
	add_child(tween)
	tween.interpolate_property(self,"color",Color(0,0,0,0),Color(0,0,0,1),1.0,Tween.TRANS_CUBIC,Tween.EASE_OUT)
	tween.start()
	yield(tween,"tween_all_completed")
	tween.interpolate_property($Label,"modulate",Color(1,1,1,1),Color(1,1,1,0),0.5)
	tween.start()
	yield(get_tree().create_timer(7.0,false),"timeout")
	tween.interpolate_property(self,"color",Color(0,0,0,1),Color(0,0,0,0),1.0,Tween.TRANS_CUBIC,Tween.EASE_IN)
	tween.start()
	yield(tween,"tween_all_completed")
	queue_free()
	
