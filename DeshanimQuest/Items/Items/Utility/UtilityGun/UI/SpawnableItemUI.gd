extends VBoxContainer

var spawnable = null

export(NodePath) onready var spawn_button = get_node(spawn_button) as Button
export(NodePath) onready var spawn_texture = get_node(spawn_texture) as TextureRect

signal spawn_button_pressed(spawnable)

func _ready():
#	connect("mouse_entered", self, "_on_mouse_entered")
#	connect("mouse_exited", self, "_on_mouse_exited")
	
	spawn_button.connect("pressed", self, "_on_spawn_button_pressed")
	
	if not spawnable:
		return
	
	spawn_button.text = spawnable.spawnable_name
	spawn_texture.texture = spawnable.icon


func _on_spawn_button_pressed():
	emit_signal("spawn_button_pressed", self.spawnable)


#func _on_mouse_entered():
#	GameManager.is_mouse_on_button = true
#
#func _on_mouse_exited():
#	GameManager.is_mouse_on_button = false
