extends Panel

export(NodePath) onready var __ranger_panel = get_node(__ranger_panel) as Panel
export(NodePath) onready var __warrior_panel = get_node(__warrior_panel) as Panel

var start_scene = preload("res://Levels/Testing/TestScene.tscn")

func _ready():
	__ranger_panel.connect("gui_input", self, "_on_ranger_panel_input")
	__warrior_panel.connect("gui_input", self, "_on_warrior_panel_input")


func _on_ranger_panel_input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			PlayerStats.set_class(PlayerStats.Classes.RANGER)
			
			get_tree().call_deferred("change_scene_to", start_scene)

func _on_warrior_panel_input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			PlayerStats.set_class(PlayerStats.Classes.WARRIOR)
			
			get_tree().call_deferred("change_scene_to", start_scene)
