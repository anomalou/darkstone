extends Node

var reagents : Dictionary

# Called when the node enters the scene tree for the first time.
func _ready():
	var file = FileAccess.open("res://Resources/Reagents.json", FileAccess.READ)
	reagents = JSON.parse_string(file.get_as_text())
	

func get_reagent_name(id):
	if reagents.has(id):
		var reagent = reagents[id]
		return reagent["name"]
		
func get_description(id):
	if reagents.has(id):
		var reagent = reagents[id]
		return reagent["description"]
		
func get_absorbability(id):
	if reagents.has(id):
		var reagent = reagents[id]
		return reagent["absorbability"]
		
func get_tags(id):
	if reagents.has(id):
		var reagent = reagents[id]
		return reagent["tags"]
