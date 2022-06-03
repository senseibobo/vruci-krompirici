extends CanvasLayer

signal transitioned
signal finished_transition

func transition():
	var tween = create_tween()
	tween.tween_property($ColorRect,"color:a",1.0,0.3)
	tween.tween_callback(self,"emit_signal",["transitioned"])
	tween.tween_property($ColorRect,"color:a",0.0,0.3)
	tween.tween_callback(self,"emit_signal",["finished_transition"])
