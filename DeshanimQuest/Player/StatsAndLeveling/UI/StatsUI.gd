extends Panel

export(NodePath) onready var __health_bar = get_node(__health_bar) as ProgressBar
export(NodePath) onready var __stamina_bar = get_node(__stamina_bar) as ProgressBar
export(NodePath) onready var __mana_bar = get_node(__mana_bar) as ProgressBar

export(NodePath) onready var __stat_points_amt = get_node(__stat_points_amt) as Label

export(NodePath) onready var __vit = get_node(__vit) as HBoxContainer
export(NodePath) onready var __end = get_node(__end) as HBoxContainer
export(NodePath) onready var __str = get_node(__str) as HBoxContainer
export(NodePath) onready var __dex = get_node(__dex) as HBoxContainer
export(NodePath) onready var __res = get_node(__res) as HBoxContainer
export(NodePath) onready var __int = get_node(__int) as HBoxContainer

func _ready():
	PlayerStats.connect("stats_changed", self, "_on_stats_changed")
	
	PlayerStats.connect("stat_points_changed", self, "_on_stat_points_changed")
	
	PlayerStats.connect("health_changed", self, "__update_bars")
	PlayerStats.connect("max_health_changed", self, "__update_bars")
	PlayerStats.connect("stamina_changed", self, "__update_bars")
	PlayerStats.connect("max_stamina_changed", self, "__update_bars")
	PlayerStats.connect("mana_changed", self, "__update_bars")
	PlayerStats.connect("max_mana_changed", self, "__update_bars")
	
	__connect_buttons()
	
	__update_bars()
	__update_stats(PlayerStats.get_stats())
	
	_on_stat_points_changed()


func __connect_buttons():
	__vit.get_node("PlusButton").connect("pressed", self, "__add_stat", ["VIT"])
	__vit.get_node("MinusButton").connect("pressed", self, "__subtract_stat", ["VIT"])
	__end.get_node("PlusButton").connect("pressed", self, "__add_stat", ["END"])
	__end.get_node("MinusButton").connect("pressed", self, "__subtract_stat", ["END"])
	__str.get_node("PlusButton").connect("pressed", self, "__add_stat", ["STR"])
	__str.get_node("MinusButton").connect("pressed", self, "__subtract_stat", ["STR"])
	__dex.get_node("PlusButton").connect("pressed", self, "__add_stat", ["DEX"])
	__dex.get_node("MinusButton").connect("pressed", self, "__subtract_stat", ["DEX"])
	__res.get_node("PlusButton").connect("pressed", self, "__add_stat", ["RES"])
	__res.get_node("MinusButton").connect("pressed", self, "__subtract_stat", ["RES"])
	__int.get_node("PlusButton").connect("pressed", self, "__add_stat", ["INT"])
	__int.get_node("MinusButton").connect("pressed", self, "__subtract_stat", ["INT"])


func start():
	GameManager.menus_ll.push_front(self)
	self.visible = true

func stop():
	self.visible = false
	GameManager.menus_ll.pop_front()


func __update_bars():
	var health_amt = __health_bar.get_node("DoubleLabel").get_node("AmtLabel") as Label
	var stamina_amt = __stamina_bar.get_node("DoubleLabel").get_node("AmtLabel") as Label
	var mana_amt = __mana_bar.get_node("DoubleLabel").get_node("AmtLabel") as Label
	
	__health_bar.max_value = PlayerStats.get_max_health()
	__stamina_bar.max_value = PlayerStats.get_max_stamina()
	__mana_bar.max_value = PlayerStats.get_max_mana()
	
	__health_bar.value = PlayerStats.get_health()
	__stamina_bar.value = PlayerStats.get_stamina()
	__mana_bar.value = PlayerStats.get_mana()
	
	health_amt.text = str(PlayerStats.get_health()) + "/" + str(PlayerStats.get_max_health())
	stamina_amt.text = str(PlayerStats.get_stamina()) + "/" + str(PlayerStats.get_max_stamina())
	mana_amt.text = str(PlayerStats.get_mana())  + "/" + str(PlayerStats.get_max_mana())


func __update_stats(new_stats):
	__vit.get_node("AmtLabel").text = str(new_stats["VIT"])
	__end.get_node("AmtLabel").text = str(new_stats["END"])
	__str.get_node("AmtLabel").text = str(new_stats["STR"])
	__dex.get_node("AmtLabel").text = str(new_stats["DEX"])
	__res.get_node("AmtLabel").text = str(new_stats["RES"])
	__int.get_node("AmtLabel").text = str(new_stats["INT"])


func __add_stat(stat):
	if not PlayerStats.get_stat_points():
		return
	var stats = PlayerStats.get_stats()
	
	stats[stat] += 1
	
	PlayerStats.set_stats(stats)
	PlayerStats.set_stat_points(PlayerStats.get_stat_points() - 1)

func __subtract_stat(stat):
	var stats = PlayerStats.get_stats()
	
	if not stats[stat] > 0:
		return
	
	stats[stat] -= 1
	
	PlayerStats.set_stats(stats)
	PlayerStats.set_stat_points(PlayerStats.get_stat_points() + 1)


func _on_stats_changed(old_stats, new_stats):
	__update_stats(new_stats)


func _on_stat_points_changed():
	__stat_points_amt.text = str(PlayerStats.get_stat_points())


func _input(event):
	if event.is_action_pressed("toggle_stats_ui"):
		if self.visible:
			stop()
		else:
			start()
	elif event.is_action_pressed("ui_cancel"):
		if not self.visible:
			return
		
		self.visible = false
		GameManager.menus_ll.call_deferred("pop_front")
