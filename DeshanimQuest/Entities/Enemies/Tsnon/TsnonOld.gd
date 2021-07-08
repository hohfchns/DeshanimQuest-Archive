extends KinematicBody2D

enum States { IDLE, WANDER, CHASE, DISTANCE }

var __state = States.IDLE

export var __friction_amt: float = 300.0
export var __acceleration_amt: float = 300.0
export var __max_speed: float = 75.0

# How far from a straight line away from the player to run away in
export var __distance_dir_tolerance: Vector2 = Vector2(16, 16)
export var __distance_max_time: float = 1.5
export var __distance_cooldown: float = 1.5
export var __reaction_time_range: Array = [0.5, 1.0]
export var __reaction_cooldown: float = 2.0

export(NodePath) onready var __sprite = get_node(__sprite) as Sprite
export(NodePath) onready var __anim = get_node(__anim) as AnimationPlayer

export(NodePath) onready var __chase_player_detection = get_node(__chase_player_detection) as PlayerDetectionZone
export(NodePath) onready var __distance_player_detection = get_node(__distance_player_detection) as PlayerDetectionZone

export(NodePath) onready var __reaction_timer = get_node(__reaction_timer) as Timer
export(NodePath) onready var __reaction_cooldown_timer = get_node(__reaction_cooldown_timer) as Timer
export(NodePath) onready var __distance_max_timer = get_node(__distance_max_timer) as Timer
export(NodePath) onready var __distance_cooldown_timer = get_node(__distance_cooldown_timer) as Timer

var __velocity: Vector2 = Vector2.ZERO
var __last_move_dir: Vector2 = Vector2.ZERO
var __target_pos: Vector2

signal state_changed(new_state)

func _ready():
	
	__distance_player_detection.connect("body_entered", self, "_on_distance_player_entered")
	__distance_player_detection.connect("body_exited", self, "_on_distance_player_exited")
	
	self.connect("state_changed", self, "_on_state_changed")

func _physics_process(delta):
#	print(States.keys()[__state])
#	print(__distance_player_detection.player)
	
	var move_dir = Vector2(0, 0)
	
	if __state == States.IDLE:
		__seek_player()
		
		move_dir = Vector2(0, 0)
		
		if __last_move_dir.x >= 0:
			__anim.play("IdleRight")
		else:
			__anim.play("IdleLeft")
		
	elif __state == States.WANDER:
		__set_state(States.IDLE)
		
	elif __state == States.CHASE:
		pass
		
	elif __state == States.DISTANCE:
		# Check _on_state_changed()
		
		__seek_player()
		
		move_dir = -(self.global_position.direction_to(__target_pos))
		
		if move_dir.x >= 0:
			__anim.play("RunRight")
		else:
			__anim.play("RunLeft")
	
	if not move_dir:
		__velocity = __velocity.move_toward(Vector2.ZERO, __friction_amt * delta)
	else:
		__velocity = __velocity.move_toward(move_dir * __max_speed, __acceleration_amt * delta)
	move_and_slide(__velocity)
	
	__last_move_dir = move_dir


func __set_state(new_state):
	__state = new_state
	emit_signal("state_changed", new_state)


func __seek_player():
	if __distance_player_detection.player:
		if __reaction_timer.time_left or __distance_cooldown_timer.time_left:
			return
		
		if (not __distance_max_timer.time_left) and (__state == States.DISTANCE):
			__set_state(States.IDLE)
			print("setting state to idle")
			return
		
		if __state != States.DISTANCE and not __distance_cooldown_timer.time_left:
			__set_state(States.DISTANCE)
		
	else:
		if __reaction_cooldown_timer.time_left:
			return
		
		if __state != States.IDLE:
			__set_state(States.IDLE)


func __get_random_state(state_list: Array):
	state_list.shuffle()
	state_list.pop_front()
	return state_list[0]


func _on_state_changed(new_state):
	if new_state == States.DISTANCE:
#		print("changed state to distance")
		
		var player = __distance_player_detection.player
		if not player:
			return
		
		__target_pos = player.global_position
		__target_pos.x += rand_range(-(__distance_dir_tolerance.x), __distance_dir_tolerance.x)
		__target_pos.y += rand_range(-(__distance_dir_tolerance.y), __distance_dir_tolerance.y)
	elif new_state == States.IDLE:
		__distance_cooldown_timer.start(__distance_cooldown)


func _on_distance_player_entered(player):
	__reaction_timer.start(rand_range(__reaction_time_range[0], __reaction_time_range[1]))

func _on_distance_player_exited(player):
	__reaction_cooldown_timer.start(__reaction_cooldown)

