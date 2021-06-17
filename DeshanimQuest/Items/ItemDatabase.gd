extends Node

var items = Array()

func _ready():
	var dir_contents = __get_dir_contents("res://Items/Resources")
	
	for file_path in dir_contents[0]:
		items.append(load(file_path))

func __get_dir_contents(rootPath: String) -> Array:
	var files = []
	var directories = []
	var dir = Directory.new()

	if dir.open(rootPath) == OK:
		dir.list_dir_begin(true, false)
		__add_dir_contents(dir, files, directories)
	else:
		push_error("An error occurred when trying to access the path.")

	return [files, directories]

func __add_dir_contents(dir: Directory, files: Array, directories: Array):
	var file_name = dir.get_next()

	while (file_name != ""):
		var path = dir.get_current_dir() + "/" + file_name

		if dir.current_is_dir():
			var subDir = Directory.new()
			subDir.open(path)
			subDir.list_dir_begin(true, false)
			directories.append(path)
			__add_dir_contents(subDir, files, directories)
		else:
			files.append(path)

		file_name = dir.get_next()

	dir.list_dir_end()


func get_item(item_name):
	for item in items:
		if item.item_name == item_name:
			return item
	
	return null
