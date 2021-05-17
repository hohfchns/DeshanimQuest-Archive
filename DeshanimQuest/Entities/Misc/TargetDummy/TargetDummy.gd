extends StaticBody2D

export(NodePath) onready var hurtbox = get_node(hurtbox) as Hurtbox
export(NodePath) onready var damage_number_indicator = get_node(damage_number_indicator) as Control

func _ready():
	hurtbox.connect("area_entered", self, "_on_hurtbox_area_entered")
	


func _on_hurtbox_area_entered(area: Hitbox):
	print("entered")
	
	
	damage_number_indicator.start(area.damage)

