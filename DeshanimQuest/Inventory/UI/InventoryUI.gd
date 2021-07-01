extends Control

onready var __inventory = PlayerInventory.inventory as Inventory

export(NodePath) onready var __hotbar = get_node(__hotbar) as HBoxContainer
export(NodePath) onready var __items_grid = get_node(__items_grid) as GridContainer

var slot_refs = []


func _ready():
	PlayerInventory.inventory.connect("inventory_changed", self, "_on_inventory_changed")
	
	__set_slot_indexes()
	
	_on_inventory_changed(__inventory)


func start():
	self.visible = true
	get_tree().paused = true
	
	GameManager.menus_ll.push_front(self)

func stop():
	self.visible = false
	get_tree().paused = false
	
	GameManager.menus_ll.pop_front()


func __set_slot_indexes():
	for slot in __hotbar.get_children():
		slot_refs.append(slot)
	for slot in __items_grid.get_children():
		slot_refs.append(slot)
	
	for i in range(slot_refs.size()):
		slot_refs[i].slot_index = i


func _on_inventory_changed(inventory):
	for i in range(__inventory.get_items().size()):
		var item_slot = find_node("ItemSlot%s" % (i + 1))
		
		if __inventory.get_item(i):
			item_slot.item_icon.texture = __inventory.get_item(i).item_reference.icon
			if __inventory.get_item(i).quantity > 1:
				item_slot.quantity_text.bbcode_text = "[right]%s[/right]" % str(__inventory.get_item(i).quantity)
			else:
				item_slot.quantity_text.bbcode_text = ""
		else:
			item_slot.item_icon.texture = null
			item_slot.quantity_text.bbcode_text = ""


func can_drop_data(position, data):
	return data is Dictionary and data.has("item")

func drop_data(position, data):
	# Instances the item pickup at the player's position
	
	var pickup = data.item.item_reference.pickup_path.instance()
	var player = get_parent().get_parent() as Player
	
	pickup.amount = data.item.quantity
	pickup.global_position = player.global_position
	
	player.get_parent().add_child(pickup)



func _input(event):
	if event.is_action_pressed("toggle_inventory"):
		if self.visible:
			stop()
		elif not self.visible and not GameManager.menus_ll.size:
			start()
	
	if event.is_action_pressed("ui_cancel"):
		if self.visible:
			stop()
