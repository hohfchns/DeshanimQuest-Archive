extends Node2D

export(int) var heal_amt = 2

var slot_index = 0

var __player_stats = PlayerStats
var __inventory = PlayerInventory.inventory as Inventory

func use(action):
	if action != "main":
		return
	
	if __player_stats.get_health() < __player_stats.get_max_health():
		__player_stats.add_health(heal_amt)
		__inventory.remove_item_amt(slot_index, 1)
