class_name Hitbox
extends Area2D

enum DamageTypes { MELEE, MAGIC, RANGED }
export(DamageTypes) var damage_type

export(int) var damage
export(int) var knockback_amt


func _ready():
	pass
