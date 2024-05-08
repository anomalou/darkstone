extends Control

@export var time : Label
@export var host : Label
@export var players_online : Label
@export var players_ready : Label
@export var ready_status : Label

@export var ready_outline : LabelSettings
@export var not_ready_outline : LabelSettings

var _server_info : ServerInfo

func _ready():
	_server_info = $/root/World/ServerInfo

func _on_start_pressed():
	if Multiplayer.get_multiplayer_authority() == 1:
		_server_info.start_game.rpc_id(1)
	else:
		Saylog.add("You are not host")

func _on_ready_pressed():
	if _server_info.is_game_started:
		Saylog.add("Game already started")
		return
	
	var id = Multiplayer.get_multiplayer_authority()
	var is_ready = _server_info.is_ready(id)
	
	var result : String
	if is_ready:
		_server_info.not_ready.rpc()
		result = "  is not ready"
	else:
		_server_info.get_ready.rpc()
		result = " is ready now"
	
	Saylog.add.rpc(Multiplayer._username + result)

func _process(delta):
	time.text = str(_server_info.time_left)
	host.text = _server_info.host
	players_online.text = str(_server_info.online_players.size())
	players_ready.text = str(_server_info.ready_players.size())
	
	if _server_info.ready_players.has(Multiplayer.get_multiplayer_authority()):
		ready_status.label_settings = ready_outline
		ready_status.text = "READY"
	else:
		ready_status.label_settings = not_ready_outline
		ready_status.text = "NOT READY"
