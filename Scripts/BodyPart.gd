extends Sprite2D

var race : String = "human" # later update to make another race

var health : float = 1.0

var size : int
var organs : Dictionary
var is_covered : bool = false
var slot : String = ""

var texture_name : String

func _ready():
	texture = load_texture()

func inject(organ):
	organs[organ.name] = organ
	# shrink free space
	
func load_texture():
	return load("res://Sprites/Body/" + race + "/" + name + ".tres")
