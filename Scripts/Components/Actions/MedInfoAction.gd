extends Action
class_name MedInfoAction

@export var body : Body
@onready var med_info_gui : MedInfoGUI = GUIManager.game_overlay.med_info

func do(data = null):
	med_info_gui.show_info(body)
