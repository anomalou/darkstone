extends Control
class_name SaylogGUI

@export var log_line : PackedScene

@onready var chat : LineEdit = $VSplitContainer/Chat/VContainer/Chat
@onready var saylog : VBoxContainer = $VSplitContainer/Chat/VContainer/ScrollContainer/Messages
@onready var scroll_container : ScrollContainer = $VSplitContainer/Chat/VContainer/ScrollContainer
@onready var v_scrollbar : VScrollBar = $VSplitContainer/Chat/VContainer/ScrollContainer.get_v_scroll_bar()

var max_scroll_value  = 0
var auto_update_scroll = true

func _ready():
	Saylog.log_update.connect(update_log)
	v_scrollbar.changed.connect(handle_scrollbar_change)
	v_scrollbar.scrolling.connect(handle_auto_scroll)

func _input(event):
	if event.is_action_pressed("say"):
		grab_focus()
	if event.is_action_pressed("send"):
		release_focus()
		if Multiplayer.is_connected:
			chat.text = Multiplayer._username + ": " + chat.text
		Saylog.add.rpc(chat.text)
		chat.clear()

func update_log(erase_first):
	if saylog.get_child_count() > 0:
		if erase_first:
			var last = saylog.get_child(get_child_count() - 1)
			saylog.remove_child(last)
	
	var instance : Label = log_line.instantiate()
	instance.text = Saylog.saylog.back()
	
	saylog.add_child(instance)

func handle_scrollbar_change():
	if auto_update_scroll:
		if max_scroll_value != v_scrollbar.max_value:
			max_scroll_value = v_scrollbar.max_value
			scroll_container.scroll_vertical = max_scroll_value

func handle_auto_scroll():
	if (scroll_container.scroll_vertical + v_scrollbar.page) == v_scrollbar.max_value:
		auto_update_scroll = true
	else:
		auto_update_scroll = false
