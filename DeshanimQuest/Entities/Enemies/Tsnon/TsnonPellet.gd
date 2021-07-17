extends KinematicBody2D

var move_dir: Vector2

export var __move_speed: float = 2.5
export var __spin_speed: float = 360.0

onready var __sprite = $Sprite


func _ready():
	$DestroyCollision.connect("body_entered", self, "__destroy_on_collision")
	$DestroyCollision.connect("area_entered", self, "__destroy_on_collision")
	
	$Hitbox.connect("area_entered", self, "__destroy_on_collision")
	
	$DestroyTimer.connect("timeout", self, "queue_free")

func _physics_process(delta):
	move_and_collide(move_dir * __move_speed)
	
	__sprite.rotation_degrees += __spin_speed * delta


func __destroy_on_collision(collider):
	if collider.is_in_group("Enemy"):
		return
	
	queue_free()
