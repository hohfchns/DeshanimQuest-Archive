extends TextureRect

onready var __inventory = PlayerInventory.inventory as Inventory

var slot_index: int


func get_drag_data(position):
	var item_index = slot_index
	var item = __inventory.remove_item(item_index)
	
	if item && item.has("item_reference"):
		var data = {}
		data.item = item
		data.item_index = item_index
		
		var drag_preview = TextureRect.new()
		drag_preview.texture = item.item_reference.icon
		set_drag_preview(drag_preview)
		
		return data

func can_drop_data(position, data):
	return data is Dictionary and data.has("item")

func drop_data(position, data):
	var my_item_index = slot_index
	var my_item = __inventory.get_item(my_item_index)
	
	__inventory.swap_items(my_item_index, data.item_index)
	__inventory.set_item(my_item_index, data.item)
