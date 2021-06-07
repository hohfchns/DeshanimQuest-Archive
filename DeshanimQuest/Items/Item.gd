extends Resource
class_name ItemResource

export(PackedScene) var node_path
export(PackedScene) var pickup_path

export(String) var item_name

export(bool) var stackable
export(int) var max_stack_size

enum ItemType { GENERIC, CONSUMABLE, QUEST, WEAPON, EQUIPMENT }
export(ItemType) var type

export(Texture) var icon
