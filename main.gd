extends Node2D

var action_timer: Timer
export var wall_scene: PackedScene
export var power_scene: PackedScene
export(NodePath) onready var shader_rect = get_node(shader_rect)
export(NodePath) onready var background = get_node(background)
var time: float = 0.0
var bg_y: float = 0.0
	
func _process(delta):
	time += delta
	shader_rect.material.set_shader_param("c",time/40.0)
	bg_y -= Game.fall_speed*delta*1.2
	if bg_y < 0.243*7680:
		bg_y += 605
	background.global_position.y = bg_y-7680*0.243
	if time >= 10:
		if fmod(time-delta,2.5) > fmod(time,2.5):
			if randi()%100 <= 8:
				if randi()%4 > 0 and not Game.deathmatch:
					var heart = Scenes.heart.instance()
					add_child(heart)
					heart.setup()
				elif not Game.lights_out:
					var lightsout = Scenes.lights_out.instance()
					add_child(lightsout)
				
				
		


func _ready():
	if Game.deathmatch: $CanvasLayer3/ColorRect.visible = true
	Game.camera = $Camera2D
	Game.main = self
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
	
func create_wall(size: float = 1):
	var wall = wall_scene.instance()
	add_child(wall)
	wall.setup(size)
	return wall
	
func create_power():
	var power = power_scene.instance()
	add_child(power)
	power.setup()
