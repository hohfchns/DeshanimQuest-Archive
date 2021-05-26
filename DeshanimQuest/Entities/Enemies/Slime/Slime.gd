extends KinematicBody2D


enum States { IDLE, WANDER, CHASE }

var __state = States.IDLE

var __move_direction = Vector2(0, 0)

export(float) var __move_delay = 0.3

var __should_move: bool = true
var __start_slide_next_frame: bool = true
var __can_move: bool = true

export(Vector2) var __max_speed = Vector2(75, 75)
export(float) var __acceleration_amt = 500.0
export(float) var __friction_amt = 200.0

export(float) var __wander_target_range = 4

export(float) var __knockback_multiplier = 0.8

export(float) var __flash_time = 0.1

var __velocity = Vector2(0, 0)

export(NodePath) onready var __stats = get_node(__stats) as EnemyStats

export(NodePath) onready var __wander_controller = get_node(__wander_controller) as WanderController

export(NodePath) onready var __soft_collision = get_node(__soft_collision) as SoftCollision

export(NodePath) onready var __player_detection_zone = get_node(__player_detection_zone) as PlayerDetectionZone

export(NodePath) onready var __hurtbox = get_node(__hurtbox) as Hurtbox

export(NodePath) onready var __animation_player = get_node(__animation_player) as AnimationPlayer
export(NodePath) onready var __effects_animation_player = get_node(__effects_animation_player) as AnimationPlayer

export(NodePath) onready var __damage_number_indicator = get_node(__damage_number_indicator) as DamageNumberIndicator

export(NodePath) onready var __slide_timer = get_node(__slide_timer) as Timer
export(NodePath) onready var __move_delay_timer = get_node(__move_delay_timer) as Timer

export(NodePath) onready var __flash_timer = get_node(__flash_timer) as Timer


func _ready():
	__connect_signals()
	
	__state = __pick_random_state([States.IDLE, States.WANDER])


func _physics_process(delta):
	
#	var move_direction = Vector2(1, 0)
	
	match __state:
		States.IDLE:
			__apply_friction(delta)
			__seek_player()
			
			if not __wander_controller.get_time_left():
				__update_wander()
		
		States.WANDER:
			__seek_player()
			
			if __wander_controller.get_time_left() == 0:
				__update_wander()
			var direction = self.global_position.direction_to(__wander_controller.target_position)
			__attempt_move(direction, delta)
			
			if self.global_position.distance_to(__wander_controller.target_position) <= __wander_target_range:
				__update_wander()
		
		States.CHASE:
			var player = __player_detection_zone.player
			
			
			if player != null:
				var direction = self.global_position.direction_to(player.global_position)
				__attempt_move(direction, delta)
			else:
				__state = States.IDLE
	
	if __soft_collision.is_colliding():
		__velocity += __soft_collision.get_push_vector() * delta * 200


func __apply_friction(delta: float):
	__velocity = __velocity.move_toward(Vector2(0, 0), __friction_amt * delta)

func __move(direction: Vector2, delta: float):
	if direction != Vector2.ZERO:
		__velocity = __velocity.move_toward(direction * __max_speed, __acceleration_amt * delta)
	else:
		__apply_friction(delta)

func __start_slide():
	
	var anim_time = __animation_player.get_animation("Move").length
	__slide_timer.start(anim_time)
	
	__animation_player.play("Move")
	
	__start_slide_next_frame = false

func __attempt_move(move_direction: Vector2, delta: float):
	if __can_move:
		if __should_move:
			__move(move_direction, delta)
		else:
			__apply_friction(delta)
		if __start_slide_next_frame:
			__start_slide()
	else:
		__apply_friction(delta)
	
	move_and_slide(__velocity)


func __seek_player():
	if __player_detection_zone.can_see_player():
		__state = States.CHASE


func __pick_random_state(state_list: Array):
	state_list.shuffle()
	return state_list.pop_front()


func __update_wander():
	__state = __pick_random_state([States.IDLE, States.WANDER])
	__wander_controller.__start_wander_timer(rand_range(1, 3))


func __connect_signals():
	__slide_timer.connect("timeout", self, "_on_slide_timer_timeout")
	__move_delay_timer.connect("timeout", self, "_on_move_delay_timer_timeout")
	
	__flash_timer.connect("timeout", self, "_on_flash_timeout")
	
	__hurtbox.connect("area_entered", self, "_on_hurtbox_area_entered")
	
	__stats.connect("no_health", self, "_on_stats_no_health")


func __start_hit_effect(duration):
	__effects_animation_player.play("FlashStart")
	__flash_timer.start(__flash_time)


func _on_slide_timer_timeout():
	__move_delay_timer.start(__move_delay)
	
	__should_move = false
	__can_move = false

func _on_move_delay_timer_timeout():
	__should_move = true
	__start_slide_next_frame = true
	__can_move = true


func _on_flash_timeout():
	__effects_animation_player.play("FlashStop")


func _on_hurtbox_area_entered(area: Hitbox):
	var knockback_to_take = __knockback_multiplier\
	* area.knockback_amt\
	* area.get_parent().global_position.direction_to(self.global_position)
	__velocity += knockback_to_take
	
	__stats.subtract_health(area.damage)
	
	__damage_number_indicator.start(area.damage)
	
	__start_hit_effect(__flash_time)

func _on_stats_no_health():
	queue_free()

