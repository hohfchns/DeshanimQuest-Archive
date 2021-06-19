extends Node

signal slot_changed(new_data, slot_index)
signal save_loaded(data, slot_index)


func _ready():
	connect("save_loaded", self, "_on_save_loaded")


func __save_to_file(path: String, data: Dictionary):
	var file = File.new()
	
	file.open(path, file.WRITE)
	
	file.store_line(to_json(data))
	
	file.close()

func load_from_file(path):
	var file = File.new()
	
	if not file.file_exists(path):
		print("Tried to load but path is invalid. Returning null.")
		return null
	
	file.open(path, file.READ)
	
	var text = file.get_as_text()
	
	var data = parse_json(text)
	
	file.close()
	
	return data


func __get_item_dicts():
	var inventory_items = PlayerInventory.inventory.get_items()
	var item_dicts: Array = []
	for item in inventory_items:
		if item == null:
			item_dicts.append(null)
			continue
		
		var item_dict = {
			item_name = item.item_reference.item_name,
			quantity = item.quantity
		}
		
		item_dicts.append(item_dict)
	
	return item_dicts

func generate_cur_save_data() -> Dictionary:
	var save_data: Dictionary = {}
	
	save_data["scene"] = {}
	save_data["scene"]["scene_name"] = get_tree().get_current_scene().scene_name
	save_data["scene"]["scene_path"] = get_tree().get_current_scene().filename
	
	save_data["player"] = {}
	save_data["player"]["max_health"] = PlayerStats.get_max_health()
	save_data["player"]["health"] = PlayerStats.get_health()
	save_data["player"]["inventory_items"] = __get_item_dicts()
	
	return save_data


func _on_save_loaded(save_data, slot_index):
	if "scene" in save_data and "scene_path" in save_data["scene"]:
		get_tree().change_scene_to(load(save_data["scene"]["scene_path"]))
		
		var scene_name = save_data["scene"]["scene_name"]
		print("Loaded scene \"%s\" from slot %s" % [scene_name, slot_index])


func save_to_slot(slot_index: int):
	var dir_path = "user://Saves/save%s" % slot_index
	var path = "%s/save%s.json" % [dir_path, slot_index]
	
	var dir = Directory.new()
	
	if not dir.dir_exists(dir_path):
		dir.make_dir_recursive(dir_path)
	
	var save_data: Dictionary = generate_cur_save_data()
	save_data["slot_index"] = slot_index
	
	__save_to_file(path, save_data)
	
	print("Saved to slot %s" % slot_index)
	
	emit_signal("slot_changed", save_data, slot_index)

func load_from_slot(slot_index: int):
	var path = "user://Saves/save%s/save%s.json" % [slot_index, slot_index]
	
	var save_data = load_from_file(path)
	
	if not save_data:
		print("Save data not found at slot %s, not loading" % slot_index)
		return
	
	print("Loaded from slot %s" % slot_index)
	
	emit_signal("save_loaded", save_data, slot_index)
