extends KinematicBody2D

export var __max_speed = Vector2(200, 200)
export var __acceleration_amt = 1500
export var __friction_amt = 1200

export(NodePath) var __right_hand_path; onready var __right_hand = get_node(__right_hand_path) as FloatingHand
export(NodePath) onready var __right_hand_rot_point = get_node(__right_hand_rot_point) as Position2D

export(NodePath) onready var __body_anim = get_node(__body_anim) as AnimationPlayer

var __can_attack: bool = true
var __can_move: bool = true

var __input_vector = Vector2(0, 0)
var __last_input_vector = Vector2(1, 0)

var __velocity = Vector2(0, 0)


func _ready():
	pass


func _physics_process(delta):
	
	__calc_input_vector()
	
	__movement_code(delta)
	
	__animate_sprites()
	
	__set_hand_distance()
	
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
	var moving: bool = __input_vector != Vector2.ZERO
	var rot = __right_hand_rot_point.rotation_degrees
	
	if moving:
		if __right_hand.global_position > self.global_position:
			__body_anim.play("RunRight")
		else:
			__body_anim.play("RunLeft")
	elif not moving:
		if __right_hand.global_position > self.global_position:
			__body_anim.play("IdleRight")
		else:
			__body_anim.play("IdleLeft")


func __set_hand_distance():
	__right_hand_rot_point.look_at(get_global_mouse_position())
	



