class_name Hitbox
extends Area2D

enum DamageTypes { MELEE, MAGIC, RANGED }
export(DamageTypes) var damage_type

export(int) var damage
export(int) var knockback_amt

export(NodePath) var __wall_detect_area_path
var __wall_detect_area: Area2D

export(NodePath) var __actor_path
var __actor

func _ready():
	if __wall_detect_area_path:
		__wall_detect_area = get_node(__wall_detect_area_path) as Area2D
	
	if __actor_path:
		__actor = get_node(__actor_path)


func check_for_walls():
	if not __wall_detect_area.get_overlapping_areas():
		print("return")
		return
	
	var hurtbox_pos = __wall_detect_area.get_overlapping_areas()[0].global_position
	
	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_ray(__actor.global_position, hurtbox_pos, [], 128)
	
	if result:
		self.monitorable = false
	else:
		self.monitorable = true
