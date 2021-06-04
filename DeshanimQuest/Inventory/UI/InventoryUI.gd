extends Control

onready var __inventory = PlayerInventory.inventory as Inventory


func _ready():
	PlayerInventory.inventory.connect("inventory_changed", self, "_on_inventory_changed")
	_on_inventory_changed(__inventory)


func _on_inventory_changed(inventory):
	for i in range(__inventory.get_items().size()):
		var item_slot = find_node("ItemSlot%s" % (i + 1))
		
		if __inventory.get_item(i):
			item_slot.get_node("ItemIcon").texture = __inventory.get_item(i).item_reference.icon
		else:
			item_slot.get_node("ItemIcon").texture = null


func _input(event):
	if event.is_action_pressed("toggle_inventory"):
		self.visible = not self.visible
