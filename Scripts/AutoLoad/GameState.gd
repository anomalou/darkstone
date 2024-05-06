extends Node2D

var _game_control : Control
var _menu_control : Control


func _ready():
	_game_control = get_node("/root/World/GUI/GameControl")
	_menu_control = get_node("/root/World/GUI/ConfigurationMenu")
	
	toggle_menu_gui(true)

func toggle_game_gui(value):
	if value:
		_game_control.show()
		_menu_control.hide()
	else:
		_game_control.hide()

func toggle_menu_gui(value):
	if value:
		_menu_control.show()
		_game_control.hide()
	else:
		_menu_control.hide()
