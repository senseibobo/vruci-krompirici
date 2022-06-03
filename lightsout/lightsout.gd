extends CanvasLayer

onready var lo = $LightsOut

func _ready():
	Game.lights_out = true
	Game.connect("game_over",self,"queue_free")
	lo.color = Color(0,0,0,0)
	var tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(lo,"color",Color(0,0,0,1),1.0)
	tween.tween_property($Label,"modulate",Color(1,1,1,0),0.5)
	tween.tween_interval(6.5)
	tween.tween_property(lo,"color",Color(0,0,0,0),1.0)
	tween.tween_property(Game,"lights_out",false,0)
	tween.tween_callback(lo,"queue_free")

func _exit_tree():
	Game.lights_out = false
	
