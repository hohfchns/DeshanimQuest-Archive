class_name WanderController
extends Node2D

export(int) var wander_range = 32

onready var start_position = self.global_position
onready var target_position = global_position

export(NodePath) onready var __timer = get_node(__timer) as Timer

func update_target_position():
	var target_vector = Vector2(
	rand_range(-wander_range, wander_range), \
	rand_range(-wander_range, wander_range)
	)
	target_position = start_position + target_vector

func _ready():
	__timer.connect("timeout", self, "_on_timer_timeout")
	
	update_target_position()


func get_time_left():
	return __timer.time_left


func __start_wander_timer(duration: float):
	__timer.start(duration)


func _on_timer_timeout():
	update_target_position()
