extends Node

signal health_changed
signal no_health

signal class_changed(new_class)

enum Classes { NOCLASS, RANGER, WARRIOR }

export(Classes) var player_class
var current_class_name = Classes.keys()[player_class]

export(int) var __max_health setget set_max_health, get_max_health
export(int) var __health = __max_health setget set_health, get_health

func _ready():
	connect("health_changed", self, "_on_health_changed")
	SaveLoad.connect("save_loaded", self, "_on_save_loaded")
	
	current_class_name = Classes.keys()[player_class]
#	__health = __max_health


func set_class(new_class):
	player_class = new_class
	current_class_name = Classes.keys()[new_class]
	
	emit_signal("class_changed", new_class)


func set_health(value):
	__health = value
	
	emit_signal("health_changed")

func get_health():
	return __health

func add_health(value):
	set_health(min(get_health() + value, get_max_health()))

func subtract_health(value):
	set_health(__health - value)


func set_max_health(value):
	__max_health = value

func get_max_health():
	return __max_health


func _on_health_changed():
	if __health <= 0:
		emit_signal("no_health")


func _on_save_loaded(save_data, slot_idx):
	if not "player" in save_data:
		return
	
	if "max_health" in save_data["player"]:
		set_max_health(save_data["player"]["max_health"])
	if "health" in save_data["player"]:
		set_health(save_data["player"]["health"])
	
	print("Player stats set from save %s" % slot_idx)
