class_name Player
extends KinematicBody2D

var __stats = PlayerStats

export var __max_speed = Vector2(200, 200)
export var __acceleration_amt = 1500
export var __friction_amt = 1200

export(float) var __hand_distance = 20.0

export(float) var __invincibility_duration = 1.0

export(NodePath) onready var __hand_axis = get_node(__hand_axis) as Node2D
export(NodePath) onready var __hand_rot_point = get_node(__hand_rot_point) as Node2D
onready var __current_item = __hand_rot_point.get_child(0)

export(NodePath) onready var __hurtbox = get_node(__hurtbox) as Hurtbox

export(NodePath) onready var __interaction_area = get_node(__interaction_area) as Area2D

export(NodePath) onready var __body_anim = get_node(__body_anim) as AnimationPlayer

export(NodePath) onready var __effects_anim = get_node(__effects_anim) as AnimationPlayer

#export(NodePath) onready var __health_bar = get_node(__health_bar) as HealthBar

var __can_attack: bool = true
var __can_move: bool = true

var __input_vector = Vector2(0, 0)
var __last_input_vector = Vector2(1, 0)

var __velocity = Vector2(0, 0)


func _ready():
	randomize()
	
	__connect_signal_functions()


func _physics_process(delta):
	
	__calc_input_vector()
	
	__movement_code(delta)
	
	__animate_sprites()
	
	__set_hand_rot()
	
	__get_player_input()
	
	__last_input_vector = __input_vector if __input_vector else __last_input_vector 


func __connect_signal_functions():
	__stats.connect("health_changed", self, "_on_stats_health_changed")
	__stats.connect("no_health", self, "_on_stats_no_health")
	connect("tree_entered", self, "_on_tree_entered")
	__hurtbox.connect("area_entered", self, "_on_hurtbox_entered")
	__hurtbox.connect("invincibility_started", self, "_on_hurtbox_invincibility_started")
	__hurtbox.connect("invincibility_ended", self, "_on_hurtbox_invincibility_ended")


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
	var rot = __hand_axis.rotation_degrees
	
	if moving:
		if get_global_mouse_position() > self.global_position:
			__body_anim.play("RunRight")
		else:
			__body_anim.play("RunLeft")
	elif not moving:
		if get_global_mouse_position() > self.global_position:
			__body_anim.play("IdleRight")
		else:
			__body_anim.play("IdleLeft")


func __set_hand_rot():
	
	if get_global_mouse_position() > self.get_global_position():
		__hand_axis.scale.x = 1
	else:
		__hand_axis.scale.x = -1
	
	__hand_rot_point.look_at(get_global_mouse_position())
	


func __play_current_item_anim(var anim_name: String):
	var ap = __current_item.get_node("AnimationPlayer") as AnimationPlayer
	ap.play(anim_name)

func __use_current_item(action):
	__current_item.use(action)


func __get_player_input():
	if __current_item:
		if Input.is_action_just_pressed("use_item"):
			__use_current_item("main")
		elif Input.is_action_just_pressed("alt_use_item"):
			__use_current_item("alt")
	
	if Input.is_action_just_pressed("Interact"):
		if __interaction_area.get_overlapping_bodies():
			var object = __interaction_area.get_overlapping_bodies()[0]
			object.interact()
		if __interaction_area.get_overlapping_areas():
			var object = __interaction_area.get_overlapping_areas()[0]
			object.interact()


func set_current_item(item_ref):
	__hand_rot_point.add_child(item_ref)
	if __hand_rot_point.get_children().size() > 1:
		__current_item = __hand_rot_point.get_child(1)
		__hand_rot_point.get_child(0).queue_free()
	else:
		__current_item = __hand_rot_point.get_child(0)
	
	__current_item.position.x = __hand_distance


func _on_stats_health_changed():
	pass


func _on_stats_no_health():
	queue_free()


func _on_hurtbox_entered(area):
	__hurtbox.start_invincibility(__invincibility_duration)
	__stats.subtract_health(area.damage)

func _on_hurtbox_invincibility_started():
	__effects_anim.play("HitBlinkStart")

func _on_hurtbox_invincibility_ended():
	__effects_anim.play("HitBlinkStop")


func _on_tree_entered():
	GameManager.generate_player_ref()

func _on_Player_tree_entered():
	GameManager.generate_player_ref()
