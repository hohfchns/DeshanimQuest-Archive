extends KinematicBody2D

onready var __stats = $Stats

onready var __ai_controller = $SlimeAI

onready var __soft_collision = $SoftCollision
onready var __hurtbox = $Hurtbox

onready var __anim = $AnimationPlayer
onready var __effects_animation_player = $EffectsAP

onready var __damage_number_indicator = $DamageNumberIndicator


export var __knockback_multiplier: float = 0.8
export var __soft_collision_multiplier: float = 2000.0

export(float) var __flash_time = 0.1


var __death_effect = preload("res://Entities/Enemies/DeathEffect/EnemyDeathEffect.tscn")


func _ready():
	__stats.connect("no_health", self, "_on_stats_no_health")
	
	__ai_controller.connect("state_changed", self, "_on_ai_state_changed")
	__hurtbox.connect("area_entered", self, "_on_hurtbox_area_entered")


func _physics_process(delta):
	if __soft_collision.is_colliding():
		__ai_controller.actor_velocity += __soft_collision.get_push_vector() * delta * __soft_collision_multiplier


func _on_ai_state_changed(new_state):
	if new_state == __ai_controller.States.CHASE:
		__anim.play("Move")
	elif new_state == __ai_controller.States.WANDER:
		__anim.play("Move")


func __start_hit_effect(duration):
	__effects_animation_player.play("Flash")

func __take_hit(damage: int, knockback_amt, hitter):
	var knockback_to_take = __knockback_multiplier\
	* knockback_amt\
	* hitter.get_parent().global_position.direction_to(self.global_position)
	__ai_controller.actor_velocity += knockback_to_take
	
	var multiplier: float = 1
	if hitter.damage_type == Hitbox.DamageTypes.MELEE:
		multiplier += PlayerStats.str_damage_mult_amt * PlayerStats.get_stats()["STR"]
	elif hitter.damage_type == Hitbox.DamageTypes.MAGIC:
		multiplier += PlayerStats.int_damage_mult_amt * PlayerStats.get_stats()["INT"]
	elif hitter.damage_type == Hitbox.DamageTypes.RANGED:
		multiplier += PlayerStats.dex_damage_mult_amt * PlayerStats.get_stats()["DEX"]
	
	var damage_to_take = damage * multiplier
	
	__stats.subtract_health(damage_to_take)
	
	__damage_number_indicator.start(damage_to_take)
	
	__start_hit_effect(__flash_time)

func on_hitray_hit(hitray: Hitray):
	__take_hit(hitray.damage, hitray.knockback_amt, hitray)

func _on_hurtbox_area_entered(area: Hitbox):
	__take_hit(area.damage, area.knockback_amt, area)


func _on_stats_no_health():
	var effect = __death_effect.instance()
	effect.global_position = self.global_position
	
	get_parent().add_child(effect)
	
	queue_free()
