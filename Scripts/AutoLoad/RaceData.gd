extends Node

var races : Array
var blood_groups : Array = ["0", "A", "B", "AB"]

var race_data : Dictionary
var body_scene : PackedScene
var organ_scene : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	var race_file = FileAccess.open("res://Resources/Races.json", FileAccess.READ)
	race_data = JSON.parse_string(race_file.get_as_text())
	
	races = race_data.keys()
	
	body_scene = load("res://Components/Body/Parts/body_part.tscn")
	organ_scene = load("res://Components/Body/Parts/organ.tscn")

func get_race(race):
	if race_data.has(race):
		return race_data[race]
		
func create_body_part():
	return body_scene.instantiate()
	
func create_organ():
	return organ_scene.instantiate()

func get_race_body_part_texture(race_id, part_id):
	var race = get_race(race_id)
	if race:
		return race[part_id]["texture"]

func get_race_body_part_size(race_id, part_id):
	var race = get_race(race_id)
	if race:
		return race[part_id]["size"]

func get_race_body_part_allowed_organs(race_id, part_id):
	var race = get_race(race_id)
	if race:
		return race[part_id]["allowed_organs"]

func get_race_body_part_organs(race_id, part_id):
	var race = get_race(race_id)
	if race:
		var part = race[part_id]
		if part.has("organs"):
			return part["organs"]

func get_race_body_part_name(race_id, part_id):
	var race = get_race(race_id)
	if race:
		return race[part_id]["name"]
