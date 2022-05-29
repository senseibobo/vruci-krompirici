extends Node2D


const faces = [
	preload("res://player/Face_1@2x.png"),
	preload("res://player/Face_2@2x.png"),
	preload("res://player/Face_3@2x.png")
]

export var number: int = 1
var powers: Array = [null,null,null]
var selected_power_index: int
var heat: float = 0.0
var has_potato: bool = false
var throw_timer: float = 0.0
var throw_cooldown: float = 0.5
var flash: float = 0.0

func _ready():
	Game.connect("game_started",self,"on_game_start")
	if number == 2:
		$CanvasLayer/Control.rect_scale.x = -1
		$CanvasLayer/Control/PowerSlots/Key1.texture = preload("res://menu/Button_Arrow_Left.png")
		$CanvasLayer/Control/PowerSlots/Key2.texture = preload("res://menu/Button_Arrow_Up.png")
		$CanvasLayer/Control/PowerSlots/Key3.texture = preload("res://menu/Button_Arrow_Right.png")
	update_life_count()

func on_game_start():
	Game.players[number] = self

var old_heat: float 

func _process(delta):
	if not Game.running: return
	flash = move_toward(flash,0,delta*4.0)
	$Sprite.scale.x = 0.08+sin(Game.time*5.0+number)/220.0
	$Sprite.position.x = sin(Game.time*4.0+number)*10.0
	$Sprite.scale.y = 0.08+cos(Game.time*5.0+number)/220.0
	throw_timer -= delta
	if has_potato:
		heat = clamp(heat + Game.heat_buildup/100.0*delta,0,1)
		if heat >= 1:
			Game.finish_game(3-number)
		$CanvasLayer/Control/Heating.modulate = Color.crimson
		$CanvasLayer/Control/Cooling.modulate = Color.gray
	else:
		$CanvasLayer/Control/Cooling.modulate = Color.aqua
		$CanvasLayer/Control/Heating.modulate = Color.gray
		heat = clamp(heat - Game.heat_cooldown/100.0*delta,0,1)
	$Sprite/Face.texture = faces[min(int(heat*3.0),2)]
	$Sprite.self_modulate = Color.white.linear_interpolate(Color.red,int(heat*3.0)/3.0)
	if old_heat < 0.66 and heat >= 0.66:
		$Sprite/Smoke.emitting = true
		$Sprite/Smoke2.emitting = true
	elif heat < 0.66:
		$Sprite/Smoke.emitting = false
		$Sprite/Smoke2.emitting = false
	adjust_size()
	if Input.is_action_just_pressed("player"+str(number)+"_throw"):
		throw_potato()
	for i in 3:
		if Input.is_action_just_pressed("player"+str(number)+"_power"+str(i+1)):
			use_power(i)
	old_heat = heat

func f(x):
	return max(fmod(-x,2)-1,0)

func adjust_size():
	$CanvasLayer/Control/ColorRect.color = Color(0.8+heat*2,flash,flash)
	$CanvasLayer/Control/ColorRect.rect_position = Vector2(0,0)
	$CanvasLayer/Control/ColorRect.rect_size = Vector2(clamp(heat*450,0,450),32)
		

func add_power(power):
	var index: int
	if power is WallPower: index = 0
	elif power is SlowPower: index = 1
	elif power is SaucePower: index = 2
	if powers[index] != null:
		heat += 0.053
	else:
		powers[index] = power
	selected_power_index = powers.size()-1
	update_power_texture()

func use_power(power_index):
	var power = powers[power_index]
	if power == null: return
	power.use(number)
	powers[power_index] = null
	update_power_texture()

func update_power_texture():
	for index in 3:
		var t = powers[index].texture if powers[index] != null else null
		$CanvasLayer/Control/Powers.get_node("Power"+str(index+1)).texture = t

func switch_power(d: int):
	if powers.size() == 0: return
	selected_power_index = fposmod(selected_power_index + d, powers.size())
	update_power_texture()

func throw_potato():
	if not has_potato: return
	if throw_timer > 0.0: return
	Game.play_sound(preload("res://sfx/throw.wav"))
	$AnimationPlayer.stop()
	$AnimationPlayer.play("bacanje")
	throw_timer = throw_cooldown
	Game.potato.dir = 3-number*2
	Game.potato.last_thrown = self
	Game.potato.in_posession = 0
	if not Game.potato.sauce:
		Game.potato.set_strength(Game.potato.default_strength)
	has_potato = false

func catch_potato():
	Game.play_sound(preload("res://sfx/hit.wav"))
	has_potato = true
	Game.potato.drill = false
	Game.potato.in_posession = number
	Game.potato.additional_damage = 0
	if Game.potato.sauce:
		heat += 0.1+(1.0-heat)/5
		Game.potato.sauce = false
		Game.shake_screen(60,0.5,900)
	else:
		Game.shake_screen(50,0.3,800)
	heat += Game.heat_punishment
	flash = 1.1
	$CatchParticles.emitting = true

const death_textures = {
	1: preload("res://player/death_player1.png"),
	2: preload("res://player/death_player2.png")
}

func death():
	Game.player_lives[number] -= 1
	update_life_count()
	Game.play_sound(preload("res://sfx/smrt.wav"))
	Game.current_round += 1
	Game.last_player_win = 3-number
	if Game.player_lives[number] == 0:
		var gameover = preload("res://menu/gameover.tscn").instance()
		Game.main_scene.add_child(gameover)
	else:
		var roundover = preload("res://menu/roundover.tscn").instance()
		Game.main_scene.add_child(roundover)
	Game.shake_screen(100,2.0,900)
	$DeathParticles.emitting = true
	Game.potato.queue_free()
	yield(get_tree().create_timer(0.3,false),"timeout")
	$Sprite/Face.queue_free()
	$Sprite/Smoke.emitting = false
	$Sprite/Smoke2.emitting = false
	$Sprite.self_modulate = Color.white
	$Sprite.texture = death_textures[number]

func update_life_count():
	for i in 4:
		get_node("CanvasLayer/Control/Hearts/Heart"+str(i+1)).visible = i < Game.player_lives[number]
	
func add_life():
	Game.player_lives[number] = min(Game.player_lives[number]+1,4)
	update_life_count()
	
