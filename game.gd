extends Node


var players = {}
var potato
var fall_speed: float = 800
var heat_buildup: float = 8.0
var heat_punishment: float = 0.06
var main_scene: Node2D
var camera: Camera2D
var running: bool = true

var shake_amount: float
var shake_duration: float
var shake_left: float
var shake_frequency: float
var shake_time: float
var shake_noise: OpenSimplexNoise = OpenSimplexNoise.new()

func _process(delta):
	if shake_duration > 0:
		shake_time += shake_frequency*delta
		shake_left = move_toward(shake_left,0,delta)
		var a = shake_left/shake_duration
		camera.offset.x = shake_noise.get_noise_2d(shake_time,0)*shake_amount*a
		camera.offset.y = shake_noise.get_noise_2d(shake_time,100)*shake_amount*a

func shake_screen(shake_amount: float, shake_duration: float, shake_frequency: float):
	self.shake_amount = shake_amount
	self.shake_duration = shake_duration
	self.shake_left = shake_duration
	self.shake_frequency = shake_frequency
	
func finish_game(winner_number: int):
	players[3-winner_number].death()
	running = false
	for player in players:
		players[player].set_process(false)
