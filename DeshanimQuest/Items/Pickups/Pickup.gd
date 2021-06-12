extends Area2D

export(Vector2) var sprite_offset

export(NodePath) onready var __amount_text = get_node(__amount_text) as Label

export(String) var item_name
export(int) var amount = 1

func _ready():
	__amount_text.text = str(amount) if amount > 1 else "" 

func interact():
	PlayerInventory.inventory.add_item(item_name, amount)
	queue_free()
