extends Node2D

signal state_changed(new_state)


enum States { IDLE, WANDER, CHASE }
var state = States.IDLE


export var __max_speed: float = 75.0
export var __acceleration_amt: float = 500.0
export var __friction_amt: float = 200.0

export var __max_chase_interval_dist: float = 50.0

export var __move_target_range: float = 4.0

export var __wander_time_range: Array = [1.0, 3.0]

export var __knockback_multiplier: float = 0.8

export var __flash_time: float = 0.1


export(NodePath) onready var __actor = get_node(__actor) as KinematicBody2D


onready var __player_detection = $PlayerDetectionZone

onready var __wander_controller = $WanderController

onready var move_interval = $MoveIntervalTimer


var actor_velocity: Vector2 = Vector2.ZERO

var chase_target_pos: Vector2 = Vector2.ZERO

func _ready():
	connect("state_changed", self, "_on_state_changed")

func _physics_process(delta):
	match state:
		States.IDLE:
			__seek_player()
			
			if not __wander_controller.get_time_left():
				__update_wander()
			
			actor_velocity = actor_velocity.move_toward(Vector2.ZERO, __friction_amt * delta)
			
			__actor.move_and_slide(actor_velocity)
			
		States.WANDER:
#			__seek_player()
			
			if not __wander_controller.get_time_left():
				__update_wander()
			
			var dir = __actor.global_position.direction_to(__wander_controller.target_position)
			actor_velocity = actor_velocity.move_toward(__max_speed * dir, __acceleration_amt * delta)
			
			__actor.move_and_slide(actor_velocity)
			
			if not move_interval.time_left:
				__update_wander()
			
			if __actor.global_position.distance_to(__wander_controller.target_position) < __move_target_range:
				__update_wander()
			
		States.CHASE:
			
			if not __player_detection.can_see_player():
				__set_state(States.IDLE)
				return
			
			var space_state = get_world_2d().direct_space_state
			var result = space_state.intersect_ray(self.global_position, __player_detection.player.get_global_position(),\
			[self], 1)
			
			if result:
				__set_state(States.IDLE)
			else:
				var dir = __actor.global_position.direction_to(chase_target_pos)
				actor_velocity = actor_velocity.move_toward(__max_speed * dir, __acceleration_amt * delta)
			
			if not move_interval.time_left:
				__seek_player(true)
			
			if __actor.global_position.distance_to(chase_target_pos) < __move_target_range:
				__seek_player(true)
			
			__actor.move_and_slide(actor_velocity)


func __set_state(new_state, force_reset: bool = false):
	if state == new_state and not force_reset:
		return
	
	state = new_state
	
	emit_signal("state_changed", new_state)


func __seek_player(force_reset_state: bool = false):
	if __player_detection.can_see_player():
		var space_state = get_world_2d().direct_space_state
		var result = space_state.intersect_ray(self.global_position, __player_detection.player.get_global_position(),\
		[self], 1)
		
		if result:
			return
		
		if force_reset_state:
			__set_state(States.CHASE, true)
			return
		
		__set_state(States.CHASE)
	else:
		if state == States.CHASE:
			if force_reset_state:
				__set_state(States.IDLE, true)
				return
			
			__set_state(States.IDLE)
		else:
			if force_reset_state:
				__set_state(state, true)
				return


func __get_random_state(state_list: Array):
	state_list.shuffle()
	state_list.pop_front()
	return state_list[0]


func __update_wander():
	__set_state(__get_random_state([States.IDLE, States.WANDER]), true)
	__wander_controller.start_wander_timer(rand_range(__wander_time_range[0], __wander_time_range[1]))


func _on_state_changed(new_state):
	if new_state == States.CHASE:
		var player_pos = __player_detection.player.global_position
		var dir_to_player = __actor.global_position.direction_to(player_pos)
		var max_chase_target_pos = __actor.global_position + (dir_to_player * __max_chase_interval_dist)
		
		if __actor.global_position.distance_to(player_pos) < __actor.global_position.distance_to(max_chase_target_pos):
			chase_target_pos = player_pos
		else:
			chase_target_pos = max_chase_target_pos
		
		move_interval.start()
	elif new_state == States.WANDER:
		move_interval.start()
	elif new_state == States.IDLE:
		__wander_controller.start_wander_timer(rand_range(__wander_time_range[0], __wander_time_range[1]))


func _on_DebugTimer_timeout():
	print(States.keys()[state])
