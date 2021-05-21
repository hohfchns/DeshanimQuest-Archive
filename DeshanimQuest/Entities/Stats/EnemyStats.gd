class_name EnemyStats
extends Node

export(int) var max_health
export(int) var __health = max_health setget set_health, get_health

signal no_health

func _ready():
	__health = max_health


func set_health(value):
	__health = value
	
	if __health <= 0:
		emit_signal("no_health")

func get_health():
	return __health

func subtract_health(value):
	set_health(__health - value)
