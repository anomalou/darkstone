extends LineEdit

func _input(event):
	if event.is_action_pressed("say"):
		grab_focus()
	if event.is_action_pressed("send"):
		release_focus()
		if Multiplayer.is_connected:
			text = Multiplayer._username + ": " + text
		Saylog.add.rpc(text)
		clear()
