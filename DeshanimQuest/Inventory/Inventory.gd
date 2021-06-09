extends Resource
class_name Inventory

signal inventory_changed

export var __items = Array() setget set_items, get_items


func __fill_items(index):
	while (get_items().size() - 1) < index:
		__items.append(null)


func set_items(new_items):
	var previous_items = __items
	
	__items = new_items
	
	emit_signal("inventory_changed", self)
	
	return previous_items

func get_items():
	return __items

func set_item(index, item):
	var previous_item = get_items()[index]
	
	__fill_items(index)
	
	__items[index] = item
	
	emit_signal("inventory_changed", self)
	
	return previous_item

func get_item(index):
	__fill_items(index)
	
	return get_items()[index]

func remove_item(index):
	if index > get_items().size() - 1 or index < 0:
		return null
	
	var previous_item = get_items()[index]
	
	__items[index] = null
	
	emit_signal("inventory_changed", self)
	
	return previous_item

func remove_item_amt(index, amount):
	__items[index].quantity -= amount
	
	if __items[index].quantity <= 0:
		remove_item(index)
		return
	
	emit_signal("inventory_changed", self)

func swap_items(item_index, target_item_index):
#	while (get_items().size() - 1) < item_index:
#		__items.append(null)
#	while (get_items().size() - 1) < target_item_index:
#		__items.append(null)
	
	var target_item = get_items()[target_item_index]
	var item = get_items()[item_index]
	
	__items[target_item_index] = item
	__items[item_index] = target_item


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
			
			if not inventory_item:
				var new_item = {
				item_reference = item,
				quantity = min(remaining_quantity, max_stack_size)
				}
				set_item(i, new_item)
				remaining_quantity -= quantity
				continue
			
			if inventory_item.item_reference.item_name != item.item_name:
				continue
			
			if inventory_item.quantity < max_stack_size:
				var original_quantity = inventory_item.quantity
				inventory_item.quantity = min(original_quantity + remaining_quantity, max_stack_size)
				remaining_quantity -= inventory_item.quantity - original_quantity
	
	while remaining_quantity > 0:
		for i in get_items().size():
			var inventory_item = get_items()[i]
			
			if not inventory_item:
				var new_item = {
				item_reference = item,
				quantity = min(remaining_quantity, max_stack_size)
				}
				
				set_item(i, new_item)
				
				remaining_quantity -= new_item.quantity
				
				emit_signal("inventory_changed", self)
				
				return
		
		var new_item = {
			item_reference = item,
			quantity = min(remaining_quantity, max_stack_size)
		}
		__items.append(new_item)
		remaining_quantity -= new_item.quantity
	
	emit_signal("inventory_changed", self)

