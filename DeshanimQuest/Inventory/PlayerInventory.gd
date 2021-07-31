extends Node

var inventory_resource = preload("res://Inventory/Inventory.gd")
var inventory = inventory_resource.new() as Inventory


func _ready():
	SaveLoad.connect("save_loaded", self, "_on_save_loaded")


func _on_save_loaded(save_data, slot_idx):
	if "player" in save_data and "inventory_items" in save_data["player"]:
		var saved_items = save_data["player"]["inventory_items"]
		var items: Array
		
		if not saved_items:
			inventory.set_items([])
			print("Loaded empty array as inventory from save %s" % (slot_idx+1))
			return
		
		for saved_item in saved_items:
			if saved_item == null:
				items.append(null)
				continue
			
			var item_name = saved_item.item_name
			
			var inventory_item = {
				item_reference = ItemDatabase.get_item(item_name),
				quantity = saved_item.quantity
			}
			
			items.append(inventory_item)
		
		inventory.set_items(items)
		print("Loaded items from save %s" % (slot_idx+1))
