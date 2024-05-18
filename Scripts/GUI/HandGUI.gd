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
	
	left_slot = body.get_slot(PartsComponent.Part.LEFT_ARM)
	right_slot = body.get_slot(PartsComponent.Part.RIGHT_ARM)
	
	if left_slot:
		if left_slot.get_slot():
			left.texture = load(Constants.slot_sprites + left_slot.get_slot() + ".tres")
	if right_slot:
		if right_slot.get_slot():
			right.texture = load(Constants.slot_sprites + right_slot.get_slot() + ".tres")

func _on_gui_input(event : InputEvent):
	pass # Replace with function body.
