extends CanvasLayer

export(NodePath) onready var title_label = get_node(title_label)
export(NodePath) onready var restart_label = get_node(restart_label)
export(NodePath) onready var quit_label = get_node(quit_label)
export(NodePath) onready var cc = get_node(cc) 

var restartable: bool = false
var quittable: bool = false

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept") and restartable:
		var reset_game: bool = false
		restartable = false
		for p in Game.player_lives:
			if Game.player_lives[p] == 0:
				reset_game = true
		
		if reset_game:
			Game.initialize()
		else:
			Game.start()
		yield(Game.transition(),"completed")
		get_tree().reload_current_scene()
	elif event.is_action_pressed("ui_cancel") and quittable:
		get_tree().change_scene("res://menu/mainmenu.tscn")
	
func _ready():
	title_label.text = "GAME OVER\nPLAYER " + str(Game.last_player_win) + " WINS!"
	cc.modulate = Color(1.0,1.0,1.0,0.0)
	restart_label.modulate = Color(1,1,1,0)
	quit_label.modulate = Color(1,1,1,0)
	var tween = create_tween()
	tween.tween_property(cc,"modulate", Color.white,2.0)
	tween.tween_property(restart_label,"modulate",Color.white,1.0)
	tween.tween_property(self,"restartable",true,0.0)
	tween.tween_property(quit_label,"modulate",Color.white,1.0)
	tween.tween_property(self,"quittable",true,0.0)
