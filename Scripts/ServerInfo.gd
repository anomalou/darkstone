extends Node
class_name ServerInfo

@onready var _root : Node2D = get_node(Constants.network)
var _timer : Timer

# Player resources
var _player_scene : PackedScene

# Races
var _human_scene : PackedScene

var host : String
var online_players : Dictionary # id : Username
var ready_players : Dictionary # id : path

var game_countdown : int = 180
var time_left : int = 0
var is_game_started : bool = false


func _ready():
	_timer = $Timer
	_player_scene = load("res://Components/player.tscn")
	_human_scene = load("res://Components/Body/Human.tscn")
	
	_timer.timeout.connect(_countdown)

@rpc("any_peer", "call_local")
func set_countdown(value):
	game_countdown = value
	time_left = value
	if _timer.is_stopped():
		_timer.start(1.0)

func _countdown():
	if time_left <= 0:
		if ready_players.size() != 0:
			start_game.rpc_id(1)
			_timer.stop()
		else:
			Saylog.add.rpc("Restart countdown")
			time_left = game_countdown
			return
	time_left -= 1

@rpc("any_peer", "call_local")
func discover_player(username):
	var id = multiplayer.get_remote_sender_id()
	online_players[id] = username

func is_ready(id):
	return ready_players.has(id)

@rpc("any_peer", "call_local")
func get_ready():
	var id = multiplayer.get_remote_sender_id()
	if online_players.has(id):
		ready_players[id] = ""

@rpc("any_peer", "call_local")
func not_ready():
	var id = multiplayer.get_remote_sender_id()
	if ready_players.has(id):
		ready_players.erase(id)

@rpc("any_peer", "call_local")
func update_path(path):
	var id = Multiplayer.get_multiplayer_authority()
	if ready_players.has(id):
		ready_players[id] = path

@rpc("authority", "call_local")
func start_game():
	if ready_players.size() <= 0:
		Saylog.add.rpc("No ready players. Cant start game")
		return
	
	_timer.stop()
	
	var _ready_players = ready_players.keys()
	for player_id in _ready_players:
		start_game_for(player_id)
	is_game_started = true

func start_game_for(id):
	var body = _human_scene.instantiate()
	body.name = str(id) + "_body"
	_root.add_child(body)
	
	var player : Player = _player_scene.instantiate()
	player.name = str(id) + "_player"
	_root.add_child(player)
	player.set_body.rpc_id(id, body.get_path())
	player.set_alive.rpc_id(id, true)
	
	update_path.rpc_id(id, player.get_path())
	$/root/GameState.toggle_game_gui.rpc_id(id, true)
