extends Node2D

export(NodePath) onready var anim = get_node(anim) as AnimationPlayer

func use(action):
	if anim.is_playing():
		return
	
	if action == "main":
		anim.play("Swing")
	elif action == "alt":
		anim.play("Stab")

