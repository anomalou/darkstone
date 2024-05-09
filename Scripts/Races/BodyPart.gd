extends Sprite2D
class_name BodyPart

var race : String = "human" # later update to make another race

var brute_damage : float
var burn_damage : float

var health : float = 1.0
var has_bone : bool = false
var is_bone_broken : bool = false

var size : int
var is_covered : bool = false
var slot

var tags : Array = ["body_part"]

var texture_name : String
var cached_organs : Dictionary

func _ready():
	texture = load_texture()
	
func load_texture():
	return load("res://Sprites/Body/" + race + "/" + name + ".tres")

# check this out later. Added only couse bug with Dictionary convert to EncodedObjectAsID dictionary
func decode(encoded_organ):
	if encoded_organ is EncodedObjectAsID:
		return instance_from_id(encoded_organ.object_id)
	else:
		return encoded_organ

func inject(organ : Node2D):
	if "organ" in organ.tags:
		add_child(organ)
		cached_organs[organ.name] = organ

func eject(organ : String):
	var obj = cached_organs[organ]
	cached_organs.erase(organ)
	remove_child(obj)
		
func is_organ_alive(organ : String):
	if not cached_organs.has(organ):
		return false
	var obj = decode(cached_organs[organ])
	if obj.health <= 0.0:
		return false
	return true

func get_organ_status(organ : String):
	if cached_organs.has(organ):
		var obj = decode(cached_organs[organ])
		return obj.health

func is_organ_alive_by_tag(tag : String):
	var temp = cached_organs.values().duplicate()
	for organ in temp:
		var obj = decode(organ)
		if tag in obj.tags:
			if obj.health <= 0.0:
				return false
			return true
	return false

func get_organ_status_by_tag(tag : String):
	var temp = cached_organs.values().duplicate()
	for organ in temp:
		var obj = decode(organ)
		if tag in obj.tags:
			return obj.health

func do_brute_damage(value : float):
	brute_damage += value

func do_burn_damage(value : float):
	burn_damage += value

func get_slot():
	if slot == null:
		return "" # temporary when i make new items
	else:
		return slot

func set_slot(value):
	slot = value
