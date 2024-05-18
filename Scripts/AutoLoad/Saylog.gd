extends Node

signal log_update

var saylog : Array = []
var log_limit = 50

@rpc("any_peer", "call_local")
func add(text):
	saylog.append(text)
	
	var erase_first : bool = false
	if len(saylog) > log_limit:
		saylog.pop_front()
		erase_first = true
	
	emit_signal("log_update", erase_first)
