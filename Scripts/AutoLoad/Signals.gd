extends Node

signal show_body_info
signal interact
signal intent_change

func show_medinfo(body):
	show_body_info.emit(body)

func interact_with(body):
	interact.emit(body)

func change_intent(intent):
	intent_change.emit(intent)
