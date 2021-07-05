extends KinematicBody2D

enum States { IDLE, WANDER, CHASE, DISTANCE }

var __state = States.IDLE

export var __friction_amt: float = 20.0
export var __acceleration_amt: float = 300.0
export var __max_speed: float = 75.0

# How far from a straight line away from the player to run away in
export var __distance_tolerance: Vector2 = Vector2(16, 16)
export var __reaction_time_range: Array = [0.5, 1.0]
export var __reaction_cooldown_time: float = 2.0

export(NodePath) onready var __sprite = get_node(__sprite) as Sprite
export(NodePath) onready var __anim = get_node(__anim) as AnimationPlayer

export(NodePath) onready var __chase_player_detection = get_node(__chase_player_detection) as PlayerDetectionZone
export(NodePath) onready var __distance_player_detection = get_node(__distance_player_detection) as PlayerDetectionZone

export(NodePath) onready var __reaction_timer = get_node(__reaction_timer) as Timer
export(NodePath) onready var __reaction_cooldown_timer = get_node(__reaction_cooldown_timer) as Timer

var __velocity: Vector2 = Vector2.ZERO

var __last_move_dir: Vector2 = Vector2.ZERO

func _ready():
	pass

func _physics_process(delta):
	var move_dir = Vector2(0, 0)
	
	if __state == States.IDLE:
		move_dir = Vector2(0, 0)
		
		if __last_move_dir.x >= 0:
			__anim.play("IdleRight")
		else:
			__anim.play("IdleLeft")
		
	elif __state == States.WANDER:
		pass
		
	elif __state == States.CHASE:
		pass
		
	elif __state == States.DISTANCE:
		var player = __distance_player_detection.player
		if not player:
			__state = __get_random_state([States.IDLE, States.WANDER])
		
		var target_pos: Vector2 = -(player.global_position)
		target_pos.x += rand_range(-(__distance_tolerance.x), __distance_tolerance.x)
		target_pos.y += rand_range(-(__distance_tolerance.y), __distance_tolerance.y)
	
	move_and_slide(__velocity)
	
	__last_move_dir = move_dir


func __seek_player():
	if __distance_player_detection.player != null:
		if __reaction_timer.time_left:
			return
		__state = States.DISTANCE
	else:
		if __reaction_cooldown_timer.time_left:
			return
		__state = __get_random_state([States.IDLE, States.WANDER])

func __get_random_state(state_list: Array):
	state_list.shuffle()
	state_list.pop_front()
	return state_list
