extends Node2D

var action_timer: Timer
export var wall_scene: PackedScene
export var power_scene: PackedScene
var time: float = 0.0
var bg_y: float = 0.0
	
func _process(delta):
	time += delta
	bg_y -= Game.fall_speed*delta
	if bg_y < 0.243*7680:
		bg_y += 1050
	$Bg.global_position.y = bg_y-7680*0.243
	if fmod(time-delta,2.5) > fmod(time,2.5):
		if randi()%100 <= 5:
			var srce = preload("res://srce/srce.tscn").instance()
			add_child(srce)
			srce.setup()


func _ready():
	Game.camera = $Camera2D
	Game.main_scene = self
	action_timer = Timer.new()
	add_child(action_timer)
	action_timer.start(0.7)
	action_timer.connect("timeout",self,"on_action_timer")
	Game.start()

func on_action_timer():
	var r = randi()%3
	match r:
		0: create_wall()
		1: create_wall()
		2: create_power()
	
func create_wall():
	var wall = wall_scene.instance()
	add_child(wall)
	wall.setup()
	return wall
	
func create_power():
	var power = power_scene.instance()
	add_child(power)
	power.setup()
