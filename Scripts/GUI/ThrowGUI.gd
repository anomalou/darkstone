extends Control
class_name ThrowGUI

func _on_texture_button_toggled(toggled_on):
	var player : Player = Multiplayer.get_player()
	
	if not player:
		push_error("Somehow player not found")
	
	player.throw_mode = toggled_on
