extends Button

export(NodePath) onready var __spawnables_list = get_node(__spawnables_list) as ScrollContainer


func _ready():
	connect("mouse_entered", self, "_on_mouse_entered")
	connect("mouse_exited", self, "_on_mouse_exited")


func _on_SpawnablesButton_pressed():
	__spawnables_list.visible = not __spawnables_list.visible


func _on_mouse_entered():
	GameManager.is_mouse_on_button = true

func _on_mouse_exited():
	GameManager.is_mouse_on_button = false
