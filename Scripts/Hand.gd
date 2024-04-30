extends TextureRect

@export var is_left_hand : bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func _on_gui_input(event : InputEvent):
	if event.is_action_pressed("left_click"):
		print(is_left_hand)
	pass # Replace with function body.


func _on_draw():
	pass # Replace with function body.
