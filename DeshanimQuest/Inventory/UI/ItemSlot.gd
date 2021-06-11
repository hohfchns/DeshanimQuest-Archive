extends TextureRect

onready var __inventory = PlayerInventory.inventory as Inventory

var slot_index: int

export(NodePath) onready var item_icon = get_node(item_icon) as TextureRect
export(NodePath) onready var quantity_text = get_node(quantity_text) as RichTextLabel

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
	var target_item = __inventory.get_item(my_item_index)
	var dragged_item = data.item
	
	# If target slot is empty just swap the items
	if \
	not target_item \
	or dragged_item.item_reference.item_name != target_item.item_reference.item_name \
	or dragged_item.item_reference.stackable == false \
	or target_item.item_reference.stackable == false:
		__inventory.swap_items(my_item_index, data.item_index)
		__inventory.set_item(my_item_index, data.item)
		
		return
	
	var dragged_item_quantity = data.item.quantity
	var my_quantity = target_item.quantity
	var max_stack_size = target_item.item_reference.max_stack_size
	
	var remaining_quantity = dragged_item_quantity
	
	if target_item.quantity < max_stack_size:
		var original_quantity = target_item.quantity
		target_item.quantity = min(original_quantity + remaining_quantity, max_stack_size)
		
		remaining_quantity -= target_item.quantity - original_quantity
	
	var new_dragged_item = {
		item_reference = data.item.item_reference,
		quantity = remaining_quantity
	}
	
	if remaining_quantity:
		__inventory.set_item(data.item_index, new_dragged_item)
