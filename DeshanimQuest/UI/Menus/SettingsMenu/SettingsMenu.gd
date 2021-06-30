extends Control

export(NodePath) onready var __back_button = get_node(__back_button) as Button
export(NodePath) onready var __fullscreen_button = get_node(__fullscreen_button) as Button


func _ready():
	__fullscreen_button.connect("pressed", self, "_on_fullscreen_pressed")
	__back_button.connect("pressed", self, "stop")


func start():
	self.visible = true
	get_tree().paused = true
	
	GameManager.menus_ll.push_front(self)

func stop():
	self.visible = false
	get_tree().paused = false
	
	if GameManager.menus_ll.size:
		GameManager.menus_ll.pop_front()
		GameManager.menus_ll.tail.data.start()


func _on_fullscreen_pressed():
	OS.window_fullscreen = not OS.window_fullscreen
