extends Node
class_name Hands

var left : TextureRect
var right : TextureRect

var left_slot : String
var right_slot : String

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
	
	left_slot = body.get_slot("left_arm")
	right_slot = body.get_slot("right_arm")
	
	if left_slot:
		left.texture = load("res://Sprites/Slot/" + left_slot + ".tres")
	if right_slot:
		right.texture = load("res://Sprites/Slot/" + right_slot + ".tres")

func _on_gui_input(event : InputEvent):
	pass # Replace with function body.
