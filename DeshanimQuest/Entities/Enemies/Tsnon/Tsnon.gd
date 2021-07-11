extends KinematicBody2D

onready var ai_controller = $RangedEnemyAI
onready var anim = $AnimationPlayer


func _process(delta):
	if ai_controller.actor_velocity.x > 0:
		anim.play("RunRight")
	elif ai_controller.actor_velocity.x < 0:
		anim.play("RunLeft")
	else:
		if ai_controller.last_move_vector.x > 0:
			anim.play("IdleRight")
		else:
			anim.play("IdleLeft")
