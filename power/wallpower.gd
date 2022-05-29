extends Power
class_name WallPower


func _init():
	texture = preload("res://power/wall.png")

func use(player_number: int):
	var wall = Game.main_scene.create_wall(2)
	var tween = Tween.new()
	Game.add_child(tween)
	var wall_rect = wall.get_node("TextureRect")
	wall_rect.rect_scale = Vector2(0,1)
	tween.connect("tween_all_completed",tween,"queue_free")
	tween.interpolate_property(wall_rect,"rect_scale",Vector2(0,1),Vector2(1,1),1.0,Tween.TRANS_SINE,Tween.EASE_OUT)
	var duration = 1.5
	tween.interpolate_property(Game,"fall_speed",100,Game.fall_speed+Game.fall_acceleration*duration,duration)
	tween.start()
	wall.global_position.y = 300
