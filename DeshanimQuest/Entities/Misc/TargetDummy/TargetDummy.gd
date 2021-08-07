extends StaticBody2D

export(NodePath) onready var hurtbox = get_node(hurtbox) as Hurtbox
export(NodePath) onready var damage_number_indicator = get_node(damage_number_indicator) as Control

func _ready():
	hurtbox.connect("area_entered", self, "_on_hurtbox_area_entered")
	


func __take_hit(damage: int, hitter):
	var multiplier: float = 1
	if hitter.damage_type == Hitbox.DamageTypes.MELEE:
		multiplier += PlayerStats.str_damage_mult_amt * PlayerStats.get_stats()["STR"]
		print("target dummy hit with melee")
	elif hitter.damage_type == Hitbox.DamageTypes.MAGIC:
		multiplier += PlayerStats.int_damage_mult_amt * PlayerStats.get_stats()["INT"]
		print("target dummy hit with magic")
	elif hitter.damage_type == Hitbox.DamageTypes.RANGED:
		multiplier += PlayerStats.dex_damage_mult_amt * PlayerStats.get_stats()["DEX"]
		print("target dummy hit with gun")
	
	var damage_to_take = damage * multiplier
	
	damage_number_indicator.start(damage_to_take)


func on_hitray_hit(hitray: Hitray):
	__take_hit(hitray.damage, hitray)
	print("hit")

func _on_hurtbox_area_entered(area: Hitbox):
	__take_hit(area.damage, area)

