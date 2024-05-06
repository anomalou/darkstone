extends Node

# Player resources
var _player_scene : PackedScene

# Map resources
var _map : PackedScene

# Network
var _root : Node2D
var _peer : ENetMultiplayerPeer

# Connected player data
var _local_player : int # Multiplayer ID of local player
var _local_player_path : NodePath
var _player_list : Dictionary # (id:NodePath) ONLY FOR HOST

func _ready():
	_root = $/root/World/Network
	_peer = ENetMultiplayerPeer.new()
	
	_player_scene = load("res://Components/player.tscn")
	_map = load("res://Maps/test.tscn")

@rpc("authority", "call_local")
func _register_player(id, path):
	_local_player = id
	_local_player_path = path

func _init_player(id = 1):
	var player = _player_scene.instantiate()
	player.name = str(id) + "_player"
	
	_root.add_child(player)
	_player_list[id] = player.get_path()
	
	_register_player.rpc_id(id, id, player.get_path())

func host(port):
	_peer.create_server(port)
	multiplayer.multiplayer_peer = _peer
	multiplayer.peer_connected.connect(_init_player)
	
	var map = _map.instantiate()
	_root.add_child(map)
	
	_init_player()

func join_server(ip, port):
	_peer.create_client(ip, port)
	multiplayer.multiplayer_peer = _peer
