extends Label

var __stats = PlayerStats


func _ready():
	__stats.connect("no_health", self, "_on_stats_no_health")


func _on_stats_no_health():
	self.visible = true
