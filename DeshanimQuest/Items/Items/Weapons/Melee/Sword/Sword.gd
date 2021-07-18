extends Node2D

export(NodePath) onready var anim = get_node(anim) as AnimationPlayer

onready var wall_check = $WallCheckRay
onready var swing_hitbox = $SwingHitbox
onready var stab_hitbox = $Stabhitbox


func use(action):
	if anim.is_playing():
		return
	
	if action == "main":
		anim.play("Swing")
	elif action == "alt":
		anim.play("Stab")


func check_for_walls():
	if wall_check.is_colliding():
		swing_hitbox.monitorable = false
		stab_hitbox.monitorable = false
	else:
		swing_hitbox.monitorable = true
		stab_hitbox.monitorable = true
