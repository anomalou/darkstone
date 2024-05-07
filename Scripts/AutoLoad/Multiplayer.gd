extends Node

# Player resources
var _player_scene : PackedScene

# Races
var _human_scene : PackedScene

# Map resources
var _map : PackedScene

# Network
var _root : Node2D
var _peer : ENetMultiplayerPeer

var _server_info : Node

# Connected player data
var _is_connected : bool = false

var _username : String
var _local_player_id : int # Multiplayer ID of local player
#var _local_player_path : NodePath

func _ready():
	_root = $/root/World/Network
	_peer = ENetMultiplayerPeer.new()
	
	_server_info = $/root/World/ServerInfo
	
	_player_scene = load("res://Components/player.tscn")
	_human_scene = load("res://Components/Body/human_body.tscn")
	_map = load("res://Maps/test.tscn")

@rpc("authority", "call_local")
func _join_lobby(id):
	_local_player_id = id
	_server_info.connect_player.rpc_id(1, id, _username)

func _init_player_data(id = 1):
	_join_lobby.rpc_id(id, id)

func start_game():
	if _local_player_id != 1:
		return
	
	var _ready = _server_info.ready_players.keys()
	for player_id in _ready:
		start_game_for(player_id)

func start_game_for(id):
	var body = _human_scene.instantiate()
	body.name = str(id) + "_body"
	_root.add_child(body)
	
	var player = _player_scene.instantiate()
	player.name = str(id) + "_player"
	_root.add_child(player)
	player.set_body.rpc_id(id, body.get_path())
	player.set_alive.rpc_id(id, true)
	#_local_player_path = player.get_path()
	
	_server_info.update_path(id, player.get_path())
	$/root/GameState.toggle_game_gui.rpc_id(id, true)

func host(username, port):
	_username = username
	
	_peer.create_server(port)
	multiplayer.multiplayer_peer = _peer
	multiplayer.peer_connected.connect(_init_player_data)
	
	var map = _map.instantiate()
	_root.add_child(map)
	
	_init_player_data()
	_is_connected = true

func join_server(username, ip, port):
	_username = username
	
	_peer.create_client(ip, port)
	multiplayer.multiplayer_peer = _peer
	multiplayer.connected_to_server.connect(when_connect)
	multiplayer.server_disconnected.connect(when_disconnected)

func when_connect():
	_is_connected = true
	
func when_disconnected():
	_is_connected = false
