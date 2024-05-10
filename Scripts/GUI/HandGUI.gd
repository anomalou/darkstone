extends Node
class_name Hands

var left : TextureRect
var right : TextureRect

var left_slot : SlotComponent
var right_slot : SlotComponent

var server_info : ServerInfo

func _ready():
	left = $Left/Texture
	right = $Right/Texture
	
	server_info = $/root/World/ServerInfo

func _process(_delta):
	if not server_info.is_game_started:
		return
		
	var player : Player = Multiplayer.get_player()
	var body : Body = player.get_body()
	
	if not body:
		return
	
	left_slot = body.get_slot(Body.BodyPartTag.LEFT_ARM)
	right_slot = body.get_slot(Body.BodyPartTag.RIGHT_ARM)
	
	if left_slot:
		if left_slot.get_slot():
			left.texture = load("res://Sprites/Slot/" + left_slot.get_slot() + ".tres")
	if right_slot:
		if right_slot.get_slot():
			right.texture = load("res://Sprites/Slot/" + right_slot.get_slot() + ".tres")

func _on_gui_input(event : InputEvent):
	pass # Replace with function body.
