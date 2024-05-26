extends Node
class_name Hands

@onready var left : TextureRect = $Left/Texture
@onready var right : TextureRect = $Right/Texture

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
		left.texture = null

func _on_gui_input(event : InputEvent):
	pass # Replace with function body.
