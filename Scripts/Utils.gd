extends Node

func option(obj, callback : Callable, else_callback : Callable = func(): return false):
	if obj:
		return callback.call(obj)
	else:
		return else_callback.call()

func move_item(from : SlotComponent, to : SlotComponent):
	var item : Item = option(from, func(f): return f.get_item())
	if item:
		option(to, func(t): t.set_slot.rpc(item.get_path()))
		if item.get_parent() == to:
			from.remove_item.rpc()
			return item
	return false
