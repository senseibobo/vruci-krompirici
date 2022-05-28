extends Power
class_name DrillPower

func _init():
	texture = preload("res://power/drillpower.png")

func use(player_number: int):
	if Game.potato.in_posession != player_number: return false
	Game.players[player_number].throw_potato()
	Game.potato.drill = true
	return true
