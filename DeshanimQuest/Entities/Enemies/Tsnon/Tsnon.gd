extends KinematicBody2D

onready var __ai_controller = $RangedEnemyAI
onready var __anim = $AnimationPlayer
onready var __shot_start = $ShotStartPos
onready var __damage_number_indicator = $DamageNumberIndicator
onready var __effects_animation_player = $EffectsAP
onready var __stats = $Stats
onready var __hurtbox = $Hurtbox

export var __knockback_multiplier: float = 1.2


var pellet = preload("res://Entities/Enemies/Tsnon/TsnonPellet.tscn")


func _ready():
	__stats.connect("no_health", self, "_on_stats_no_health")
	__hurtbox.connect("area_entered", self, "_on_hurtbox_area_entered")


func _process(delta):
	if __ai_controller.actor_velocity.x > 0:
		__anim.play("RunRight")
	elif __ai_controller.actor_velocity.x < 0:
		__anim.play("RunLeft")
	else:
		if __ai_controller.last_move_vector.x > 0:
			if __ai_controller.state == __ai_controller.States.ATTACK:
				__anim.play("ShootRight")
			else:
				__anim.play("IdleRight")
		else:
			if __ai_controller.state == __ai_controller.States.ATTACK:
				__anim.play("ShootLeft")
			else:
				__anim.play("IdleLeft")


func shoot():
	var pellet_inst = pellet.instance()
	pellet_inst.global_position = __shot_start.global_position
	pellet_inst.move_dir = self.global_position.direction_to(GameManager.get_player(self.name).global_position)
	
	get_parent().add_child(pellet_inst)


func __take_hit(damage: int, knockback_amt: float, hitter):
	var knockback_to_take = knockback_amt \
	* __knockback_multiplier \
	* hitter.get_parent().global_position.direction_to(self.global_position)
	
	__ai_controller.actor_velocity += knockback_to_take
	
	__stats.subtract_health(damage)
	
	__damage_number_indicator.start(damage)
	
	__effects_animation_player.play("Flash")


func on_hitray_hit(hitray: Hitray):
	__take_hit(hitray.damage, hitray.knockback_amt, hitray)

func _on_hurtbox_area_entered(area: Hitbox):
	__take_hit(area.damage, area.knockback_amt, area)


func _on_stats_no_health():
	queue_free()
