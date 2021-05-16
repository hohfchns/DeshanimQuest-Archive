extends Node

var __player_ref = null


func generate_player_ref():
	__player_ref = get_node("/root/SceneRoot/YSort/Player")
	

func get_player():
	if __player_ref:
		return __player_ref
	else:
		print("Player not in scene!")
