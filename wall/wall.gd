extends Node2D


func setup():
	var height = 130+randf()*200
	var a = (randi()%3-1)*100+450
	global_position = Vector2(a,1070)
	$ColorRect.margin_top = 0
	$ColorRect.margin_bottom = height
	
func _process(delta):
	Game.potato.check_for_collision(self)
	global_position -= Vector2(0,Game.fall_speed)*delta
	if global_position.y < -500:
		queue_free()

func split(y_position: float):
	var height = $ColorRect.margin_bottom
	var local_y_position: float = y_position - global_position.y
	var height1 = height - local_y_position - 20
	$ColorRect.margin_bottom = height1
	var height2 = height - local_y_position - 20
	
	var bottom_wall = load("res://wall/wall.tscn").instance()
	bottom_wall.global_position = Vector2(global_position.x,y_position + 20)
	bottom_wall.get_node("ColorRect").margin_top = 0
	bottom_wall.get_node("ColorRect").margin_bottom = height2
	get_parent().add_child(bottom_wall)
