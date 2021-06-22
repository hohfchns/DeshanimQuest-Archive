extends Resource
class_name LinkedList

var head: LinkedObject = null
var tail: LinkedObject = null


func _init(objects: Array):
	if not objects:
		return
	
	for object in objects:
		add_item(object)

func add_item(object: LinkedObject):
	pass
