extends GridContainer

var __inventory = PlayerInventory.inventory as Inventory


func can_drop_data(position, data):
	return data is Dictionary and data.has("item")

func drop_data(position, data):
	__inventory.set_item(data.item_index, data.item)
