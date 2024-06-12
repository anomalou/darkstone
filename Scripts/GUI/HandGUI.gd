extends Node
class_name Hands

@onready var left : TextureRect = $Left/Texture
@onready var right : TextureRect = $Right/Texture

@onready var left_animation : AnimationPlayer = $Left/Frame/Animation
@onready var right_animation : AnimationPlayer = $Right/Frame/Animation

@onready var server_info : ServerInfo = get_node(Constants.server_info)

var left_hand : Hand
var right_hand : Hand

func _process(_delta):
	if not server_info.is_game_started:
		return
		
	var body = get_body()
	
	if not body:
		return
	
	left_hand = body.get_hand(PartsComponent.Tag.LEFT_ARM)
	right_hand = body.get_hand(PartsComponent.Tag.RIGHT_ARM)
	
	var left_item : Item = Utils.option(left_hand, func(l): return l.get_hand_item(), func(): return null)
	var right_item : Item = Utils.option(right_hand, func(r): return r.get_hand_item(), func(): return null)
	
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


func _on_left_gui_input(event : InputEvent):
	if event.is_action_pressed("primary"):
		var body : Body = get_body()
		
		if not body:
			return
		
		var selected_hand = body.get_selected_hand()
		
		left_hand = body.get_hand(PartsComponent.Tag.LEFT_ARM)
		right_hand = body.get_hand(PartsComponent.Tag.RIGHT_ARM)
		
		if selected_hand == PartsComponent.Tag.LEFT_ARM:
			if not left_hand:
				return
			print_debug("Do primary action in item")
			return
		
		# two hand interaction (need both)
		
		if not left_hand or not right_hand:
			return
		
		# else variant vvv
		
		var left_item = left_hand.get_hand_item()
		var right_item = right_hand.get_hand_item()
		
		var left_slot : SlotComponent = left_hand.get_hand_slot()
		var right_slot : SlotComponent = right_hand.get_hand_slot()
		
		if right_item and not left_item:
			Utils.move_item(right_slot, left_slot)
		elif not right_item and left_item:
			print_debug("Do secondary action on item")

func _on_right_gui_input(event : InputEvent):
	if event.is_action_pressed("primary"):
		var body : Body = get_body()
		
		if not body:
			return
		
		var selected_hand = body.get_selected_hand()
		
		left_hand = body.get_hand(PartsComponent.Tag.LEFT_ARM)
		right_hand = body.get_hand(PartsComponent.Tag.RIGHT_ARM)
		
		if selected_hand == PartsComponent.Tag.RIGHT_ARM:
			if not right_hand:
				return
			print_debug("Do primary action in item")
			return
		
		# two hand interaction (need both)
		
		if not left_hand or not right_hand:
			return
		
		# else variant vvv
		
		var left_item = left_hand.get_hand_item()
		var right_item = right_hand.get_hand_item()
		
		var left_slot : SlotComponent = left_hand.get_hand_slot()
		var right_slot : SlotComponent = right_hand.get_hand_slot()
		
		if left_item and not right_item:
			Utils.move_item(left_slot, right_slot)
		elif not left_item and right_item:
			print_debug("Do secondary action on item")

func get_body():
	var player : Player = Multiplayer.get_player()
	var body : Body = player.get_body()
	
	return body
