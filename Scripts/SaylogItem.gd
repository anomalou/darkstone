extends Object
class_name SaylogItem

var title : String
var text : String

func set_title(_title):
	if not _title:
		return
	title = _title

func get_title():
	if not title:
		return "SERVER"
	return title

func set_text(_text):
	if not _text:
		return
	text = _text

func get_text():
	if not text:
		return "..."
	return text
