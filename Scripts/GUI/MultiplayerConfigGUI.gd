extends Window

var _config_container : Tree

var _world : Node2D

var username_item : TreeItem
var ip_item : TreeItem
var port_item : TreeItem

func _ready():
	_config_container = get_node("./VContainer/Configs")
	_world = get_node("/root/World")
	build_confiuration()

func _on_close_requested():
	hide()

func build_confiuration():
	var root = _config_container.create_item()
	_config_container.set_column_title(0, "Property")
	_config_container.set_column_title(1, "Value")
	
	username_item = build_property(root, "Username", "lisko")
	ip_item = build_property(root, "IP", "127.0.0.1")
	port_item = build_property(root, "Port", "2415")

func build_property(root, property, init_value):
	var item = _config_container.create_item(root)
	item.set_text(0, property)
	item.set_text(1, init_value)
	item.set_editable(1, true)
	
	return item

func _on_host_button_pressed():
	var username = username_item.get_text(1)
	var port = port_item.get_text(1).to_int()
	Multiplayer.host(username, port)
	GameState.toggle_lobby_gui(true)
	hide()

func _on_connect_button_pressed():
	var username = username_item.get_text(1)
	var ip = ip_item.get_text(1)
	var port = port_item.get_text(1).to_int()
	Multiplayer.join_server(username, ip, port)
	GameState.toggle_lobby_gui(true)
	hide()
