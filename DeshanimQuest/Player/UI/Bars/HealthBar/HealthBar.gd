class_name HealthBar
extends TextureProgress

var __stats = PlayerStats


func _ready():
#	self.visible = true
	
	__stats.connect("health_changed", self, "_on_stats_health_changed")

func _on_stats_health_changed():
	self.max_value = __stats.get_max_health()
	self.value = __stats.get_health()
