extends Control
class_name Inventory

@onready var equipment = $Equipment
@onready var button : TextureButton = $ButtonFrame/Button

func _ready():
	equipment.hide()

func _on_button_toggled(toggled_on):
	if toggled_on:
		equipment.show()
	else:
		equipment.hide()


func _on_equipment_close_requested():
	button.set_pressed(false)
	equipment.hide()
