extends Node

var races : Array
var blood_groups : Array = ["0", "A", "B", "AB"]

var race_data : Dictionary

# Called when the node enters the scene tree for the first time.
func _ready():
	var race_file = FileAccess.open("res://Resources/Races.json", FileAccess.READ)
	race_data = JSON.parse_string(race_file.get_as_text())
	
	races = race_data.keys()

func get_race(race):
	if race_data.has(race):
		return race_data[race]

func get_part(race, part_id):
	if race.has(part_id):
		return race[part_id]

func get_race_body_min_temperature(race_id):
	var race = get_race(race_id)
	if race:
		return race["min_temperature"]

func get_race_body_max_temperature(race_id):
	var race = get_race(race_id)
	if race:
		return race["max_temperature"]

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

func get_race_body_part_has_bone(race_id, part_id):
	var race = get_race(race_id)
	if race:
		var part = get_part(race, part_id)
		if part.has("has_bone"):
			return part["has_bone"]
