extends Sprite

export var speed: float = 2000

var in_posession: int = 0 setget set_posession
var dir: int = 1
var bounced: bool = false
var last_thrown
var additional_damage: float = 0.0
var drill: bool = false
var sauce: bool = false
var default_strength: int = 50
var old_position: Vector2

onready var trail = $Trail
onready var defaultparticles = $DefaultParticles
onready var sauceparticles = $SauceParticles

func set_posession(posession: int):
	in_posession = posession

func _ready():
	dir = Game.current_round%2*2-1
	Game.potato = self

func speedup(a: float):
	trail.default_color = Color(2.0,1.43,0.58)
	speed*=a
	
func slowdown(a: float):
	trail.default_color = Color.aqua*2.0
	speed/=a

func _physics_process(delta):
	var emitting = in_posession == 0
	defaultparticles.emitting = emitting and not sauce
	sauceparticles.emitting = emitting and sauce
	old_position = global_position
	if in_posession == 0:
		rotation += dir*delta*20
		global_position.x += speed*dir*delta
		
		if 2 in Game.players and global_position.x > Game.players[2].global_position.x:
			bounced = false
			global_position.x = Game.players[2].global_position.x - 20
			Game.players[2].catch_potato()
		elif 1 in Game.players and global_position.x < Game.players[1].global_position.x:
			global_position.x = Game.players[1].global_position.x+20
			bounced = false
			Game.players[1].catch_potato()

func check_for_collision(wall):
	var collider_rect: Rect2 = wall.get_node("TextureRect").get_global_rect()
	if collider_rect.has_point(global_position) or collider_rect.has_point(old_position):
		if drill:
			wall.split(global_position.y)
		elif not bounced:
			bounce()
	
func bounce():
	bounced = true
	dir = -dir
