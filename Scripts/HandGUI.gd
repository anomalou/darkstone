extends TextureRect

@export var is_left_hand : bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var id : String
	if is_left_hand:
		id = Inventory.left_hand
	else:
		id = Inventory.right_hand
	
	if id != "":
		var texture_name = ItemData.get_slot_texture_name(id)
		texture = load("res://Sprites/Slot/" + texture_name + ".tres")
	
	
func _on_gui_input(event : InputEvent):
	if event.is_action_pressed("left_click"):
		print(is_left_hand)
	pass # Replace with function body.
