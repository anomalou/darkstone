extends Node
class_name Hands

@onready var left : TextureRect = $Left/Texture
@onready var right : TextureRect = $Right/Texture

@onready var left_animation : AnimationPlayer = $Left/Frame/Animation
@onready var right_animation : AnimationPlayer = $Right/Frame/Animation

@onready var server_info : ServerInfo = get_node(Constants.server_info)

var left_slot : SlotComponent
var right_slot : SlotComponent

func _process(_delta):
	if not server_info.is_game_started:
		return
		
	var player : Player = Multiplayer.get_player()
	var body : Body = player.get_body()
	
	if not body:
		return
	
	left_slot = body.get_slot(PartsComponent.Tag.LEFT_ARM)
	right_slot = body.get_slot(PartsComponent.Tag.RIGHT_ARM)
	
	var left_item : Item = left_slot.get_item()
	var right_item : Item = right_slot.get_item()
	
	if left_item:
		left.texture = left_item.get_sprite()
	else:
		left.texture = null
	
	if right_item:
		right.texture = right_item.get_sprite()
	else:
		right.texture = null
	
	var selected_hand = body.get_selected_hand()
	
	if selected_hand == PartsComponent.Tag.LEFT_ARM:
		if not left_animation.is_playing():
			left_animation.play()
		right_animation.stop()
	if selected_hand == PartsComponent.Tag.RIGHT_ARM:
		if not right_animation.is_playing():
			right_animation.play()
		left_animation.stop()


func _on_left_gui_input(event):
	pass # Replace with function body.


func _on_right_gui_input(event):
	pass # Replace with function body.
