extends Node2D

@export var maps_path : String = "res://Maps/"

@export var player : PackedScene
@export var player_ghost : PackedScene

var players : Dictionary = {}

var map : Node2D
var ground : Node2D
var network : Node2D

var game_control : Control
var menu : Control

var peer = ENetMultiplayerPeer.new()
var player_sync : MultiplayerSynchronizer

# Called when the node enters the scene tree for the first time.
func _ready():
	map = get_node("/root/World/Map")
	ground = get_node("/root/World/Ground")
	network = get_node("/root/World/Network")
	game_control = get_node("/root/World/GUI/GameControl")
	menu = get_node("/root/World/GUI/ConfigurationMenu")
	
	player_sync = get_node("/root/World/PlayerSynchronizer")
	
	Signals.host.connect(host)
	Signals.join.connect(join)
	
	#toggle_player(false)
	toggle_menu(true)

func _add_observer(id = 1): # 1 - server
	var player = player.instantiate()
	player.name = str(id)
	network.add_child(player)
	
	players[id] = player.get_path()

	rpc_id(id, "prepare_player", id)

@rpc("authority", "call_remote")
func prepare_player(id):
	Signals.multiplayer_id = id

@rpc("any_peer", "call_local")
func settle_player(id, body_path):
	var player = get_node(players[id])
	var body = get_node(body_path)
	player.body = body

func host(port):
	peer.create_server(port)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(_add_observer)
	_add_observer()

func join(ip, port):
	peer.create_client(ip, port)
	multiplayer.multiplayer_peer = peer

func load_map(map_name):
	var map_scene : PackedScene = load(maps_path + map_name + ".tscn")
	var map = map_scene.instantiate()
	self.map.add_child(map)


#func toggle_player(value):
	#if value:
		#player.show()
	#else:
		#player.hide()
	#
	#player.set_process(value)
	#player.set_physics_process(value)
	#player.set_process_input(value)

func toggle_game(value):
	if value:
		game_control.show()
		menu.hide()
	else:
		game_control.hide()

func toggle_menu(value):
	if value:
		menu.show()
		game_control.hide()
	else:
		menu.hide()

func start_test():
	#toggle_player(true)
	toggle_game(true)
	load_map("test")
