extends Position2D


func _ready():
	yield(get_parent(), "ready")
	
	var player_ref = load("res://Player/Classes/%s/%sPlayer.tscn" % [PlayerStats.current_class_name, PlayerStats.current_class_name])
#	print("res://Player/Classes/%s/%sPlayer.tscn" % [PlayerStats.current_class_name, PlayerStats.current_class_name])
	var player = player_ref.instance()

	player.global_position = self.global_position
	get_parent().add_child(player)

