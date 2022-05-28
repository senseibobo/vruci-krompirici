extends Line2D

var p: Array = []
var timer: float = 0.0
const point_count: int = 10

func _ready():
	set_as_toplevel(true)
	global_position = Vector2()

func _process(delta):
	timer -= delta
	if timer <= 0:
		p.append(get_parent().global_position)
		if p.size() > point_count:
			p.pop_front()
		timer = 0.01
	points = p
