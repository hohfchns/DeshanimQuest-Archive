extends Control

onready var __inventory = PlayerInventory.inventory as Inventory

export(NodePath) onready var __hotbar = get_node(__hotbar) as HBoxContainer
export(NodePath) onready var __items_grid = get_node(__items_grid) as GridContainer

var slot_refs = []


func _ready():
	PlayerInventory.inventory.connect("inventory_changed", self, "_on_inventory_changed")
	
	__set_slot_indexes()
	
	_on_inventory_changed(__inventory)


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
		self.visible = not self.visible
		get_tree().paused = not get_tree().paused
