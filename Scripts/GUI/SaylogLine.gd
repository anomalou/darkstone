extends Control
class_name SaylogLine

@onready var sayer_name : Label = $Name
@onready var text : Label = $Text

func _process(_delta):
	pivot_offset.y = size.y

func set_text(_sayer, _text):
	Utils.option(_sayer, func(s): sayer_name.text = _sayer)
	Utils.option(_text, func(t): text.text = _text)
