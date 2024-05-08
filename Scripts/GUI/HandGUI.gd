extends TextureRect

@export var is_left_hand : bool = true

var player : Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	return
	
	var id : String
	if not player.is_ghost:
		if is_left_hand:
			var left_arm = player.body.get_part("left_arm")
			if left_arm != null:
				id = left_arm.get_slot()
		else:
			var right_arm = player.body.get_part("right_arm")
			if right_arm != null:
				id = right_arm.get_slot()
		
		if id != "":
			var texture_name = ItemData.get_slot_texture_name(id)
			texture = load("res://Sprites/Slot/" + texture_name + ".tres")
	
	
func _on_gui_input(event : InputEvent):
	if event.is_action_pressed("left_click"):
		print(is_left_hand)
	pass # Replace with function body.
