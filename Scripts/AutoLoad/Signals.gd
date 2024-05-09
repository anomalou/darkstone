extends Node

signal interact
signal intent_change

func change_intent(intent):
	intent_change.emit(intent)
