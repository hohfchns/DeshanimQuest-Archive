class_name PlayerDetectionZone
extends Area2D

var player = null


func _ready():
	connect("body_entered", self, "_on_body_entered")
	connect("body_exited", self, "_on_body_exited")


func can_see_player():
	return player != null


func _on_body_entered(body):
	player = body

func _on_body_exited(body):
	player = null
