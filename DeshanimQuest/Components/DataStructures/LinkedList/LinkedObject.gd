extends Resource
class_name LinkedObject

var data

var next
var prev


func _init(data, next, prev):
	self.data = data
	self.next = next
	self.prev = prev
