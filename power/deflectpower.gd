extends Power
class_name DeflectPower

func _init():
	texture = preload("res://power/deflectpower.png")

func use(player_number: int):
	var player = Game.players[player_number]
	var distance = abs(player.global_position.x - Game.potato.global_position.x)
	if Game.potato.dir == player_number*2-3 and distance < 120.0:
		Game.potato.dir = -Game.potato.dir
		Game.potato.bounced = false
		Game.potato.additional_damage += 0.1232
		
