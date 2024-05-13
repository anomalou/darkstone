extends Node

var debug : bool = false

var _game_control : Control
var _menu_control : Control
var _lobby_control : Control
var _saylog : Control
var interact : Interact


func _ready():
	_game_control = $/root/World/GUI/GameControl
	_menu_control = $/root/World/GUI/ConfigurationMenu
	_lobby_control = $/root/World/GUI/Lobby
	_saylog = $/root/World/GUI/Saylog
	interact = $/root/World/GUI/Interact
	
	if not debug:
		toggle_menu_gui(true)
	else:
		toggle_game_gui(true)

@rpc("authority", "call_local")
func toggle_game_gui(value):
	if value:
		_game_control.show()
		_saylog.show()
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
		_saylog.hide()
	else:
		_menu_control.hide()

@rpc("authority", "call_local")
func toggle_lobby_gui(value):
	if value:
		_lobby_control.show()
		_saylog.show()
		_menu_control.hide()
		_game_control.hide()
	else:
		_lobby_control.hide()

func toggle_saylog_gui(value):
	if value:
		_saylog.show()
	else:
		_saylog.hide()
