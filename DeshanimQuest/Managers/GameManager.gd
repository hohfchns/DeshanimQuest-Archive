extends Node

var __player_ref = null

var is_mouse_on_button = false

var menus_ll: LinkedList = LinkedList.new()


func _ready():
	SaveLoad.connect("save_loaded", self, "_on_save_loaded")

# Should be called by the player when it enters the scene
func generate_player_ref():
	__player_ref = get_node("/root/SceneRoot/YSort/%sPlayer" % PlayerStats.current_class_name)

func get_player(caller_identity: String):
	if __player_ref:
		return __player_ref
	else:
		print("%s tried to get player, but a player was not found, it is likely not in scene." % caller_identity)


func _on_save_loaded(save_data, slot_index):
	var itr = menus_ll.tail
	while itr:
		itr.data.stop()
		itr = itr.prev
