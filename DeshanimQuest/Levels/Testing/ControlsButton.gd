extends Button


func _ready():
	pass


func _on_ControlsButton_pressed():
	get_parent().get_node("ControlsText").visible = not get_parent().get_node("ControlsText").visible
