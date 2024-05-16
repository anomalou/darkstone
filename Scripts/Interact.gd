extends Node2D
class_name Interact

@onready var player : Player = Multiplayer.get_player()
@onready var area : Area2D = $Area
var nodes : Array

func pick_up():
	pass

func discovery():
	nodes = area.get_overlapping_bodies()
	print(nodes)
	queue_free()
