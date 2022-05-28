extends Sprite

export var speed: float = 2000

var in_posession: int = 0 setget set_posession
var dir: int = 1
var bounced: bool = false
var last_thrown
var additional_damage: float = 0.0
var drill: bool = false
var sauce: bool = false

func set_posession(posession: int):
	in_posession = posession

func _ready():
	Game.potato = self

func _physics_process(delta):
	$Particles2D.emitting = in_posession == 0
	if in_posession == 0:
		global_position.x += speed*dir*delta
		if global_position.x > Game.players[2].global_position.x:
			bounced = false
			global_position.x = Game.players[2].global_position.x - 20
			Game.players[2].catch_potato()
		elif global_position.x < Game.players[1].global_position.x:
			global_position.x = Game.players[1].global_position.x+20
			bounced = false
			Game.players[1].catch_potato()

func check_for_collision(wall):
	var collider_rect: Rect2 = wall.get_node("ColorRect").get_global_rect()
	if collider_rect.has_point(global_position):
		if drill:
			wall.split(global_position.y)
		elif not bounced:
			bounce()
	
func bounce():
	bounced = true
	dir = -dir
