extends TabContainer

export(NodePath) onready var __slot_grid = get_node(__slot_grid) as GridContainer

export(NodePath) onready var __save_close_button = get_node(__save_close_button) as Button
#export(NodePath) onready var __load_close_button = get_node(__load_close_button) as Button

export(NodePath) onready var __prev_button = get_node(__prev_button) as Button
export(NodePath) onready var __next_button = get_node(__next_button) as Button

var __save_load_slot = preload("res://SaveLoad/UI/SaveLoadSlot.tscn")

onready var __slots_per_page = __slot_grid.get_child_count()

var __current_page_idx = 0


func _ready():
	__connect_signals()


func __connect_signals():
	__save_close_button.connect("pressed", self, "__on_close_button_pressed")
#	__load_close_button.connect("pressed", self, "__on_close_button_pressed")
	
	__prev_button.connect("pressed", self, "__on_prev_button_pressed")
	__next_button.connect("pressed", self, "__on_next_button_pressed")


func __update_slot(slot_idx: int):
#	var slot = __slot_grid.find_node("SaveLoadSlot%s" % (slot_idx + 1))
	var slot = __slot_grid.get_child(slot_idx)
	var slots_data = SlotsData.get_slots_data()
	
	if not slots_data or not slots_data[slot_idx]:
		slot.screenshot_rect.texture = null
		return
	
	slot.screenshot_rect.texture = load("user://Saves/save%s.png" % slot_idx)


func __load_page(page_idx: int):
	for child in __slot_grid.get_children():
		child.free()
	
	while __slot_grid.get_child_count() < __slots_per_page:
		var slot = __save_load_slot.instance()
		slot.slot_idx = get_child_count() - 1
		__slot_grid.add_child(slot)
		
#		slot.name = "SaveLoadSlot%s" % get_child_count()
		
		__update_slot(get_child_count() - 1)
	
	var slots_data = SlotsData.get_slots_data()
	
	if slots_data.size() <= __current_page_idx * __slots_per_page:
		for i in range(__slots_per_page):
			SlotsData.add_slot_data(null)
	
	__current_page_idx = page_idx


func __on_next_button_pressed():
	__load_page(__current_page_idx + 1)

func __on_prev_button_pressed():
	if __current_page_idx > 0:
		__load_page(__current_page_idx - 1)


func __on_close_button_pressed():
	self.visible = false
