extends RayCast2D
class_name Hitray

enum DamageTypes { MELEE, MAGIC, RANGED }
export(DamageTypes) var damage_type

export(int) var damage
export(float) var knockback_amt


func try_hit(group):
	if is_colliding():
		var collider = get_collider()
		
		if not collider.is_in_group(group):
			return
		
		if collider.has_method("on_hitray_hit"):
			collider.on_hitray_hit(self)
