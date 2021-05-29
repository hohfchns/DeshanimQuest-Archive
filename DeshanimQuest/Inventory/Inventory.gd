extends Resource
class_name Inventory

signal inventory_changed

export var __items = Array() setget set_items, get_items


func set_items(new_items):
	__items = new_items
	emit_signal("inventory_changed", self)

func get_items():
	return __items


func get_item(index):
	return get_items()[index]

func add_item(item_name, quantity):
	if quantity <= 0:
		print("Can't add 0 or less items!")
		return
	
	var item = ItemDatabase.get_item(item_name)
	
	if not item:
		print("Could not find item")
		return
	
	var remaining_quantity = quantity
	var max_stack_size = item.max_stack_size if item.stackable else 1
	
	if item.stackable:
		for i in range(get_items().size()):
			if remaining_quantity == 0:
				break
			
			var inventory_item = get_items()[i]
			
			if inventory_item.item_reference.item_name != item.item_name:
				continue
			
			if inventory_item.quantity < max_stack_size:
				var original_quantity = inventory_item.quantity
				inventory_item.quantity = min(original_quantity + remaining_quantity, max_stack_size)
				remaining_quantity -= inventory_item.quantity - original_quantity
	
	while remaining_quantity > 0:
		var new_item = {
			item_reference = item,
			quantity = min(remaining_quantity, max_stack_size)
		}
		__items.append(new_item)
		remaining_quantity -= new_item.quantity
	
	emit_signal("inventory_changed", self)
