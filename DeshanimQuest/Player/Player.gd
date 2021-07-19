class_name Player
extends KinematicBody2D

enum States { MOVE, DEAD }
var state = States.MOVE

var __stats = PlayerStats

export var __max_speed = Vector2(200, 200)
export var __acceleration_amt = 1500
export var __friction_amt = 1200

export(float) var __hand_distance = 20.0

export(float) var __invincibility_duration = 1.0

export(NodePath) onready var __hand_axis = get_node(__hand_axis) as Node2D
export(NodePath) onready var __hand_rot_point = get_node(__hand_rot_point) as Node2D
onready var __current_item = __hand_rot_point.get_child(0)

export(NodePath) onready var __hurtbox = get_node(__hurtbox) as Hurtbox

export(NodePath) onready var __interaction_area = get_node(__interaction_area) as Area2D

export(NodePath) onready var __body_anim = get_node(__body_anim) as AnimationPlayer

export(NodePath) onready var __effects_anim = get_node(__effects_anim) as AnimationPlayer

#export(NodePath) onready var __health_bar = get_node(__health_bar) as HealthBar
export(NodePath) onready var __canvas_layer = get_node(__canvas_layer) as CanvasLayer

export(NodePath) onready var __hotbar = get_node(__hotbar) as HBoxContainer

export(NodePath) onready var save_load_ui = get_node(save_load_ui) as Panel
export(NodePath) onready var settings_menu = get_node(settings_menu) as Control


var __can_attack: bool = true
var __can_move: bool = true

var __input_vector = Vector2(0, 0)
var __last_input_vector = Vector2(1, 0)

var __velocity = Vector2(0, 0)


func _ready():
	randomize()
	
	__connect_signal_functions()


func _physics_process(delta):
	
	if state == States.MOVE:
		__calc_input_vector()
		
		__movement_code(delta)
		
		__animate_sprites()
		
		__set_hand_rot()
		
		__get_player_input()
		
		__last_input_vector = __input_vector if __input_vector else __last_input_vector


func __connect_signal_functions():
	__stats.connect("health_changed", self, "_on_stats_health_changed")
	__stats.connect("no_health", self, "_on_stats_no_health")
	
	connect("tree_entered", self, "_on_tree_entered")
	
	__hurtbox.connect("area_entered", self, "_on_hurtbox_entered")
	__hurtbox.connect("invincibility_started", self, "_on_hurtbox_invincibility_started")
	__hurtbox.connect("invincibility_ended", self, "_on_hurtbox_invincibility_ended")
	
	__hotbar.connect("selected_item_changed", self, "_on_selected_item_changed")
	
	GameEvents.connect("dialogue_started", self, "_on_dialogue_started")
	GameEvents.connect("dialogue_ended", self, "_on_dialogue_ended")


func __calc_input_vector():
	__input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	__input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	__input_vector = __input_vector.normalized()


func __movement_code(delta):
	if __input_vector != Vector2.ZERO:
		__velocity = __velocity.move_toward(__input_vector * __max_speed, __acceleration_amt * delta)
	else:
		__velocity = __velocity.move_toward(Vector2(0, 0), __friction_amt * delta)
	
	move_and_collide(__velocity * delta)


func __animate_sprites():
#	var moving: bool = __input_vector != Vector2.ZERO
	var rot = __hand_axis.rotation_degrees
	
	if __velocity:
		if get_global_mouse_position() > self.global_position:
			__body_anim.play("RunRight")
		else:
			__body_anim.play("RunLeft")
	elif not __velocity:
		if get_global_mouse_position() > self.global_position:
			__body_anim.play("IdleRight")
		else:
			__body_anim.play("IdleLeft")


func __set_hand_rot():
	
	if get_global_mouse_position() > self.get_global_position():
		__hand_axis.scale.x = 1
	else:
		__hand_axis.scale.x = -1
	
	__hand_rot_point.look_at(get_global_mouse_position())


func __play_current_item_anim(var anim_name: String):
	var ap = __current_item.get_node("AnimationPlayer") as AnimationPlayer
	ap.play(anim_name)

func __use_current_item(action):
	if GameManager.is_mouse_on_button:
		return
	__current_item.use(action)


func __get_player_input():
	if __current_item:
		if Input.is_action_just_pressed("use_item"):
			__use_current_item("main")
		elif Input.is_action_just_pressed("alt_use_item"):
			__use_current_item("alt")
	
	if Input.is_action_just_pressed("Interact"):
		if __interaction_area.get_overlapping_bodies():
			var object = __interaction_area.get_overlapping_bodies()[0]
			object.interact()
		elif __interaction_area.get_overlapping_areas():
			var object = __interaction_area.get_overlapping_areas()[0]
			object.interact()


func set_current_item(item_ref, slot_index):
	for node in __hand_rot_point.get_children():
		__hand_rot_point.remove_child(node)
	
	__hand_rot_point.add_child(item_ref)
	
	for node in __hand_rot_point.get_children():
		if node.name == item_ref.name:
			__current_item = node
			break
	
	__current_item.position.x = __hand_distance
	
	if "slot_index" in __current_item:
		__current_item.slot_index = slot_index


func _on_stats_health_changed():
	pass


func _on_stats_no_health():
	state = States.DEAD
	
	self.visible = false
	
	for menu in __canvas_layer.get_children():
		if menu.has_method("stop"):
			menu.stop()
		else:
			menu.visible = false
	
	save_load_ui.start()
	save_load_ui.toggle_load()
	save_load_ui.close_button.visible = false
	save_load_ui.quit_button.visible = true
	save_load_ui.save_toggle_button.visible = false


func _on_selected_item_changed(item_instance, slot_index):
	set_current_item(item_instance, slot_index)


func _on_hurtbox_entered(area):
	__hurtbox.start_invincibility(__invincibility_duration)
	
	var damage_to_take = area.damage / __hurtbox.get_overlapping_areas().size()
	__stats.subtract_health(damage_to_take)

func _on_hurtbox_invincibility_started():
	__effects_anim.play("HitBlinkStart")

func _on_hurtbox_invincibility_ended():
	__effects_anim.play("HitBlinkStop")


func _on_dialogue_started():
	__hotbar.visible = false

func _on_dialogue_ended():
	__hotbar.visible = true


func _on_tree_entered():
	GameManager.generate_player_ref()

func _on_Player_tree_entered():
	GameManager.generate_player_ref()



func __debug_call(what_to_debug):
	if what_to_debug == "linked_list":
		var ll = LinkedList.new(["object1", "object2", ["object3_1, object3_2"], 4])
		print(ll.get_forward_string())
		print(ll.get_forward_list())
		print("Head is %s" % str(ll.head.data))
		print("Tail is %s" % str(ll.tail.data))
		print("Size is %s" % ll.size)
		ll.push_back("object_back")
		print(ll.get_forward_string())
		print("New head is %s" % str(ll.head.data))
		print("New size is %s" % ll.size)
		ll.insert_at_index(1, "index_object")
		print(ll.get_forward_string())
		ll.pop_front()
		print(ll.get_forward_string())
