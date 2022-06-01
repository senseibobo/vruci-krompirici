extends Node

signal game_started
signal game_over

var players = {}
var player_lives = {1: 3, 2: 3}
var potato
var fall_speed: float setget ,get_fall_speed
var fall_acceleration: float
var heat_buildup: float 
var heat_cooldown: float
var heat_punishment: float 
var main_scene: Node2D
var camera: Camera2D
var running: bool = false
var win_last: int = 0
var shake_amount: float
var shake_duration: float
var shake_left: float
var shake_frequency: float
var shake_time: float
var shake_noise: OpenSimplexNoise = OpenSimplexNoise.new()
var current_round: int
var last_player_win: int
var deathmatch: bool
var lights_out: bool
var fall_speed_multiplier: float = 1.0

var time: float
const speedup_time: float = 10.0

var music_player: AudioStreamPlayer

func get_fall_speed():
	return fall_speed * fall_speed_multiplier

func initialize():
	if is_instance_valid(music_player): music_player.queue_free()
	music_player = AudioStreamPlayer.new()
	music_player.stream = preload("res://sfx/muzika.ogg")
	add_child(music_player)
	music_player.play()
	deathmatch = false
	current_round = 1
	last_player_win = 0
	player_lives = {1: 3, 2: 3}
	start()

func start():
	randomize()
	if is_instance_valid(main_scene):
		main_scene.time = 0
	time = 0.0
	players = {}
	running = true
	fall_speed = 500
	fall_acceleration = 20
	fall_speed_multiplier = 1.0
	lights_out = false
	if deathmatch:
		heat_buildup = 3.0
		heat_cooldown = 40.0
		heat_punishment = 0.412
	else:
		heat_buildup = 8.0
		heat_cooldown = 8.0
		heat_punishment = 0.06
	emit_signal("game_started")
	if win_last !=0:
		player_lives[win_last] = player_lives[win_last]-1;

func play_sound(sound: AudioStream):
	var player = AudioStreamPlayer.new()
	player.stream = sound
	add_child(player)
	player.connect("finished",player,"queue_free")
	player.play()
	return player

func speedup():
	heat_punishment += 0.015
	
func _ready():
	OS.set_window_position(Vector2(0,0))
	OS.set_window_maximized(true)

func _process(delta):
	if Input.is_action_just_pressed("fullscreen"):
		OS.window_fullscreen = not OS.window_fullscreen
	if Input.is_action_just_pressed("screenshot"):
		screenshot()
	time += delta
	if shake_duration > 0 and is_instance_valid(camera):
		shake_time += shake_frequency*delta
		shake_left = move_toward(shake_left,0,delta)
		var a = shake_left/shake_duration
		camera.offset.x = shake_noise.get_noise_2d(shake_time,0)*shake_amount*a
		camera.offset.y = shake_noise.get_noise_2d(shake_time,100)*shake_amount*a
	if not running: return
	fall_speed_multiplier = move_toward(fall_speed_multiplier,1.0,0.6*delta)
	fall_speed += fall_acceleration*delta
	if fmod(time - delta, speedup_time) > fmod(time, speedup_time):
		speedup()

func shake_screen(shake_amount: float, shake_duration: float, shake_frequency: float):
	self.shake_amount = shake_amount
	self.shake_duration = shake_duration
	self.shake_left = shake_duration
	self.shake_frequency = shake_frequency
	
func finish_game(winner_number: int):
	emit_signal("game_over")
	players[3-winner_number].death()
	running = false
	main_scene.set_process(false)
	var dm = true
	for player in players:
		if player_lives[player] != 1: dm = false
		players[player].set_process(false)
	if dm: deathmatch = true

func screenshot():
	var im = ImageTexture.new()
	var tex = get_viewport().get_texture().get_data()
	tex.flip_y()
	im.create_from_image(tex)
	ResourceSaver.save("user://skrinsot.png",im)

func transition():
	var cl = CanvasLayer.new()
	cl.layer = 125
	var cr = ColorRect.new()
	add_child(cl)
	cl.add_child(cr)
	cr.anchor_right = 1.1
	cr.anchor_left = -0.1
	cr.anchor_top = -0.1
	cr.anchor_bottom = 1.1
	cr.margin_left = -100
	cr.color = Color(0,0,0,0)
	var tween = create_tween()
	tween.tween_property(cr,"color",Color.black,0.3)
	tween.tween_property(cr,"color",Color(0,0,0,0),0.3)
	tween.tween_callback(cl,"queue_free")
	yield(get_tree().create_timer(0.3,false),"timeout")
	return
