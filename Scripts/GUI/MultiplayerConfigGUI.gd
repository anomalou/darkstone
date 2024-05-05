extends Window

var config_container : Tree

var player : Node2D

func _ready():
	config_container = get_node(NodePath("./VContainer/Configs"))
	player = get_node(NodePath("/root/World/Player"))
	build_confiuration()

func _on_close_requested():
	hide()

func build_confiuration():
	var root = config_container.create_item()
	config_container.set_column_title(0, "Property")
	config_container.set_column_title(1, "Value")
	
	build_property(root, "Username", "lisko")
	build_property(root, "IP", "127.0.0.1")
	build_property(root, "Port", "2415")

func build_property(root, property, init_value):
	var item = config_container.create_item(root)
	item.set_text(0, property)
	item.set_text(1, init_value)
	item.set_editable(1, true)
