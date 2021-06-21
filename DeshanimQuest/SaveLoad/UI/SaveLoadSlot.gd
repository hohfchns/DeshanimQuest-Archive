extends Panel
class_name SaveLoadSlot

export(NodePath) onready var icon_rect = get_node(icon_rect) as TextureRect
export(NodePath) onready var slot_name = get_node(slot_name) as Label
export(NodePath) onready var level_label = get_node(level_label) as Label

signal slot_pressed(save_or_load, slot_idx)

var slot_idx = 0

enum { SAVE, LOAD }

var save_or_load = SAVE

var __sd = SlotsData


func _gui_input(event):
	if event is InputEventMouseButton and event.is_pressed():
		if save_or_load == SAVE:
			emit_signal("slot_pressed", SAVE, slot_idx)
		elif save_or_load == LOAD:
			emit_signal("slot_pressed", LOAD, slot_idx)
