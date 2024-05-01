extends Node

signal log_update

var log : Array = []
var log_limit = 50

func add(text):
	log.append(text)
	
	var erase_first : bool = false
	if len(log) > log_limit:
		log.pop_front()
		erase_first = true
	
	emit_signal("log_update", erase_first)
