extends Node


func _input(event):
	if event.is_action_pressed("debug_quit"):
		get_tree().quit()
