extends Power
class_name SlowPower

func _init():
	texture = preload("res://power/slowpower.png")

func use(player_number: int):
	Game.potato.speed /= 3.0
	yield(Game.get_tree().create_timer(3.0,false),"timeout")
	Game.potato.speed *= 3.0
