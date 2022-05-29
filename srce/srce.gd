extends Node2D


func setup():
	global_position = Vector2(450,2500)
	

func _process(delta):
	global_position.y -= Game.fall_speed*2.0*delta
	if global_position.y < -100:
		queue_free()
	if global_position.y <= 1024:
		$CanvasLayer/TextureRect.visible = false
	check_for_collision()

func check_for_collision():
	var ppos = Game.potato.global_position
	var pos = global_position
	var distance = sqrt(pow(ppos.x-pos.x,2)+pow(ppos.y-pos.y,2)/10)
	if distance < 32:
		Game.potato.last_thrown.add_life()
		queue_free()

