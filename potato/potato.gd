extends Sprite

export var speed: float = 2000

var in_posession: int = 0
var dir: int = 1
var bounced: bool = false
var last_thrown

func _ready():
	Game.potato = self

func _physics_process(delta):
	if in_posession == 0:
		global_position.x += speed*dir*delta
		if global_position.x > 480:
			bounced = false
			global_position.x = 479
			Game.players[2].catch_potato()
		elif global_position.x < 120:
			global_position.x = 121
			bounced = false
			Game.players[1].catch_potato()

func check_for_collision(collider_rect: Rect2):
	if collider_rect.has_point(global_position) and not bounced:
		bounce()
	
func bounce():
	bounced = true
	dir = -dir
