extends Node

var host : String
var online_players : Dictionary # id : Username
var ready_players : Dictionary # id : path

@rpc("any_peer", "call_local")
func connect_player(id, username):
	online_players[id] = username

func is_ready(id):
	return ready_players.has(id)

@rpc("any_peer", "call_local")
func get_ready(id):
	if online_players.has(id):
		ready_players[id] = ""

@rpc("any_peer", "call_local")
func update_path(id, path):
	if ready_players.has(id):
		ready_players[id] = path

@rpc("any_peer", "call_local")
func not_ready(id):
	if ready_players.has(id):
		ready_players.erase(id)
