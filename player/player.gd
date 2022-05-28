extends Sprite


export var number: int = 1
var powers: Array
var selected_power_index: int
var heat: float = 0.0
var has_potato: bool = false
var throw_timer: float = 0.0
var throw_cooldown: float = 0.5

func _ready():
	Game.players[number] = self
	if number == 2:
		$CanvasLayer/TextureRect.rect_position = Vector2(540,964)

func _process(delta):
	if not Game.running: return
	throw_timer -= delta
	if has_potato:
		heat = clamp(heat + Game.heat_buildup/100.0*delta,0,1)
		if heat >= 1:
			Game.finish_game(3-number)
	else:
		heat = clamp(heat - Game.heat_buildup/100.0*delta,0,1)
	adjust_size()
	if Input.is_action_just_pressed("player"+str(number)+"_throw"):
		throw_potato()
	if Input.is_action_just_pressed("player"+str(number)+"_special"):
		use_power()
	if Input.is_action_just_pressed("player"+str(number)+"_switchright") and powers.size() > 0:
		selected_power_index = fposmod(selected_power_index+1,powers.size())
		update_power_texture()
	if Input.is_action_just_pressed("player"+str(number)+"_switchright") and powers.size() > 0:
		selected_power_index = fposmod(selected_power_index-1,powers.size())
		update_power_texture()
	
func adjust_size():
	if number == 1:
		$CanvasLayer/Control/ColorRect.rect_position = Vector2(0,0)
		$CanvasLayer/Control/ColorRect.rect_size = Vector2(clamp(heat*300,0,300),16)
	else:
		$CanvasLayer/Control/ColorRect.rect_position = Vector2(600-clamp(heat*300,0,300),0)
		$CanvasLayer/Control/ColorRect.rect_size = Vector2(clamp(heat*300,0,300),16)
		

func add_power(power):
	powers.append(power)
	selected_power_index = powers.size()-1
	update_power_texture()

func use_power():
	if powers.size() == 0: return
	var power = powers[selected_power_index]
	power.use(number)
	powers.remove(selected_power_index)
	selected_power_index = powers.size()-1
	update_power_texture()

func update_power_texture():
	if powers.size() > 0:
		$CanvasLayer/TextureRect.texture = powers[selected_power_index].texture
	else:
		$CanvasLayer/TextureRect.texture = null

func switch_power(d: int):
	if powers.size() == 0: return
	selected_power_index = fposmod(selected_power_index + d, powers.size())
	update_power_texture()

func throw_potato():
	if not has_potato: return
	if throw_timer > 0.0: return
	throw_timer = throw_cooldown
	Game.potato.dir = 3-number*2
	Game.potato.last_thrown = self
	Game.potato.in_posession = 0
	has_potato = false

func catch_potato():
	has_potato = true
	Game.potato.in_posession = number
	heat += Game.heat_punishment
	Game.shake_screen(50,0.3,800)
	$CatchParticles.emitting = true

func death():
	Game.shake_screen(100,2.0,900)
	$DeathParticles.emitting = true
	
