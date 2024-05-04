extends Sprite2D

var race : String = "human" # later update to make another race

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
	if cached_organs[organ].health <= 0.0:
		return false
	return true

func get_organ_status(organ : String):
	if cached_organs.has(organ):
		return cached_organs[organ].health

func is_organ_alive_by_tag(tag : String):
	for organ in cached_organs:
		if tag in cached_organs[organ].tags:
			if cached_organs[organ].health <= 0.0:
				return false
			return true
	return false

func get_organ_status_by_tag(tag : String):
	for organ in cached_organs:
		if tag in cached_organs[organ].tags:
			return cached_organs[organ].health

func get_slot():
	if slot == null:
		return "" # temporary when i make new items
	else:
		return slot
