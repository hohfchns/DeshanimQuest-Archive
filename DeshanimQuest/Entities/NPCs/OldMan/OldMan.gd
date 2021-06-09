extends StaticBody2D


func interact():
	if get_node_or_null("DialogNode"):
		return
	
	var dialog = Dialogic.start("OldManHello")
	dialog.pause_mode = Node.PAUSE_MODE_PROCESS
	dialog.connect("timeline_end", self, "_on_dialog_end")
	$DialogueCanvasLayer.add_child(dialog)
	GameEvents.emit_signal("dialogue_started")
	get_tree().paused = true


func _on_dialog_end(timeline_name):
	GameEvents.emit_signal("dialogue_ended")
	get_tree().paused = false
