extends TabContainer

export(NodePath) onready var __save_close_button = get_node(__save_close_button) as Button
export(NodePath) onready var __load_close_button = get_node(__load_close_button) as Button


func _ready():
	__connect_signals()


func __connect_signals():
	__save_close_button.connect("pressed", self, "__on_close_button_pressed")
	__load_close_button.connect("pressed", self, "__on_close_button_pressed")


func __on_close_button_pressed():
	queue_free()
