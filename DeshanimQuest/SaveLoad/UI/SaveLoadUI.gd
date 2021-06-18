extends Panel

export(NodePath) onready var __slot_grid = get_node(__slot_grid) as GridContainer

export(NodePath) onready var __save_toggle_button = get_node(__save_toggle_button) as Button
export(NodePath) onready var __load_toggle_button = get_node(__load_toggle_button) as Button

export(NodePath) onready var __current_mode_label = get_node(__current_mode_label) as Label

export(NodePath) onready var __close_button = get_node(__close_button) as Button

export(NodePath) onready var __prev_button = get_node(__prev_button) as Button
export(NodePath) onready var __next_button = get_node(__next_button) as Button

export(NodePath) onready var __page_number = get_node(__page_number) as Label

var __save_load_slot_scene = preload("res://SaveLoad/UI/SaveLoadSlot.tscn")

var __ranger_icon = preload("res://Player/Portraits/RANGERPortrait.png")
var __empty_icon = preload("res://Player/Portraits/EmptyPortrait.png")

onready var __slots_per_page = __slot_grid.get_child_count()

var __current_page_idx = 0

var __sd = SlotsData


func _ready():
	__connect_signals()
	
	__load_page(0)


func __connect_signals():
	SlotsData.connect("slot_data_changed", self, "__update_slot")
	
	__save_toggle_button.connect("pressed", self, "_on_save_toggle_pressed")
	__load_toggle_button.connect("pressed", self, "_on_load_toggle_pressed")
	
	__close_button.connect("pressed", self, "_on_close_button_pressed")
	
	__prev_button.connect("pressed", self, "_on_prev_button_pressed")
	__next_button.connect("pressed", self, "_on_next_button_pressed")


func __update_slot(slot_idx):
	var slots_data = __sd.get_slots_data()
	var slot = __slot_grid.get_child(slot_idx)
	var slot_data = SlotsData.get_slots_data()[slot_idx]
	
	if not slots_data or not slots_data[slot_idx]:
		slot.icon_rect.texture = null
		slot.level_label.text = ""
		slot.icon_rect.texture = __empty_icon
		return
	
	slot.slot_name.text = "Slot %s" % (slot_idx + 1)
	slot.level_label.text = slot_data["scene"]["scene_name"]
	slot.icon_rect.texture = __ranger_icon


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
		
		__slot_grid.get_child(slot_idx).slot_idx = slot_idx
		
		__sd.fill_slots_data(slot_idx)
		
		__update_slot(slot_idx)
	
	__page_number.text = str(page_idx + 1)
	
	__current_page_idx = page_idx


func __hide_ui():
	self.visible = false


func _on_next_button_pressed():
	__load_page(__current_page_idx + 1)

func _on_prev_button_pressed():
	if __current_page_idx > 0:
		__load_page(__current_page_idx - 1)


func _on_save_toggle_pressed():
	for slot in __slot_grid.get_children():
		slot.save_or_load = slot.SAVE
	
	__current_mode_label.text = "Current Mode: Save"

func _on_load_toggle_pressed():
	for slot in __slot_grid.get_children():
		slot.save_or_load = slot.LOAD
	
	__current_mode_label.text = "Current Mode: Load"


func _on_close_button_pressed():
	__hide_ui()


func _input(event):
	if event.is_action_pressed("toggle_saveload_ui"):
		self.visible = not self.visible
