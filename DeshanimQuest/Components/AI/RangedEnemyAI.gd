extends Node2D

signal state_changed(new_state)
signal play_anim(anim)

enum States { IDLE, WANDER, FLEE, CHASE, ATTACK }

var state = States.IDLE


export var __max_speed: float = 80.0
export var __acceleration_amt: float = 500.0
export var __friction_amt: float = 700.0

export var __flee_start_range: float = 30.0
export var __flee_distance: float = 30.0

export var __dist_after_chase: float = 100.0

export var __wander_timer_range: Array = [1.0, 3.0]
export var __wander_target_range: float = 3

export(NodePath) onready var __actor = get_node(__actor) as KinematicBody2D

onready var __player_detection = $PlayerDetectionZone
onready var __wander_controller = $WanderController
onready var __flee_timer = $FleeTimer


var actor_velocity: Vector2 = Vector2.ZERO

var last_move_vector: Vector2 = Vector2.ZERO 


var flee_dir: Vector2 = Vector2.ZERO
var flee_start_pos: Vector2 = self.position
var flee_target_pos: Vector2 = self.position

func _ready():
	self.connect("state_changed", self, "_on_state_changed")

func _physics_process(delta):
	match state:
		States.IDLE:
			__seek_player()
			
			if not __wander_controller.get_time_left():
				__update_wander()
			
			__apply_friction_to_actor(delta)
			__actor.move_and_slide(actor_velocity)
			
		States.WANDER:
			if not __wander_controller.get_time_left():
				__update_wander()
				return
			
			var dir = __actor.global_position.direction_to(__wander_controller.target_position)
			
			if __actor.global_position.distance_to(__wander_controller.target_position) >= __wander_target_range:
				actor_velocity = actor_velocity.move_toward(dir * __max_speed, __acceleration_amt * delta)
				__actor.move_and_slide(actor_velocity)
				
				last_move_vector = dir
			else:
				__apply_friction_to_actor(delta)
				__actor.move_and_slide(actor_velocity)
			
		States.FLEE:
			var target_pos = flee_start_pos + flee_dir * __flee_distance
			var is_in_target_pos = __actor.global_position.distance_to(target_pos) < 5
			
			if is_in_target_pos or not __flee_timer.time_left:
				__seek_player(true)
			
			var dir = __actor.global_position.direction_to(target_pos)
			
			if not is_in_target_pos:
				actor_velocity = actor_velocity.move_toward(dir * __max_speed, __acceleration_amt * delta)
			else:
				set_state(States.IDLE)
			
			__actor.move_and_slide(actor_velocity)
			
			last_move_vector = dir
			
		States.CHASE:
			__seek_player()
			
			var player = __player_detection.player
			
			if not player:
				set_state(States.IDLE)
				return
			
			var dir_to_player = __actor.global_position.direction_to(player.global_position)
			var dist_to_player = __actor.global_position.distance_to(player.global_position)
			
			# If the actor needs to get closer to the player
			if __dist_after_chase < dist_to_player:
				actor_velocity = actor_velocity.move_toward(dir_to_player * __max_speed, __acceleration_amt * delta)
			else:
				__apply_friction_to_actor(delta)
			
			__actor.move_and_slide(actor_velocity)
			
			last_move_vector = dir_to_player
			
		States.ATTACK:
			pass


func __apply_friction_to_actor(delta):
	actor_velocity = actor_velocity.move_toward(Vector2.ZERO, __friction_amt * delta)


func __get_random_state(states_list: Array):
	states_list.shuffle()
	return states_list[0]


func set_state(new_state, restart_state = false):
	if state == new_state and not restart_state:
		return
	
	state = new_state
	emit_signal("state_changed", new_state)


func _on_state_changed(new_state):
	if new_state == States.FLEE:
		flee_dir = __player_detection.player.global_position.direction_to(__actor.global_position)
		flee_start_pos = __actor.global_position
		
		__flee_timer.start()


func __seek_player(restart_state = false):
	if __player_detection.can_see_player():
		var player = __player_detection.player
		
		if __actor.global_position.distance_to(player.global_position) < __flee_start_range:
			if restart_state == true:
				set_state(States.FLEE, true)
				return
			else:
				set_state(States.FLEE)
				return
		else:
			set_state(States.CHASE)
			return
	elif not __player_detection.can_see_player():
		set_state(States.IDLE)
		return


func __update_wander():
	state = __get_random_state([States.IDLE, States.WANDER])
	__wander_controller.start_wander_timer(rand_range(__wander_timer_range[0], __wander_timer_range[1]))





func _on_DebugTimer_timeout():
	print(States.keys()[state])
	print("actor velocity is %s" % actor_velocity)
	print("last_move_dir is %s" % last_move_vector)
	pass
