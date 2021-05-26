class_name Hurtbox
extends Area2D

var __invincible = false setget set_invincible, get_invincible

export(NodePath) onready var __invincibility_timer = get_node(__invincibility_timer) as Timer

signal invincibility_started
signal invincibility_ended


func _ready():
	__invincibility_timer.connect("timeout", self, "_on_invincibility_timeout")
	
	connect("invincibility_started", self, "_on_invincibility_started")
	connect("invincibility_ended", self, "_on_invincibility_ended")


func set_invincible(value):
	__invincible = value
	
	if get_invincible() == true:
		emit_signal("invincibility_started")
	else:
		emit_signal("invincibility_ended")

func get_invincible():
	return __invincible


func start_invincibility(duration):
	set_invincible(true)
	__invincibility_timer.start(duration)


func _on_invincibility_timeout():
	set_invincible(false)


func _on_invincibility_started():
	set_deferred("monitorable", false)

func _on_invincibility_ended():
	self.monitorable = true
