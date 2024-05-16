extends Node

var debug : bool = OS.is_debug_build()

@onready var debug_overlay : Control = get_node(Constants.debug)

@onready var game_overlay : Control = get_node(Constants.game)
@onready var menu_overlay : Control = get_node(Constants.main_menu)
@onready var lobby_overlay : Control = get_node(Constants.lobby)
@onready var saylog_overlay : Control = get_node(Constants.saylog)
@onready var pick_up_list : Interact = get_node(Constants.pick_up_list)

func _ready():
	toggle_menu_gui(true)

func _input(event):
	if debug:
		if event.is_action_pressed("debug"):
			if debug_overlay.visible:
				debug_overlay.hide()
			else:
				debug_overlay.show()

@rpc("authority", "call_local")
func toggle_game_gui(value):
	if value:
		game_overlay.show()
		saylog_overlay.show()
		menu_overlay.hide()
		lobby_overlay.hide()
	else:
		game_overlay.hide()

@rpc("authority", "call_local")
func toggle_menu_gui(value):
	if value:
		menu_overlay.show()
		game_overlay.hide()
		lobby_overlay.hide()
		saylog_overlay.hide()
	else:
		menu_overlay.hide()

@rpc("authority", "call_local")
func toggle_lobby_gui(value):
	if value:
		lobby_overlay.show()
		saylog_overlay.show()
		menu_overlay.hide()
		game_overlay.hide()
	else:
		lobby_overlay.hide()

func toggle_saylog_gui(value):
	if value:
		saylog_overlay.show()
	else:
		saylog_overlay.hide()
