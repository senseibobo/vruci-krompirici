extends Node2D

const powers: Array = [WallPower,SlowPower,SaucePower]
var power_index: int = 0
var power: Power
var taken: bool = false

func setup():
	power_index = randi()%powers.size()
	power = powers[power_index].new() as Power
	global_position.x = 450
	global_position.y = 1050
	$TextureRect.texture = power.texture


func _process(delta):
	global_position.y -= Game.fall_speed*delta
	if global_position.y < -500: queue_free()
	if is_instance_valid(Game.potato):
		var ppos = Game.potato.global_position
		var pos = global_position
		var distance = sqrt(pow(ppos.x-pos.x,2)+pow(ppos.y-pos.y,2)/10)
		if distance < 32 and not taken:
			Game.play_sound(preload("res://sfx/powerup-repaired.ogg"))
			Game.potato.last_thrown.add_power(power_index)
			taken = true
			queue_free()
