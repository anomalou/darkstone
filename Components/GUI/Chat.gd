extends LineEdit

func _input(event):
	if event.is_action_pressed("say"):
		grab_focus()
	if event.is_action_pressed("send"):
		release_focus()
		Saylog.add.rpc(text)
		clear()
