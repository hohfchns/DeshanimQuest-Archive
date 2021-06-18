extends Node

var inventory_resource = preload("res://Inventory/Inventory.gd")
var inventory = inventory_resource.new() as Inventory


func _ready():
	SaveLoad.connect("save_loaded", self, "_on_save_loaded")


func _on_save_loaded(save_data, slot_idx):
	if "player" in save_data and "inventory_items" in save_data["player"]:
		inventory.set_items(save_data["player"]["inventory_items"])
