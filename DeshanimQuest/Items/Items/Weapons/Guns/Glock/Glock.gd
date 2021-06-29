extends Node2D

var __can_shoot: bool = true
export var __shoot_delay: float = 0.3

export(NodePath) onready var __hitray = get_node(__hitray) as Hitray

export(NodePath) onready var __anim = get_node(__anim) as AnimationPlayer
export(NodePath) onready var __shoot_timer = get_node(__shoot_timer) as Timer


func use(action):
	if action == "main":
		if not __can_shoot:
			return
		
		__anim.play("Shoot")
		__shoot_timer.start(__shoot_delay)
		shoot()


func shoot():
	__hitray.try_hit("Enemy")
