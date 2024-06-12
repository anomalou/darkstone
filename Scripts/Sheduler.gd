extends Node
class_name Sheduler

@export var wait_time : float = 0.1

var in_progress : bool = false
var delay : int = 0
var current_time : int = 0

@onready var timer : Timer = $Timer

func start_action(time : int, callback : Callable):
	if time <= 0:
		callback.call_deferred()
		return
	
	break_action()
	
	delay = time
	current_time = 0
	
	in_progress = true
	
	timer.start(wait_time)
	
	while current_time <= delay:
		await timer.timeout
		
		if timer.is_stopped():
			if current_time <= delay:
				return
		
		current_time += 1
	
	timer.stop()
	
	in_progress = false
	
	callback.call_deferred()

func break_action():
	if in_progress:
		timer.stop()
		timer.timeout.emit()
		in_progress = false
