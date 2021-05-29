extends Node2D

var __sword = preload("res://Items/Items/Weapons/Melee/Sword/Sword.tscn")
var __glock = preload("res://Items/Items/Weapons/Guns/Glock/Glock.tscn")

var __items_arr: Array = [__sword, __glock]
var __cur_item_index: int = 0

var __player_ref = null

func _ready():
	__player_ref = GameManager.get_player()

func _input(event):
	if not event is InputEventMouseButton:
		return
	
	if event.is_action_pressed("swap_item_down"):
		var next_item_index
		if __cur_item_index == __items_arr.size() - 1:
			next_item_index = 0
		else:
			next_item_index = __cur_item_index + 1
		
		var next_item = __items_arr[next_item_index].instance()
		
		__player_ref.set_current_item(next_item)
		
		__cur_item_index = next_item_index
		
	elif event.is_action_pressed("swap_item_up"):
		var next_item_index
		if __cur_item_index == 0:
			next_item_index = __items_arr.size() - 1
		else:
			next_item_index = __cur_item_index -1
		
		var next_item = __items_arr[next_item_index].instance()
		
		__player_ref.set_current_item(next_item)
		
		__cur_item_index = next_item_index
