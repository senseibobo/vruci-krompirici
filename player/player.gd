extends Node2D


export var number: int = 1
var powers: Array = [null,null,null]
var selected_power_index: int
var heat: float = 0.0
var has_potato: bool = false
var throw_timer: float = 0.0
var throw_cooldown: float = 0.5

func _ready():
	Game.connect("game_started",self,"on_game_start")
	if number == 2:
		for i in 3:
			var a = get_node("CanvasLayer/Control/PowerSlots/Arrow"+str(i+1))
			a.texture.atlas = preload("res://menu/arrowkeys.png")
#		$CanvasLayer/TextureRect.rect_position = Vector2(540,964)
		$CanvasLayer/Control.rect_scale.x = -1
	update_life_count()

func on_game_start():
	Game.players[number] = self

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
	for i in 3:
		if Input.is_action_just_pressed("player"+str(number)+"_power"+str(i+1)):
			use_power(i)
		
func adjust_size():
	$CanvasLayer/Control/ColorRect.color.r = 0.8+heat*2
	$CanvasLayer/Control/ColorRect.rect_position = Vector2(0,0)
	$CanvasLayer/Control/ColorRect.rect_size = Vector2(clamp(heat*450,0,450),16)
		

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
		$CanvasLayer/Control/Powers.get_node("PowerSlot"+str(index+1)).texture = t

func switch_power(d: int):
	if powers.size() == 0: return
	selected_power_index = fposmod(selected_power_index + d, powers.size())
	update_power_texture()

func throw_potato():
	if not has_potato: return
	if throw_timer > 0.0: return
	$AnimationPlayer.stop()
	$AnimationPlayer.play("bacanje")
	throw_timer = throw_cooldown
	Game.potato.dir = 3-number*2
	Game.potato.last_thrown = self
	Game.potato.in_posession = 0
	has_potato = false

func catch_potato():
	has_potato = true
	Game.potato.drill = false
	Game.potato.in_posession = number
	heat += Game.heat_punishment
	if Game.potato.sauce:
		heat += (1.0-heat)/4
		Game.potato.sauce = false
	Game.potato.additional_damage = 0
	Game.shake_screen(50,0.3,800)
	$CatchParticles.emitting = true

func death():
	var gameover = preload("res://menu/gameover.tscn").instance()
	Game.main_scene.add_child(gameover)
	Game.shake_screen(100,2.0,900)
	$DeathParticles.emitting = true
	Game.player_lives[number] -= 1
	update_life_count()

func update_life_count():
	for i in 4:
		get_node("CanvasLayer/Control/Hearts/Heart"+str(i+1)).visible = i < Game.player_lives[number]
	
func add_life():
	Game.player_lives[number] = min(Game.player_lives[number]+1,4)
	update_life_count()
	
