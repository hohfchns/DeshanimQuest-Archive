extends Control

export(NodePath) onready var __resume_button = get_node(__resume_button) as Button
export(NodePath) onready var __save_load_button = get_node(__save_load_button) as Button
export(NodePath) onready var __settings_button = get_node(__settings_button) as Button
export(NodePath) onready var __quit_button = get_node(__quit_button) as Button

onready var player = GameManager.get_player("PauseMenu") as Player


func _ready():
	player = GameManager.get_player("PauseMenu")
	
	__resume_button.connect("pressed", self, "toggle")
	__save_load_button.connect("pressed", self, "_on_save_load_pressed")
	__settings_button.connect("pressed", self, "_on_settings_pressed")
	__quit_button.connect("pressed", self, "_on_quit_pressed")


func start():
	if not GameManager.menus_ll.get_forward_list():
		GameManager.menus_ll.push_front(self)
	self.visible = true
	get_tree().paused = true

func stop():
	GameManager.menus_ll.pop_front()
	self.visible = false
	get_tree().paused = false


func _on_save_load_pressed():
	self.visible = false
	
	player.save_load_ui.start()


func _on_settings_pressed():
	self.visible = false
	
	player.settings_menu.start()


func _on_quit_pressed():
	get_tree().quit()


func toggle():
	if self.visible == true:
		stop()
	elif self.visible == false and GameManager.menus_ll.get_forward_list() == []:
		start()

func _input(event):
	if event.is_action_pressed("toggle_pause_menu"):
		toggle()
