extends Node

var __slots_data = []

signal slot_data_changed(index)
signal slots_data_set


func set_slot_data(index, data):
	__slots_data[index] = data
	
	emit_signal("slot_data_changed", index)

func get_slots_data():
	return __slots_data


func set_all_slots_data(data):
	__slots_data = data
	
	emit_signal("slots_data_set")


func add_slot_data(data):
	__slots_data.append(data)
	
	emit_signal("slot_data_changed", __slots_data.size() - 1)
