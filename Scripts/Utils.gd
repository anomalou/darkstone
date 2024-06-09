extends Node

func option(obj, callback : Callable, else_callback : Callable = func(): return false):
	if obj:
		return callback.call(obj)
	else:
		return else_callback.call()

func move_item(from : SlotComponent, to : SlotComponent):
	var item = from.get_item_path()
	if to.get_item_path():
		return false
	
	from.remove_item.rpc()
	to.set_slot.rpc(item)
	
	return item
