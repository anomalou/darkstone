extends VBoxContainer

@export var log_line : PackedScene


# Called when the node enters the scene tree for the first time.
func _ready():
	Saylog.log_update.connect(update_log)

func update_log(erase_first):
	if get_child_count() > 0:
		if erase_first:
			var first_child = get_child(0)
			remove_child(first_child)
	
	var instance : Label = log_line.instantiate()
	instance.text = Saylog.saylog.back()
	
	add_child(instance)
