extends "res://Scripts/Races/Body.gd"

func process_injures(tick_coef):
	if not get_part("upper_body").is_organ_alive_by_tag("heart"):
		suff_damage += tick_coef * 10
	if not get_part("upper_body").is_organ_alive_by_tag("lungs"):
		suff_damage += tick_coef * 10
