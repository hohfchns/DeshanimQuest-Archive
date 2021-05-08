extends KinematicBody2D

var __input_vector = Vector2(0, 0)
var __last_input_vector = Vector2(1, 0)

var __velocity = Vector2(0, 0)
export var __max_speed = Vector2(200, 200)
export var __acceleration_amt = 1500
export var __friction_amt = 1200

enum HandStates { BOTH, RIGHT, LEFT }
var taken_hands = HandStates.RIGHT

export var right_hand_distance = 5.0
export var left_hand_distance = 5.0

export(NodePath) onready var __right_hand = get_node(__right_hand) as FloatingHand
export(NodePath) onready var __left_hand = get_node(__left_hand) as FloatingHand

export(NodePath) onready var __right_hand_rot_point = get_node(__right_hand_rot_point) as Position2D
export(NodePath) onready var __left_hand_rot_point = get_node(__left_hand_rot_point) as Position2D

#export(NodePath) onready var __body_sprite = get_node(__body_sprite) as Sprite
#export(NodePath) onready var __right_arm_sprite = get_node(__right_arm_sprite) as Sprite
#export(NodePath) onready var __left_arm_sprite = get_node(__left_arm_sprite) as Sprite
onready var __right_arm_sprite = $AnimSprites/RightArmSprite as Sprite
onready var __left_arm_sprite = $AnimSprites/LeftArmSprite as Sprite


export(NodePath) onready var __body_anim = get_node(__body_anim) as AnimationPlayer
export(NodePath) onready var __right_arm_anim = get_node(__right_arm_anim) as AnimationPlayer
export(NodePath) onready var __left_arm_anim = get_node(__left_arm_anim) as AnimationPlayer


func _ready():
	pass


func _physics_process(delta):
	
	
	__calc_input_vector()
	
	__movement_code(delta)
	
	__animate_sprites()
	__hide_taken_hands()
	
	__set_hands_distance()
	
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


func __play_run_anim(side):
	__body_anim.play("Run" + side)
	__right_arm_anim.play("Run" + side)
	__left_arm_anim.play("Run" + side)

func __play_idle_anim(side):
	__body_anim.play("Idle" + side)
	__right_arm_anim.play("Idle" + side)
	__left_arm_anim.play("Idle" + side)

func __animate_sprites():
	var moving: bool = __input_vector != Vector2.ZERO
	if moving:
		if taken_hands == HandStates.BOTH:
			if __input_vector.x >= 0:
				__play_run_anim("Right")
			else:
				__play_run_anim("Left")
		elif taken_hands == HandStates.RIGHT:
			if __right_hand_rot_point.rotation_degrees > -90 \
			and __right_hand_rot_point.rotation_degrees < 90:
				__play_run_anim("Right")
			else:
				__play_run_anim("Left")
		elif taken_hands == HandStates.LEFT:
			pass
	elif not moving:
		pass
#		if __last_input_vector.x >= 0:
#			__play_idle_anim("Right")
#		else:
#			__play_idle_anim("Left")


func __hide_taken_hands():
	match taken_hands:
		HandStates.BOTH:
			__right_arm_sprite.hide()
			__left_arm_sprite.hide()
			__right_hand.show()
			__left_hand.show()
			
		HandStates.RIGHT:
			__right_arm_sprite.hide()
			__left_arm_sprite.show()
			__right_hand.show()
			__left_hand.hide()
		HandStates.LEFT:
			__right_arm_sprite.show()
			__left_arm_sprite.hide()
			__right_hand.hide()
			__left_hand.show()

func __set_hands_distance():
	__right_hand_rot_point.look_at(get_global_mouse_position())
	__left_hand_rot_point.look_at(get_global_mouse_position())
	



