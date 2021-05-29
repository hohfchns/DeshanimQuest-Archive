extends Control

onready var __inventory = PlayerInventory.inventory as Inventory


func _ready():
	PlayerInventory.inventory.connect("inventory_changed", self, "_on_inventory_changed")
	_on_inventory_changed()


func _on_inventory_changed():
	print("test")
	for i in __inventory.get_items().size():
		var item_slot = find_node("ItemSlot%s" % i)
		print(item_slot)
