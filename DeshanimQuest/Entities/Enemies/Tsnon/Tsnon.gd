extends KinematicBody2D

onready var __ai_controller = $RangedEnemyAI
onready var __anim = $AnimationPlayer
onready var __shot_start = $ShotStartPos


var pellet = preload("res://Entities/Enemies/Tsnon/TsnonPellet.tscn")


func _process(delta):
	if __ai_controller.actor_velocity.x > 0:
		__anim.play("RunRight")
	elif __ai_controller.actor_velocity.x < 0:
		__anim.play("RunLeft")
	else:
		if __ai_controller.last_move_vector.x > 0:
			if __ai_controller.state == __ai_controller.States.ATTACK:
				__anim.play("ShootRight")
			else:
				__anim.play("IdleRight")
		else:
			if __ai_controller.state == __ai_controller.States.ATTACK:
				__anim.play("ShootLeft")
			else:
				__anim.play("IdleLeft")


func shoot():
	var pellet_inst = pellet.instance()
	pellet_inst.global_position = __shot_start.global_position
	pellet_inst.move_dir = self.global_position.direction_to(GameManager.get_player(self.name).global_position)
	
	get_parent().add_child(pellet_inst)

