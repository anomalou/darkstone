extends Control
class_name GameControl

var hands : Hands
var med_info : MedInfoGUI
var intents : Control

func _enter_tree():
	hands = $Hands
	med_info = $MedInfo
	intents = $Intents


