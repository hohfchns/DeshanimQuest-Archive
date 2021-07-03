extends KinematicBody2D

export var friction_amt: float = 20.0

export(NodePath) onready var __jump_tween_h = get_node(__jump_tween_h) as Tween
export(NodePath) onready var __jump_tween_v = get_node(__jump_tween_v) as Tween


var __velocity = Vector2.ZERO


func _ready():
	pass

func _physics_process(delta):
	
	__velocity = __velocity.move_toward(Vector2.ZERO, friction_amt * delta)
	
	move_and_slide(__velocity)

