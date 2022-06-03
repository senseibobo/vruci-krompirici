extends AudioStreamPlayer

var bus_index: int
var effect_count: int = 0

func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS
	bus = "Music"
	bus_index = AudioServer.get_bus_index("Music")

func add_effect(effect: AudioEffect):
	AudioServer.add_bus_effect(bus_index,effect,effect_count)
	effect_count += 1
	return effect_count-1

func remove_effect(effect_index: int):
	AudioServer.remove_bus_effect(bus_index,effect_index)
	effect_count -= 1

func play_music(stream: AudioStream, time: float = 0.0, fade_in: float = 0.0, fade_out: float = 0.0):
	self.stream = stream
	var tween = create_tween()
	if fade_out > 0:
		tween.tween_property(self,"volume_db",-80.0,fade_out)
		tween.tween_callback(self,"stop")
		tween.tween_callback(self,"play",[time])
	else:
		if fade_in > 0:
			volume_db = -80
		play(time)
	if fade_in > 0:
		tween.tween_property(self,"volume_db",0.0,fade_in)
	pass

func stop_music():
	pass
