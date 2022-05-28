extends Node


var players = {}
var player_lives = {1: 0, 2: 0}
var potato
var fall_speed: float
var fall_acceleration: float
var heat_buildup: float 
var heat_punishment: float 
var main_scene: Node2D
var camera: Camera2D
var running: bool = false

var shake_amount: float
var shake_duration: float
var shake_left: float
var shake_frequency: float
var shake_time: float
var shake_noise: OpenSimplexNoise = OpenSimplexNoise.new()

var time: float
const speedup_time: float = 10.0

func initialize():
	player_lives = {1: 3, 2: 3}
	start()

func start():
	time = 0.0
	players = {}
	running = true
	fall_speed = 500
	fall_acceleration = 20
	heat_buildup = 8.0
	heat_punishment = 0.06

func speedup():
	heat_punishment += 0.015
	
func _process(delta):
	if not running: return
	fall_speed += fall_acceleration*delta
	time += delta
	if fmod(time - delta, speedup_time) > fmod(time, speedup_time):
		speedup()
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
	main_scene.set_process(false)
	for player in players:
		players[player].set_process(false)
