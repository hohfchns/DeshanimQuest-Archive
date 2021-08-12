extends HBoxContainer

var __selected_slot_index = 0 setget set_selected_slot

var __inventory = PlayerInventory.inventory as Inventory

var __empty_hand_item = preload("res://Items/Items/EmptyHand/EmptyHand.tscn")


signal selected_item_changed(item_instance, slot_index)


func _ready():
	__inventory.connect("inventory_changed", self, "_on_inventory_changed")
	
	set_selected_slot(GameManager.last_hotbar_slot)
	
	call_deferred("update_visuals")
	call_deferred("update_selected_slot")


func update_visuals():
	for i in range(get_children().size()):
		var slot = get_node("Slot%s" % (i + 1)) as HotbarSlot
		
		var items = __inventory.get_items() as Array
		
		if items.size() <= i:
			return
		
		if items[i]:
			slot.item_icon.texture = items[i].item_reference.icon
			var quantity = items[i].quantity
			slot.quantity_text.text =  str(quantity) if quantity > 1 else ""
		else:
			slot.item_icon.texture = null
			slot.quantity_text.text = ""
		
		update_selected_slot()

func update_selected_slot():
	for i in range(get_children().size()):
		var slot = get_node("Slot%s" % (i + 1)) as HotbarSlot
		
		if __selected_slot_index == i:
			slot.highlight.visible = true
		else:
			slot.highlight.visible = false
	
#	var selected_slot = get_node("Slot%s" % (__selected_slot_index + 1))
	
	if __inventory.get_items().size() <= __selected_slot_index \
	or not __inventory.get_items()[__selected_slot_index]:
		emit_signal("selected_item_changed", __empty_hand_item.instance(), __selected_slot_index)
		return
	
	var item_path = __inventory.get_items()[__selected_slot_index].item_reference.node_path
	var item_to_set_active = item_path.instance()
	
	emit_signal("selected_item_changed", item_to_set_active, __selected_slot_index)


func set_selected_slot(index):
	__selected_slot_index = index
	update_selected_slot()
	GameManager.last_hotbar_slot = index


func __scroll_down():
	if __selected_slot_index == 8:
		set_selected_slot(0)
	else:
		set_selected_slot(__selected_slot_index + 1)

func __scroll_up():
	if __selected_slot_index == 0:
		set_selected_slot(8)
	else:
		set_selected_slot(__selected_slot_index - 1)


func _on_inventory_changed(inventory):
	update_visuals()


func _input(event):
	if event.is_action_pressed("swap_item_down"):
		__scroll_down()
	elif event.is_action_pressed("swap_item_up"):
		__scroll_up()
