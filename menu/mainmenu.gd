extends Control

onready var buttons = [
	$CenterContainer/VBoxContainer2/VBoxContainer/Button,
	$CenterContainer/VBoxContainer2/VBoxContainer/Button2,
]

onready var selected_button: Button = buttons[0]
onready var selection_arrows: Control = $Selection
var currently_selected: int = 0
var button_scale: float = 1.0

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept"):
		selected_button.emit_signal("pressed")

func _ready():
	update_selection_arrows()

func _process(delta):
	for button in buttons:
		if button == selected_button:
			button.rect_scale = button.rect_scale.linear_interpolate(Vector2.ONE*1.2,10*delta)
		else:
			button.rect_scale = button.rect_scale.linear_interpolate(Vector2.ONE*1,10*delta)
	if Input.is_action_just_pressed("ui_down") and currently_selected == 0:
		selected_button = buttons[1]
		currently_selected = 1
		update_selection_arrows()
	if Input.is_action_just_pressed("ui_up") and currently_selected == 1:
		selected_button = buttons[0]
		currently_selected = 0
		update_selection_arrows()
	
func update_selection_arrows():
	selection_arrows.get_parent().remove_child(selection_arrows)
	selected_button.add_child(selection_arrows)
	selection_arrows.rect_position = selected_button.rect_size/2


func _on_play_pressed():
	Transition.transition()
	yield(Transition,"transitioned")
	get_tree().change_scene_to(Game.main_scene)
	Game.initialize()


func _on_quit_pressed():
	get_tree().quit(-1)
