extends Control

onready var heat_bar = $HeatBar

func _ready():
	update_powers()

func update_powers():
	for i in 3:
		set_power(i, get_parent().get_parent().powers[i])

func set_power(index = 0, present: bool = true):
	get_node("Powers/Power"+str(index+1)).visible = present

func update_lives(life_count: int = 3):
	for i in 4:
		get_node("Hearts/Heart"+str(i+1)).visible = i < life_count

func set_heating(enabled: bool = true):
	$Heating.modulate = Color.crimson if enabled else Color.gray

func update_heat_bar(heat: float, flash: float):
	heat_bar.color = Color(0.8+heat*2,flash,flash)
	heat_bar.rect_position = Vector2(0,0)
	heat_bar.rect_size = Vector2(clamp(heat*450,0,450),32)
