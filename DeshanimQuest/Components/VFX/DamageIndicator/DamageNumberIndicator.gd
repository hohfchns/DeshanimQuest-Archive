class_name DamageNumberIndicator
extends Control

export(float) var distance_to_travel = 10.0
export(float) var travel_duration = 0.5
export(float) var opacity_duration = 0.7

var __dmg_txt_opacity: float = 1.0

export(NodePath) onready var __damage_text = get_node(__damage_text) as RichTextLabel
export(NodePath) onready var position_tween = get_node(position_tween) as Tween
export(NodePath) onready var opacity_tween = get_node(opacity_tween) as Tween


func _ready():
	self.visible = false
	
	set_text_number(5)

func _process(delta):
	 __damage_text.modulate.a = __dmg_txt_opacity


func animate():
	__damage_text.rect_position = Vector2(-56, -12)
	
	__dmg_txt_opacity = 1.0
	
	self.visible = true
	
	position_tween.interpolate_property(__damage_text, \
	"rect_position", \
	__damage_text.rect_position, \
	__damage_text.rect_position - Vector2(0, distance_to_travel), \
	travel_duration, \
	Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	
	opacity_tween.interpolate_property(self, "__dmg_txt_opacity", 1.0, 0.0, opacity_duration,
	Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	
	position_tween.start()
	opacity_tween.start()
	
	opacity_tween.connect("tween_completed", self, "_on_tween_completed")
	


func set_text_number(value: int):
	__damage_text.bbcode_text = "[center]" + str(value) + "[/center]"


func start(damage_value: int = __damage_text):
	set_text_number(damage_value)
	animate()


func _on_tween_completed():
	self.visible = false
