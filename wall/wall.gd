extends Node2D


func setup():
	var height = 50+randf()*200
	global_position = Vector2(300,1070)
	$ColorRect.margin_top = -40
	$ColorRect.margin_bottom = height+40

func _physics_process(delta):
	global_position -= Vector2(0,Game.fall_speed)*delta
	
func _process(delta):
	Game.potato.check_for_collision($ColorRect.get_global_rect())
