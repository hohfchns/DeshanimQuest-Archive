extends Node2D

var current_spawner = null

export(NodePath) onready var __animation_player = get_node(__animation_player) as AnimationPlayer

export(NodePath) onready var __spawn_pos_line = get_node(__spawn_pos_line) as Line2D

export(NodePath) onready var __spawnables_list_ui = get_node(__spawnables_list_ui) as VBoxContainer


func _ready():
	call_deferred("__create_spawn_buttons")


func _process(delta):
	__spawn_pos_line.points[0] = self.global_position


func use(action):
	if action == "main":
		if not current_spawner:
			return
		
		__spawn_current_spawner()


func __spawn_current_spawner():
	var mouse_position = get_global_mouse_position()
	
	__spawn_pos_line.points[1] = mouse_position
	__animation_player.play("Spawn")
	__animation_player.seek(0.0)
	
	var spawned_scene = current_spawner.scene_to_spawn.instance()
	
	if "sprite_offset" in spawned_scene:
		spawned_scene.global_position = mouse_position - spawned_scene.sprite_offset
	else:
		spawned_scene.global_position = mouse_position
	
	var world = GameManager.get_player("UtilityGun").get_parent()
	world.add_child(spawned_scene)


func __create_spawn_buttons():
	for spawnable in SpawnableItemsDatabase.spawnables:
		var spawnable_ui = preload("res://Items/Items/Utility/UtilityGun/UI/SpawnableItemUI.tscn").instance()
		
		spawnable_ui.spawnable = spawnable
		
		spawnable_ui.connect("spawn_button_pressed", self, "_on_spawn_button_pressed")
		
		__spawnables_list_ui.add_child(spawnable_ui)


func _on_spawn_button_pressed(spawnable):
	current_spawner = spawnable
