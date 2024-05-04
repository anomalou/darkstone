extends Node

signal show_body_info

func show_medinfo(body):
	show_body_info.emit(body)
