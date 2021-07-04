extends KinematicBody2D

export var __friction_amt: float = 20.0
export var __acceleration_amt: float = 300.0
export var __max_speed: float = 75.0

export(NodePath) onready var __sprite = get_node(__sprite) as Sprite
export(NodePath) onready var __anim = get_node(__anim) as AnimationPlayer

var __velocity: Vector2 = Vector2.ZERO

func _ready():
	pass

func _physics_process(delta):
	var target_position = GameManager.get_player(self.name).global_position
	var direction = -(self.global_position.direction_to(target_position))
	
	if target_position:
		__velocity = __velocity.move_toward(direction * __max_speed, __acceleration_amt * delta)
		
		__anim.play("RunRight")
	else:
		__velocity = __velocity.move_toward(Vector2.ZERO, __friction_amt * delta)
		
		__anim.play("IdleRight")
	
	if direction.x > 0:
		__sprite.flip_h = false
	else:
		__sprite.flip_h = true
	
	move_and_slide(__velocity)
