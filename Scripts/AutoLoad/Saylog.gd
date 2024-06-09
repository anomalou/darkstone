extends Node

signal log_update

var saylog : Array[SaylogItem] = []
var log_limit = 50

@rpc("any_peer", "call_local")
func add(text, title = null):
	var item = SaylogItem.new()
	item.set_text(text)
	item.set_title(title)
	
	saylog.append(item)
	
	var erase_first : bool = false
	if len(saylog) > log_limit:
		saylog.pop_front()
		erase_first = true
	
	emit_signal("log_update", erase_first)

func back() -> SaylogItem:
	return saylog.back()
