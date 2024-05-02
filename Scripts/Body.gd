extends Node

@export var race : String

var race_data : Dictionary
var body_part_scene : PackedScene
var organ_scene : PackedScene

func _ready():
	var race_file = FileAccess.open("res://Resources/RaceData.json", FileAccess.READ)
	race_data = JSON.parse_string(race_file.get_as_text())
	
	body_part_scene = load("res://Components/Body/body_part.tscn")
	organ_scene = load("res://Components/Body/organ.tscn")
	
	if race != null:
		build_body()
	pass

func build_body():
	var body_parts : Dictionary = race_data[race]
	
	var upper_body = create_body_part(body_parts, "upper_body")
	var groin = create_body_part(body_parts, "groin")
	var head = create_body_part(body_parts, "head")
	var left_arm = create_body_part(body_parts, "left_arm")
	var right_arm = create_body_part(body_parts, "right_arm")
	var left_leg = create_body_part(body_parts, "left_leg")
	var right_leg = create_body_part(body_parts, "right_leg")
	
	groin.add_child(left_leg)
	groin.add_child(right_leg)
	
	upper_body.add_child(head)
	upper_body.add_child(groin)
	upper_body.add_child(left_arm)
	upper_body.add_child(right_arm)
	
	add_child(upper_body)

func create_body_part(parts : Dictionary, part_name : String):
	var obj = body_part_scene.instantiate()
	var data : Dictionary = parts[part_name]
	obj.name = part_name
	obj.texture_name = data["texture"]
	obj.size = data["size"]
	if data.has("organs"):
		for organ in create_organs(data["organs"]):
			obj.inject(organ)
	
	return obj

func create_organs(organs : Array):
	var pack : Array = []
	
	for organ in organs:
		var organ_obj = organ_scene.instantiate()
		organ_obj.name = organ["name"]
		pack.append(organ_obj)
		
	return pack
		

	
