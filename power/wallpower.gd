extends Power
class_name WallPower

func _init():
	texture = preload("res://power/wallpower.png")

func use(player_number: int):
	Game.main_scene.create_wall()
