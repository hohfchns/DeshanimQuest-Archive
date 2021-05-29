extends Node2D

var __can_shoot: bool = true
export var __shoot_delay: float = 0.3

export(NodePath) onready var anim = get_node(anim) as AnimationPlayer
export(NodePath) onready var shoot_timer = get_node(shoot_timer) as Timer


func use(action):
	if action == "main":
		if not __can_shoot:
			return
		
		anim.play("Shoot")
		shoot_timer.start(__shoot_delay)
