extends Node

enum Direction {
	NORTH,
	WEST,
	EAST,
	SOUTH
}

# Utils
@onready var server_info : NodePath = "/root/World/ServerInfo"
@onready var sheduler : NodePath = "/root/World/Sheduler"

# Function components
@onready var network : NodePath = "/root/World/GUI/Render/Viewport/LitView/Network"
@onready var camera : NodePath = "/root/World/GUI/Render/Viewport/LitView/Camera"
@onready var mask : NodePath = "/root/World/MaskView"
@onready var fov : NodePath = "/root/World/MaskView/FOV"
@onready var music_player : NodePath = "/root/World/MusicPlayer"

# GUI
@onready var debug : NodePath = "/root/World/GUI/Debug"
@onready var game : NodePath = "/root/World/GUI/Game"
@onready var main_menu : NodePath = "/root/World/GUI/MainMenu"
@onready var lobby : NodePath = "/root/World/GUI/Lobby"
@onready var saylog : NodePath = "/root/World/GUI/Saylog"
@onready var pick_up_list : NodePath = "/root/World/GUI/PickUpList"

# Resources
var slot_sprites : String = "res://Sprites/Slot/"
