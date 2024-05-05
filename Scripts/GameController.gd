extends Node2D

@export var maps_path : String = "res://Maps/"

@export var player : PackedScene
@export var ghost : PackedScene

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
	var player_obj = player.instantiate()
	var ghost_obj = ghost.instantiate()
	player_obj.name = str(id)
	ghost_obj.name = str(id) + "_ghost"
	network.add_child(player_obj)
	network.add_child(ghost_obj)
	
	print(Signals.multiplayer_id)
	
	#player_obj.body = ghost_obj.get_path()
	
	players[id] = player_obj.get_path()

	rpc("prepare_player", id, player_obj.get_path(), ghost_obj.get_path())

@rpc("authority", "call_local")
func prepare_player(id, player_path, ghost_path):
	Signals.multiplayer_id = id
	var player_obj = get_node(player_path)
	player_obj.body = ghost_path

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
