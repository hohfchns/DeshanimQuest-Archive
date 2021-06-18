extends Panel

export(NodePath) onready var icon_rect = get_node(icon_rect) as TextureRect
export(NodePath) onready var slot_name = get_node(slot_name) as Label
export(NodePath) onready var level_label = get_node(level_label) as Label

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
