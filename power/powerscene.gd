extends Node2D

const powers: Array = [WallPower,SlowPower,SaucePower]
var power: Power
var taken: bool = false

func setup():
	power = powers[randi()%powers.size()].new() as Power
	global_position.x = 450
	global_position.y = 1050
	$TextureRect.texture = power.texture

func _process(delta):
	global_position.y -= Game.fall_speed*delta
	var ppos = Game.potato.global_position
	var pos = global_position
	var distance = sqrt(pow(ppos.x-pos.x,2)+pow(ppos.y-pos.y,2)/10)
	if distance < 32 and not taken:
		Game.potato.last_thrown.add_power(power)
		taken = true
		queue_free()
