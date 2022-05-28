extends Power
class_name WallPower

func _init():
	texture = preload("res://power/wallpower.png")

func use(player_number: int):
	var wall = Game.main_scene.create_wall()
	var tween = Tween.new()
	Game.add_child(tween)
	var wall_rect = wall.get_node("ColorRect")
	wall_rect.rect_scale = Vector2(0,1)
	tween.connect("tween_all_completed",tween,"queue_free")
	tween.interpolate_property(wall_rect,"rect_scale",Vector2(0,1),Vector2(1,1),1.0,Tween.TRANS_SINE,Tween.EASE_OUT)
	tween.start()
	wall.global_position.y = 550
