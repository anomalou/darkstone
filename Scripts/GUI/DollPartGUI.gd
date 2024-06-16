extends Control
class_name DollPartGUI

@export var selection_sprite : Texture2D
@export var body_tag : PartsComponent.Tag

@onready var selection : TextureRect = $"../Selection"

func _on_gui_input(event : InputEvent):
	if event.is_action_pressed("primary"):
		selection.texture = selection_sprite
		var player : Player = Multiplayer.get_player()
		
		if not player:
			printerr("Player not found! Something goes wrong, couse game for this player started ", Multiplayer.get_multiplayer_authority())
			return
		
		player.set_doll_selection(body_tag)
