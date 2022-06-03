extends Control

export var buttons_node: NodePath

onready var buttons = get_node(buttons_node).get_children()

var selected_button
var currently_selected: int = 0
var button_scale: float = 1.0
const spacing: float = 10.0

func _ready():
	selected_button = buttons[currently_selected]
	for button in buttons:
		button.rect_pivot_offset = button.rect_size / 2.0
	yield(get_tree(),"idle_frame")
	yield(get_tree(),"idle_frame")
	update_selection_arrows()

func _process(delta):
	$Arrows.rect_scale = selected_button.rect_scale
	for button in buttons:
		if button == selected_button:
			button.rect_scale = button.rect_scale.linear_interpolate(Vector2.ONE*1.2,10*delta)
		else:
			button.rect_scale = button.rect_scale.linear_interpolate(Vector2.ONE*1,10*delta)
	if Input.is_action_just_pressed("ui_down"):
		currently_selected += 1
		update_selection_arrows()
	if Input.is_action_just_pressed("ui_up"):
		currently_selected -= 1
		update_selection_arrows()

func update_selection_arrows():
	currently_selected = fposmod(currently_selected, 3)
	selected_button = buttons[currently_selected]
	selected_button.grab_focus()
	$Arrows.rect_global_position = selected_button.rect_global_position + selected_button.rect_size/2.0
	var size = selected_button.rect_size.x/2.0
	$Arrows/LeftArrow.rect_position.x = -size - 40.0 - spacing
	$Arrows/RightArrow.rect_position.x = size + spacing
	$Arrows.rect_scale = selected_button.rect_scale
