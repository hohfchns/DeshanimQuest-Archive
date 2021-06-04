extends TextureRect

onready var __inventory = PlayerInventory.inventory as Inventory





func _ready():
	pass


func get_drag_data(position):
	var item_index = int(self.name[len(self.name) - 1]) - 1
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
	pass
