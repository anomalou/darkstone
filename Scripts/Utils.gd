extends Node

func option(obj, callback : Callable, else_callback : Callable = func(): return false):
	if obj:
		return callback.call(obj)
	else:
		return else_callback.call()
