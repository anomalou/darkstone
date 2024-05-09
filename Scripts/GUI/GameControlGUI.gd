extends Control
class_name GameControl

var hands : Hands
var body_status : BodyStatus
var intents : Control

func _ready():
	hands = $Hands
	body_status = $BodyStatus
	intents = $Intents


