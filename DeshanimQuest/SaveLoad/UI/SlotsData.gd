extends Node

var __slots_data = []

signal slot_data_changed(index)


func _ready():
	SaveLoad.connect("slot_changed", self, "_on_SaveLoad_slot_changed")
	
	__check_for_existing_saves()


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


func fill_slots_data(up_to_idx):
	while __slots_data.size() <= up_to_idx:
		__slots_data.append(null)
		emit_signal("slot_data_changed", __slots_data.size() - 1)


func list_files_in_directory(path):
	var files = []
	var dir = Directory.new()
	
	if not dir.dir_exists(path):
		return []
	
	dir.open(path)
	dir.list_dir_begin()
	
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			files.append(file)
	
	dir.list_dir_end()
	
	return files

func __check_for_existing_saves():
	var saves_path = "user://Saves"
	var save_names = list_files_in_directory(saves_path)
	
	if save_names:
		print("Found save files: %s" % str(save_names))
	else:
		print("Found no save files")
	
	for save_name in save_names:
		var path = "%s/%s/%s.json" % [saves_path, save_name, save_name]
		var save = SaveLoad.load_data_from_file(path)
		var slot_index = save["slot_index"]
		fill_slots_data(slot_index)
		set_slot_data(slot_index, save)


func _on_SaveLoad_slot_changed(data, slot_idx):
	fill_slots_data(slot_idx)
	
	call_deferred("set_slot_data", slot_idx, data)
