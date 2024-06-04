extends Node

func option(obj, callback : Callable, else_callback : Callable = func(): return false):
	if obj:
		return callback.call(obj)
	else:
		return else_callback.call()

func move_item(from : SlotComponent, to : SlotComponent):
	var item : Item = option(from, func(f): return f.get_item())
	if item:
		if option(to, func(t): return t.set_slot(item.get_path())):
			from.remove_item()
			return item
	return false
