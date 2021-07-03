extends Node2D

export(PackedScene) var target_scene

export(float) var rotation_speed = 180.0


func _ready():
	connect("body_entered", self, "_on_body_entered")


func _process(delta):
	$Sprite.rotation_degrees += rotation_speed * delta


func _on_body_entered(body):
	if body is Player:
		get_tree().change_scene_to(target_scene)
