extends Resource
class_name ItemResource

export(String, FILE) var node_path

export(String) var item_name

export(bool) var stackable
export(int) var max_stack_size

enum ItemType { GENERIC, CONSUMABLE, QUEST, WEAPON, EQUIPMENT }
export(ItemType) var type

export(Texture) var icon
