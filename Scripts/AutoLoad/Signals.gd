extends Node

signal show_body_info
signal interact
signal intent_change
signal host
signal join

var multiplayer_id : int = 1

func show_medinfo(body):
	show_body_info.emit(body)

func interact_with(body):
	interact.emit(multiplayer_id, body)

func change_intent(intent):
	intent_change.emit(intent)

func host_game(port):
	host.emit(port)

func join_game(ip, port):
	join.emit(ip, port)
