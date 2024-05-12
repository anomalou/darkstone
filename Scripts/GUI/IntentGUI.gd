extends TabBar

func _ready():
	current_tab = 0

func _on_tab_clicked(tab):
	Signals.intent_change.emit(tab)

func _input(event):
	if event.is_action_pressed("help_intent"):
		current_tab = 0
	if event.is_action_pressed("hurt_intent"):
		current_tab = 1
	if event.is_action_pressed("resist_intent"):
		current_tab = 2
	if event.is_action_pressed("grab_intent"):
		current_tab = 3
	Signals.intent_change.emit(current_tab)
