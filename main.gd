extends Node2D

var action_timer: Timer
export var wall_scene: PackedScene
export var power_scene: PackedScene

	

func _ready():
	Game.camera = $Camera2D
	Game.main_scene = self
	action_timer = Timer.new()
	add_child(action_timer)
	action_timer.start(0.7)
	action_timer.connect("timeout",self,"on_action_timer")

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
