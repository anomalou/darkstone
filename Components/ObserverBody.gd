extends CharacterBody2D

func _enter_tree():
	set_multiplayer_authority(name.split("_")[0].to_int())
