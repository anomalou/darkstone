extends Node

var debug : bool = false

@onready var game_control : Control = get_node(Constants.game)
@onready var menu_control : Control = get_node(Constants.main_menu)
@onready var lobby_control : Control = get_node(Constants.lobby)
@onready var saylog : Control = get_node(Constants.saylog)
@onready var pick_up_list : Interact = get_node(Constants.pick_up_list)


func _ready():
	if not debug:
		toggle_menu_gui(true)
	else:
		toggle_game_gui(true)

@rpc("authority", "call_local")
func toggle_game_gui(value):
	if value:
		game_control.show()
		saylog.show()
		menu_control.hide()
		lobby_control.hide()
	else:
		game_control.hide()

@rpc("authority", "call_local")
func toggle_menu_gui(value):
	if value:
		menu_control.show()
		game_control.hide()
		lobby_control.hide()
		saylog.hide()
	else:
		menu_control.hide()

@rpc("authority", "call_local")
func toggle_lobby_gui(value):
	if value:
		lobby_control.show()
		saylog.show()
		menu_control.hide()
		game_control.hide()
	else:
		lobby_control.hide()

func toggle_saylog_gui(value):
	if value:
		saylog.show()
	else:
		saylog.hide()
