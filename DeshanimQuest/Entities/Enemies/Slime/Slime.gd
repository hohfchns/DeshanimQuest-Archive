extends KinematicBody2D


var __move_direction = Vector2(0, 0)

export(float) var __move_delay = 0.3

var __should_move: bool = true
var __start_slide_next_frame: bool = true
var __can_move: bool = true

export(Vector2) var __max_speed = Vector2(75, 75)
export(float) var __acceleration_amt = 500.0
export(float) var __friction_amt = 200.0

export(float) var __knockback_multiplier = 0.8

var __velocity = Vector2(0, 0)

export(NodePath) onready var __stats = get_node(__stats) as EnemyStats

export(NodePath) onready var __damage_number_indicator = get_node(__damage_number_indicator) as DamageNumberIndicator

export(NodePath) onready var __animation_player = get_node(__animation_player) as AnimationPlayer

export(NodePath) onready var __hurtbox = get_node(__hurtbox) as Hurtbox

export(NodePath) onready var __slide_timer = get_node(__slide_timer) as Timer
export(NodePath) onready var __move_delay_timer = get_node(__move_delay_timer) as Timer


func _ready():
	__connect_signals()


func _physics_process(delta):
	
	var move_direction = Vector2(1, 0)
	
	__attempt_move(move_direction, delta)


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


func __connect_signals():
	__slide_timer.connect("timeout", self, "_on_slide_timer_timeout")
	__move_delay_timer.connect("timeout", self, "_on_move_delay_timer_timeout")
	
	__hurtbox.connect("area_entered", self, "_on_hurtbox_area_entered")
	
	__stats.connect("no_health", self, "_on_stats_no_health")


func _on_slide_timer_timeout():
	__move_delay_timer.start(__move_delay)
	
	__should_move = false
	__can_move = false

func _on_move_delay_timer_timeout():
	__should_move = true
	__start_slide_next_frame = true
	__can_move = true


func _on_hurtbox_area_entered(area: Hitbox):
	var knockback_to_take = __knockback_multiplier\
	* area.knockback_amt\
	* area.get_parent().global_position.direction_to(self.global_position)
	__velocity += knockback_to_take
	
	__stats.subtract_health(area.damage)
	
	__damage_number_indicator.start(area.damage)

func _on_stats_no_health():
	queue_free()

