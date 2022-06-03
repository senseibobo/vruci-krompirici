extends Power
class_name WallPower


func _init():
	texture = preload("res://power/wall.png")

func use(player_number: int):
	var wall = Game.main.create_wall(2)
	var wall_rect = wall.get_node("TextureRect")
	wall.global_position.y = 300
	wall_rect.rect_scale = Vector2(0,1)
	Game.fall_speed_multiplier = 0.1
	var tween = wall.create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(wall_rect,"rect_scale",Vector2(1,1),1.0)
