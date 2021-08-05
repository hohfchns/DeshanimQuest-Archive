extends Node

signal class_changed(new_class)

signal stats_changed(old_stats, new_stats)

signal health_changed
signal no_health

enum Classes { NOCLASS, RANGER, WARRIOR }

export(Classes) var player_class
var current_class_name = Classes.keys()[player_class]

export var __stats: Dictionary = {
	# VITALITY - Increase health
	"VIT": 0,
	# ENDURANCE - Increase stamina
	"END": 0,
	# STRENGTH - Increased damage with melee weapons
	"STR": 0,
	# DEXTERITY - Slightliy increased stamina and increased damage with ranged weapons
	"DEX": 0,
	# RESISTANCE - Increased defense
	"RES": 0,
	# INTELLIGENCE - Increased mana and damage with magic weapons
	"INT": 0,
} setget set_stats, get_stats

export(int) var __base_max_health = 100.0
export(int) var __max_health = __base_max_health setget set_max_health, get_max_health

export(int) var __health = __max_health setget set_health, get_health

func _ready():
	connect("stats_changed", self, "_on_stats_changed")
	
	connect("health_changed", self, "_on_health_changed")
	SaveLoad.connect("save_loaded", self, "_on_save_loaded")
	
	current_class_name = Classes.keys()[player_class]
	set_max_health(__base_max_health)


func set_class(new_class):
	player_class = new_class
	current_class_name = Classes.keys()[new_class]
	
	emit_signal("class_changed", new_class)


func set_stats(new_stats):
	var old_stats = __stats
	
	__stats = new_stats
	
	emit_signal("stats_changed", old_stats, new_stats)

func get_stats():
	return __stats


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
	
	if "class" in save_data["player"]:
		set_class(save_data["player"]["class"])
	else:
		set_class(Classes.RANGER)
	
	if "max_health" in save_data["player"]:
		if save_data["save_version"] > 2:
			set_max_health(save_data["player"]["max_health"])
		else:
			set_max_health(save_data["player"]["max_health"] * 20)
	if "health" in save_data["player"]:
		if save_data["save_version"] > 2:
			set_health(save_data["player"]["health"])
		else:
			set_health(save_data["player"]["health"] * 20)
	
	print("Player stats set from save %s" % (slot_idx+1))


func _on_stats_changed(old_stats, new_stats):
	pass
