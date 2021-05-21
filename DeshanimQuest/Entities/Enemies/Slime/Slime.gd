extends KinematicBody2D


var __move_direction = Vector2(0, 0)

export(float) var __move_delay = 0.3
var __can_move: bool = true

var __can_start_slide: bool = true

export(Vector2) var __max_speed = Vector2(75, 75)
export(float) var __acceleration_amt = 50.0
export(float) var __friction_amt = 20.0

var __velocity = Vector2(0, 0)

export(NodePath) onready var __animation_player = get_node(__animation_player) as AnimationPlayer
export(NodePath) onready var __slide_timer = get_node(__slide_timer) as Timer
export(NodePath) onready var __move_delay_timer = get_node(__move_delay_timer) as Timer


func _ready():
	__slide_timer.connect("timeout", self, "_on_slide_timer_timeout")
	__move_delay_timer.connect("timeout", self, "_on_move_delay_timer_timeout")


func _physics_process(delta):
	
	__move_direction = Vector2(1, 0)
	
	if __can_move:
		__move(delta)
	if __can_start_slide:
		__start_slide()


func __move(var delta: float):
	if __move_direction != Vector2.ZERO:
		__velocity = __velocity.move_toward(__move_direction * __max_speed, __acceleration_amt * delta)
	else:
		__velocity = __velocity.move_toward(Vector2(0, 0), __friction_amt * delta)
	
	move_and_slide(__velocity)

func __start_slide():
	
	var anim_time = __animation_player.get_animation("Move").length
	__slide_timer.start(anim_time)
	
	__animation_player.play("Move")
	
	__can_start_slide = false


func _on_slide_timer_timeout():
	__move_delay_timer.start(__move_delay)
	
	__can_move = false

func _on_move_delay_timer_timeout():
	__can_move = true
	__can_start_slide = true

