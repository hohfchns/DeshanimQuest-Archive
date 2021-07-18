extends Panel

export(NodePath) onready var __slot_grid = get_node(__slot_grid) as GridContainer

export(NodePath) onready var save_toggle_button = get_node(save_toggle_button) as Button
export(NodePath) onready var __load_toggle_button = get_node(__load_toggle_button) as Button

export(NodePath) onready var __current_mode_label = get_node(__current_mode_label) as Label

export(NodePath) onready var close_button = get_node(close_button) as Button

export(NodePath) onready var __prev_button = get_node(__prev_button) as Button
export(NodePath) onready var __next_button = get_node(__next_button) as Button

export(NodePath) onready var __page_number = get_node(__page_number) as Label

export(NodePath) onready var __dialogs_parent = get_node(__dialogs_parent) as Control
export(NodePath) onready var __overwrite_confirm_dialog = get_node(__overwrite_confirm_dialog) as Panel
export(NodePath) onready var __overwrite_cancel_button = get_node(__overwrite_cancel_button) as Button
export(NodePath) onready var __overwrite_confirm_button = get_node(__overwrite_confirm_button) as Button
export(NodePath) onready var __load_confirm_dialog = get_node(__load_confirm_dialog) as Panel
export(NodePath) onready var __load_cancel_button = get_node(__load_cancel_button) as Button
export(NodePath) onready var __load_confirm_button = get_node(__load_confirm_button) as Button


var __save_load_slot_scene = preload("res://SaveLoad/UI/SaveLoadSlot.tscn")

var __ranger_icon = preload("res://Player/Portraits/RANGERPortrait.png")
var __empty_icon = preload("res://Player/Portraits/EmptyPortrait.png")

onready var __slots_per_page = __slot_grid.get_child_count()

var __current_page_idx = 0

var __sd = SlotsData

var cur_s_or_l = SaveLoadSlot.SAVE


func _ready():
	__connect_signals()
	
	__load_page(0)


func __connect_signals():
	SlotsData.connect("slot_data_changed", self, "__update_slot")
	
	save_toggle_button.connect("pressed", self, "toggle_save")
	__load_toggle_button.connect("pressed", self, "toggle_load")
	
	close_button.connect("pressed", self, "_on_close_button_pressed")
	
	__prev_button.connect("pressed", self, "_on_prev_button_pressed")
	__next_button.connect("pressed", self, "_on_next_button_pressed")
	
	__overwrite_cancel_button.connect("pressed", self, "_on_overwrite_cancel_pressed")
	__overwrite_confirm_button.connect("pressed", self, "_on_overwrite_confirm_pressed")
	__load_cancel_button.connect("pressed", self, "_on_load_cancel_pressed")
	__load_confirm_button.connect("pressed", self, "_on_load_confirm_pressed")


func start():
	self.visible = true
	get_tree().paused = true
	
	close_button.visible = true
	save_toggle_button.visible = true
	
	GameManager.menus_ll.push_front(self)

func stop():
	self.visible = false
	get_tree().paused = false
	
	GameManager.menus_ll.pop_front()
	if GameManager.menus_ll.get_forward_list():
		GameManager.menus_ll.tail.data.start()


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
		
		__slot_grid.get_child(slot_idx).save_or_load = cur_s_or_l
		
		__slot_grid.get_child(slot_idx).connect("slot_pressed", self, "_on_slot_pressed")
		
		__sd.fill_slots_data(slot_idx)
		
		__update_slot(slot_idx)
	
	__page_number.text = str(page_idx + 1)
	
	__current_page_idx = page_idx


func __attempt_save(slot_idx):
	if not SlotsData.get_slots_data().size() < slot_idx \
	and SlotsData.get_slots_data()[slot_idx] != null \
	and not DebugVars.quick_debug:
		__dialogs_parent.show()
		__overwrite_confirm_dialog.show()
		__dialogs_parent.slot_idx = slot_idx
	else:
		SaveLoad.save_to_slot(slot_idx)

func __attempt_load(slot_idx):
	if not __sd.get_slots_data()[slot_idx]:
		return
	
	__dialogs_parent.show()
	__load_confirm_dialog.show()
	__dialogs_parent.slot_idx = slot_idx


func _on_slot_pressed(save_or_load, slot_idx):
	if save_or_load == SaveLoadSlot.SAVE:
		__attempt_save(slot_idx)
	elif save_or_load == SaveLoadSlot.LOAD:
		__attempt_load(slot_idx)


func _on_overwrite_cancel_pressed():
	__dialogs_parent.hide()
	__overwrite_confirm_dialog.hide()

func _on_overwrite_confirm_pressed():
	__dialogs_parent.hide()
	__overwrite_confirm_dialog.hide()
	
	get_tree().paused = false
	
	SaveLoad.save_to_slot(__dialogs_parent.slot_idx)

func _on_load_cancel_pressed():
	__dialogs_parent.hide()
	__load_confirm_dialog.hide()

func _on_load_confirm_pressed():
	__dialogs_parent.hide()
	__load_confirm_dialog.hide()
	
	stop()
	
	SaveLoad.load_from_slot(__dialogs_parent.slot_idx)


func _on_next_button_pressed():
	__load_page(__current_page_idx + 1)

func _on_prev_button_pressed():
	if __current_page_idx > 0:
		__load_page(__current_page_idx - 1)


func toggle_save():
	for slot in __slot_grid.get_children():
		slot.save_or_load = SaveLoadSlot.SAVE
	
	cur_s_or_l = SaveLoadSlot.SAVE
	
	__current_mode_label.text = "Current Mode: Save"

func toggle_load():
	for slot in __slot_grid.get_children():
		slot.save_or_load = SaveLoadSlot.LOAD
	
	cur_s_or_l = SaveLoadSlot.LOAD
	
	__current_mode_label.text = "Current Mode: Load"


func _on_close_button_pressed():
	stop()


func _input(event):
	if event.is_action_pressed("toggle_saveload_ui"):
		if self.visible:
			stop()
		elif not self.visible and not GameManager.menus_ll.get_forward_list():
			start()
