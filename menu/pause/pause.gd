extends CanvasLayer

var quitting: float = 0.0
var quit: bool = false


func _process(delta):
	if Input.is_action_just_pressed("pause") and Game.running:
		get_tree().paused = !get_tree().paused
		$ColorRect.visible = get_tree().paused
		do_pause_music_effect()
	if Game.running and Input.is_action_pressed("quit_to_main_menu") and get_tree().paused:
		quitting += delta
		if quitting >= 1.0:
			Music.stop()
			Game.running = false
			quit = true
			Transition.transition_out()
			$ColorRect.visible = false
			get_tree().paused = false
			get_tree().change_scene_to(Scenes.main_menu)
			
	else:
		quitting = move_toward(quitting, 0.0, delta)
	$ColorRect/Label.modulate.a = 1.0-quitting

var effect_index: int
func do_pause_music_effect():
	if Music.playing:
		if get_tree().paused:
			var effect = AudioEffectNotchFilter.new()
			effect.resonance = 0.2
			effect_index = Music.add_effect(effect)
		else:
			Music.remove_effect(effect_index)
