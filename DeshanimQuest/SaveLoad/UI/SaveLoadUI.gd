extends TabContainer

export(NodePath) onready var __slot_grid = get_node(__slot_grid) as GridContainer

export(NodePath) onready var __save_close_button = get_node(__save_close_button) as Button
#export(NodePath) onready var __load_close_button = get_node(__load_close_button) as Button

export(NodePath) onready var __prev_button = get_node(__prev_button) as Button
export(NodePath) onready var __next_button = get_node(__next_button) as Button

var __save_load_slot_scene = preload("res://SaveLoad/UI/SaveLoadSlot.tscn")

onready var __slots_per_page = __slot_grid.get_child_count()

var __current_page_idx = 0

#var __sd = SlotsData
var slots_data = []


func _ready():
	__connect_signals()


func __connect_signals():
	__save_close_button.connect("pressed", self, "__on_close_button_pressed")
#	__load_close_button.connect("pressed", self, "__on_close_button_pressed")
	
	__prev_button.connect("pressed", self, "__on_prev_button_pressed")
	__next_button.connect("pressed", self, "__on_next_button_pressed")


func __update_slot(slot_idx):
	if not slots_data or not slots_data[slot_idx]:
		__slot_grid.get_child(slot_idx).screenshot_rect.texture = null
		return
	
	var screenshot = load("user://Saves/save%s/save%s.png" % [slot_idx, slot_idx])
	__slot_grid.get_child(slot_idx).screenshot_rect.texture = screenshot


func __load_page(page_idx):
	for slot in __slot_grid.get_children():
		slot.visible = false
	
	var page_start = page_idx * __slots_per_page + 1
	var page_end = (page_idx * __slots_per_page) + __slots_per_page
	for slot_idx in range(page_start - 1, page_end):
		if __slot_grid.get_child_count() < page_start:
			for i in range(__slots_per_page):
				__slot_grid.add_child(__save_load_slot_scene.instance())
		
		__slot_grid.get_child(slot_idx).visible = true
		
		__update_slot(slot_idx)
	
	__current_page_idx = page_idx


func __on_next_button_pressed():
	__load_page(__current_page_idx + 1)

func __on_prev_button_pressed():
	if __current_page_idx > 0:
		__load_page(__current_page_idx - 1)


func __on_close_button_pressed():
	self.visible = false
