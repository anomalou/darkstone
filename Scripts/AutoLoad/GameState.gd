extends Node

var _game_control : Control
var _menu_control : Control
var _lobby_control : Control


func _ready():
	_game_control = $/root/World/GUI/GameControl
	_menu_control = $/root/World/GUI/ConfigurationMenu
	_lobby_control = $/root/World/GUI/Lobby
	
	toggle_menu_gui(true)

@rpc("authority", "call_local")
func toggle_game_gui(value):
	if value:
		_game_control.show()
		_menu_control.hide()
		_lobby_control.hide()
	else:
		_game_control.hide()

@rpc("authority", "call_local")
func toggle_menu_gui(value):
	if value:
		_menu_control.show()
		_game_control.hide()
		_lobby_control.hide()
	else:
		_menu_control.hide()

@rpc("authority", "call_local")
func toggle_lobby_gui(value):
	if value:
		_lobby_control.show()
		_menu_control.hide()
		_game_control.hide()
	else:
		_lobby_control.hide()
