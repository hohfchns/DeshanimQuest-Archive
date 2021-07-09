extends Node2D

signal state_changed(new_state)
signal play_anim(anim)

enum States { IDLE, WANDER, FLEE, CHASE, ATTACK }

var state = States.IDLE

export var max_speed: float = 125.0
export var acceleration_amt: float = 800.0
export var friction_amt: float = 500.0
export var flee_start_range: float = 30.0
export var flee_distance: float = 30.0


export(NodePath) onready var __actor = get_node(__actor) as KinematicBody2D

onready var __player_detection = $PlayerDetectionZone
onready var __flee_timer = $FleeTimer


var actor_velocity: Vector2 = Vector2.ZERO

var flee_dir: Vector2 = Vector2.ZERO
var flee_start_pos: Vector2 = self.position
var flee_target_pos: Vector2 = self.position

func _ready():
	self.connect("state_changed", self, "_on_state_changed")

func _physics_process(delta):
	match state:
		States.IDLE:
			__seek_player()
			
			__apply_friction(delta)
			__actor.move_and_slide(actor_velocity)
		
		States.WANDER:
			pass
			
		States.FLEE:
			var target_pos = flee_start_pos + flee_dir * flee_distance
			var is_in_target_pos = __actor.global_position.distance_to(target_pos) < 5
			
			if is_in_target_pos or not __flee_timer.time_left:
				__seek_player(true)
			
			var dir = __actor.global_position.direction_to(target_pos)
			
			if not is_in_target_pos:
				actor_velocity = actor_velocity.move_toward(dir * max_speed, acceleration_amt * delta)
			else:
				__apply_friction(delta)
			
			__actor.move_and_slide(actor_velocity)
		States.CHASE:
			pass
			
		States.ATTACK:
			pass


func __apply_friction(delta):
	actor_velocity = actor_velocity.move_toward(Vector2.ZERO, friction_amt * delta)


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
		
		if __actor.global_position.distance_to(player.global_position) < flee_start_range:
			if restart_state == true:
				set_state(States.FLEE, true)
				return
			
			set_state(States.FLEE)
			return
		else:
			if restart_state == true:
				set_state(States.IDLE, true)
				return
			
			set_state(States.IDLE)
			return
	elif not __player_detection.can_see_player():
		set_state(States.IDLE)
		return









func _on_DebugTimer_timeout():
	print(States.keys()[state])
	pass
