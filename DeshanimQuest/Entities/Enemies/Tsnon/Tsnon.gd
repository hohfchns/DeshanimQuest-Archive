extends KinematicBody2D

onready var ai_controller = $RangedEnemyAI
onready var anim = $AnimationPlayer


func _process(delta):
	if ai_controller.state == ai_controller.States.IDLE:
		if ai_controller.actor_velocity.x > 0:
			anim.play("IdleRight")
		else:
			anim.play("IdleLeft")
	else:
		if ai_controller.actor_velocity.x > 0:
			anim.play("RunRight")
		else:
			anim.play("RunLeft")
