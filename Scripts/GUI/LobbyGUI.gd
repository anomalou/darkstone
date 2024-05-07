extends Control

@export var time : Label
@export var host : Label
@export var players_online : Label
@export var players_ready : Label

var _server_info : Node

func _ready():
	_server_info = $/root/World/ServerInfo

func _on_start_pressed():
	if Multiplayer._local_player_id == 1:
		Multiplayer.start_game()
	else:
		Saylog.add("You are not host")

func _on_ready_pressed():
	var id = Multiplayer._local_player_id
	var is_ready = _server_info.is_ready(id)
	
	var result : String
	if is_ready:
		_server_info.not_ready.rpc(id)
		result = "  is not ready"
	else:
		_server_info.get_ready.rpc(id)
		result = " is ready now"
	
	Saylog.add.rpc(Multiplayer._username + result)
