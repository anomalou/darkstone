extends Window
class_name BodyStatus

var body_tree : Tree

func _ready():
	body_tree = $Tree
	hide()

func _on_close_requested():
	body_tree.clear()
	hide()
	
func show_info(body):
	if body_tree.visible:
		body_tree.clear()
	build_body_info(body)
	show()

func build_body_info(body):
	var root = body_tree.create_item()
	body_tree.hide_root = true
	
	var blood_info = body_tree.create_item(root)
	var damage_info = body_tree.create_item(root)
	var parts_info = body_tree.create_item(root)
	var reagents_info = body_tree.create_item(root)
	blood_info.set_text(0, "Blood")
	damage_info.set_text(0, "Damage")
	parts_info.set_text(0, "Base condition")
	reagents_info.set_text(0, "Reagents")
	
	build_blood_info(blood_info, body)
	build_damage_info(damage_info, body)
	
	var parts = body.cached_parts.values().duplicate()
	for part in parts:
		build_part_info(parts_info, body, part)
	
	var reagents = body.reagents.duplicate()
	for reagent in reagents:
		build_reagent_info(reagents_info, reagents, reagent)

func build_blood_info(root, body):
	build_damage_item(root, "Blood level", body.blood_level, Color.DARK_RED)
	build_damage_item(root, "Blood group", body.blood_group, Color.DARK_RED)

func build_damage_info(root, body):
	build_damage_item(root, "Brute", body.get_brute_damage(), Color.RED)
	build_damage_item(root, "Burn", body.get_burn_damage(), Color.ORANGE)
	build_damage_item(root, "Toxin", body.toxin_damage, Color.WEB_GREEN)
	build_damage_item(root, "Suffocation", body.suff_damage, Color.DEEP_SKY_BLUE)

func build_damage_item(root, lable : String, value, color : Color):
	if value is float:
		value = str(value).pad_decimals(2)
	
	var item = body_tree.create_item(root)
	item.set_text(0, lable)
	item.set_text(1, value)
	item.set_custom_color(0, color)
	item.set_custom_color(1, color)

func build_part_info(root, body, part):
	var part_item : TreeItem = body_tree.create_item(root)
	part_item.set_text(0, RaceData.get_race_body_part_name(body.race, part.name))
	part_item.set_text(1, str(part.health * 100).pad_decimals(2) + "%")
	
	if part.brute_damage != 0.0:
		build_damage_item(part_item, "Brute", part.brute_damage, Color.RED)
	
	if part.burn_damage != 0.0:
		build_damage_item(part_item, "Burn", part.burn_damage, Color.ORANGE)
	

func build_reagent_info(root, reagents, reagent):
	var reagent_info : TreeItem = body_tree.create_item(root)
	reagent_info.set_text(0, ReagentData.get_reagent_name(reagent))
	reagent_info.set_text(1, str(reagents[reagent]).pad_decimals(2) + "u")
