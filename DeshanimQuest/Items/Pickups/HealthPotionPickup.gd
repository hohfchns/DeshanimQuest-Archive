extends Area2D

export(NodePath) onready var __amount_text = get_node(__amount_text) as Label

export(int) var amount = 1

func _ready():
	__amount_text.text = str(amount) if amount > 1 else "" 

func interact():
	PlayerInventory.inventory.add_item("Health Potion", amount)
	queue_free()
