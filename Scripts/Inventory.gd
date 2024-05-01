extends Node

var left_hand : String
var right_hand : String

func set_left_hand(id):
	if id == "":
		return false
	if left_hand != "":
		return false
	left_hand = id
	return true
	
func set_right_hand(id):
	if id == "":
		return false
	if right_hand != "":
		return false
	right_hand = id
	return true
	

