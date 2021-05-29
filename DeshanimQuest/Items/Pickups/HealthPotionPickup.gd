extends Area2D


func interact():
	PlayerInventory.inventory.add_item("Health Potion", 1)
	queue_free()
