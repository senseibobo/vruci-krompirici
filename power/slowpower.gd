extends Power
class_name SlowPower

func _init():
	texture = preload("res://power/slow.png")

func use(player_number: int):
	if not is_instance_valid(Game.potato): return
	Game.potato.slowdown(3)
	yield(Game.get_tree().create_timer(3.0,false),"timeout")
	if not is_instance_valid(Game.potato): return
	Game.potato.speedup(3)
