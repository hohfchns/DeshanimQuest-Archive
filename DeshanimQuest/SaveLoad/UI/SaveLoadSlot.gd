extends Panel

export(NodePath) onready var screenshot_rect = get_node(screenshot_rect) as TextureRect

var slot_idx = 0

enum { SAVE, LOAD }

var save_or_load = SAVE

var __sd = SlotsData


func save_slot():
	SaveLoad.save_to_slot(slot_idx)

func load_slot():
	SaveLoad.load_from_slot(slot_idx)


func _gui_input(event):
	if event is InputEventMouseButton and event.is_pressed():
		if save_or_load == SAVE:
			save_slot()
		elif save_or_load == LOAD:
			load_slot()
