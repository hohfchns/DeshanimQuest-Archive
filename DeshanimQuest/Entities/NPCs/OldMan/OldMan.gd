extends StaticBody2D


func interact():
	if get_node_or_null("DialogNode"):
		return
	
	var dialog = Dialogic.start("OldManHello")
	dialog.pause_mode = Node.PAUSE_MODE_PROCESS
	dialog.connect("timeline_end", self, "_on_dialog_end")
	$CanvasLayer.add_child(dialog)
	get_tree().paused = true


func _on_dialog_end(timeline_name):
	get_tree().paused = false
