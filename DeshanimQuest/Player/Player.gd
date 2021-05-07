extends KinematicBody2D

var __input_vector = Vector2(0, 0)
var __last_input_vector = Vector2(1, 0)

var __velocity = Vector2(0, 0)
export var __max_speed = Vector2(200, 200)
export var __acceleration_amt = 1500
export var __friction_amt = 1200

#export(NodePath) onready var __body_sprite = get_node(__body_sprite) as Sprite
#export(NodePath) onready var __right_arm_sprite = get_node(__right_arm_sprite) as Sprite
#export(NodePath) onready var __left_arm_sprite = get_node(__left_arm_sprite) as Sprite

export(NodePath) onready var __body_anim = get_node(__body_anim) as AnimationPlayer
export(NodePath) onready var __right_arm_anim = get_node(__right_arm_anim) as AnimationPlayer
export(NodePath) onready var __left_arm_anim = get_node(__left_arm_anim) as AnimationPlayer


func _ready():
	pass


func _physics_process(delta):
	
	
	__calc_input_vector()
	
	__movement_code(delta)
	
	__animate_sprites()
	
	__last_input_vector = __input_vector if __input_vector else __last_input_vector 


func __calc_input_vector():
	__input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	__input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	__input_vector = __input_vector.normalized()


func __movement_code(delta):
	if __input_vector != Vector2.ZERO:
		__velocity = __velocity.move_toward(__input_vector * __max_speed, __acceleration_amt * delta)
	else:
		__velocity = __velocity.move_toward(Vector2(0, 0), __friction_amt * delta)
	
	move_and_collide(__velocity * delta)

func __animate_sprites():
	if __input_vector != Vector2.ZERO:
		if __input_vector.x >= 0:
			__body_anim.play("RunRight")
			__right_arm_anim.play("RunRight")
			__left_arm_anim.play("RunRight")
		else:
			__body_anim.play("RunLeft")
			__right_arm_anim.play("RunLeft")
			__left_arm_anim.play("RunLeft")
	else:
		if __last_input_vector.x >= 0:
			__body_anim.play("IdleRight")
			__right_arm_anim.play("IdleRight")
			__left_arm_anim.play("IdleRight")
		else:
			__body_anim.play("IdleLeft")
			__right_arm_anim.play("IdleLeft")
			__left_arm_anim.play("IdleLeft")
