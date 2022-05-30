extends Power
class_name SaucePower

func _init():
	texture = preload("res://power/sauce.png")

func use(player_number: int):
	Game.potato.sauce = true
