extends Node

# Map resources
var _map : PackedScene

# Network
var _root : Node2D
var _peer : ENetMultiplayerPeer

var _server_info : ServerInfo

# Connected player data
var _is_connected : bool = false

var _username : String
#var _local_player_path : NodePath

func _ready():
	_root = $/root/World/Network
	_peer = ENetMultiplayerPeer.new()
	
	_server_info = $/root/World/ServerInfo
	
	_map = load("res://Maps/test.tscn")

@rpc("authority", "call_local")
func _share_player_id(id):
	set_multiplayer_authority(id)

func _player_connect(id = 1):
	_share_player_id.rpc_id(id, id)

func host(username, port):
	_username = username
	
	_peer.create_server(port)
	multiplayer.multiplayer_peer = _peer
	multiplayer.peer_connected.connect(_player_connect)
	
	var map = _map.instantiate()
	_root.add_child(map)
	
	_player_connect()
	_server_info.host = _username
	_server_info.discover_player.rpc_id(1, _username)
	_is_connected = true
	
	_server_info.set_countdown(30.0)

func join_server(username, ip, port):
	_username = username
	
	_peer.create_client(ip, port)
	multiplayer.multiplayer_peer = _peer
	multiplayer.connected_to_server.connect(when_connect)
	multiplayer.server_disconnected.connect(when_disconnected)
	
	await  multiplayer.connected_to_server
	
	_server_info.discover_player.rpc_id(1, _username)

func when_connect():
	_is_connected = true
	
func when_disconnected():
	_is_connected = false
