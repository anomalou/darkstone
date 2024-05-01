extends Node

var content : Dictionary

func _ready():
	var data = FileAccess.open("res://Resources/ItemData.json", FileAccess.READ)
	content = JSON.parse_string(data.get_as_text())
	data.close()
	
func get_item_name(id):
	if id == null:
		return
	return content[id]["name"]
	
func get_decription(id):
	if id == null:
		return
	return content[id]["decription"]
	
func get_pickup_message(id):
	if id == null:
		return
	return content[id]["pickup_message"]
	
func get_ground_texture_name(id):
	if id == null:
		return
	return content[id]["ground_texture"]

func get_slot_texture_name(id):
	if id == null:
		return
	return content[id]["slot_texture"]
