extends Button


func _ready():
	connect("mouse_entered", self, "_on_mouse_entered")
	connect("mouse_exited", self, "_on_mouse_exited")


func _on_mouse_entered():
	GameManager.is_mouse_on_button = true

func _on_mouse_exited():
	GameManager.is_mouse_on_button = false
